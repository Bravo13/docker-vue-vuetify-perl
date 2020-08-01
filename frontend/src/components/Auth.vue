<template>
    <v-container>
        <v-row>
            <v-col>
                <GoogleAuthButton/>
            </v-col>
            <PhoneAuthButton/>
        </v-row>
    </v-container>
</template>
<script>
import GoogleAuthButton from './Auth/Google'
import PhoneAuthButton from './Auth/Phone'
export default {
    name: "Auth",
    components: {
        GoogleAuthButton,
        PhoneAuthButton
    }
    
}
</script>