package App::Model::ResultSet::Group;

use Modern::Perl;
use Validator::LIVR;

use base 'DBIx::Class::ResultSet';

sub validator {
    my $self = shift;
    my %args = @_;

    unless( $args{skip_name} ){
        Validator::LIVR->register_default_rules( uniq => sub {
            my ($column_name, $rule_builders) =  @_;

            return sub {
                my ( $value, $all_values, $output_ref ) = @_;
                if ( $self->find({$column_name => $value}) ) {
                    return "NOT_UNIQ"
                }
            }
        });
    }

    return Validator::LIVR->new({
        !$args{skip_name} ? (
            name        => [ 'required', { min_length => 5 }, { max_length => $self->result_class->column_info('name')->{size} }, { uniq => 'name' } ]):(),
        title       => [ { min_length => 5 }, { max_length => $self->result_class->column_info('title')->{size} } ],
        description => [ { min_length => 5 }, { max_length => $self->result_class->column_info('description')->{size} } ],
    });
}

1;
