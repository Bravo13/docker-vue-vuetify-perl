package App::Controller::Auth;
use Dancer2 appname => 'App';
use Dancer2::Plugin::Routes;
use Dancer2::Plugin::Redis;
use Dancer2::Plugin::Notifications;
use Dancer2::Plugin::DBIC;

register_route {
    method => "post",
    regexp => "/auth/phone",
    code => sub {
        my $params = request->data;
        my $response = {};

        my $phone = $params->{phone} // '';
        my $redis_confirm_code_key = "${phone}_confirm_code";
        if($params->{code}){
            # check phone in redis
            my $expected_confirm_code = redis_get($redis_confirm_code_key);
            unless($expected_confirm_code){
                status 'bad_request';
                $response->{error} = "Code expired. Send request again";
                return $response;
            }

            # check if confirmation code is ok
            unless($expected_confirm_code eq $params->{code}){
                status 'bad_request';
                $response->{error} = "Wrong confirmation code";
                return $response;
            }

            # get or create userprofile
            my $user_model = rset('User');
            my $user_entity = $user_model->find_or_create({ phone => $params->{phone} });

            # create token
            # store token in db and return to user
            my $token_model = rset('Token');
            my $token_entity = $token_model->create_new(
                owner_id => $user_entity->id,
                expire_time => time + 24 * 60 * 60,
                type => 'user'
            );
            $response->{token} = $token_entity->token;
            redis_del($redis_confirm_code_key);
        } else {

            # check phone
            if(
                $phone !~ /^\d{10}$/
            ) {
                status 'bad_request';
                $response->{error} = "Phone has wrong format";
                return $response;
            }
            
            # phone not blocked for sending codes
            # my $blocked = redis_get("${phone}_sms_code_blocked");
            my $redis_attempts_key = "${phone}_sms_auth_attempts";
            my $attempts = redis_get($redis_attempts_key) || 0;
            if($attempts >= 4){
                status 'bad_request';
                $response->{error} = "Too many attempts to send code. Wait a while";
                return $response;
            }

            # sending new code 
            redis_set($redis_attempts_key, ++$attempts);
            redis_expire($redis_attempts_key, 15 * 60); # set expiration time to 15 min

            my $confirmation_code = int(rand(9999));
            redis_set($redis_confirm_code_key, $confirmation_code);
            redis_expire($redis_confirm_code_key, 15 * 60); 
            send_sms($phone, 'auth_code', code => $confirmation_code);
            $response->{message} = "Code sent to phone. Code expires in 15 minutes";
        }

        return $response;
    }
};

1;