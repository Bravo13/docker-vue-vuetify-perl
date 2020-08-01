<template>
  <v-btn
    v-google-signin-button="clientId"
    color="red"
    fab
    v-bind:loading="is_loading"
  >
    <v-icon>mdi-google</v-icon>
  </v-btn>
</template>

<script>
import GoogleSignInButton from 'vue-google-signin-button-directive'
import axios from 'axios';
export default {
    directives: {
        GoogleSignInButton
    },
    data: () => ({
        is_loading: false,
        clientId: '534690010443-u4q8reg6m8rtf15p36j3lkn7rufrq2k1.apps.googleusercontent.com'
    }),
    methods: {
        OnGoogleAuthSuccess (idToken) {
            this.is_loading = true;
            axios.post('/auth/google', { code: idToken })
            .then( (response) => {
                this.is_loading = false;
                this.$store.commit('auth/setAuthToken', response.data.token);
                console.log("I'm logged", response.data.token);
            })
            .catch((e) => {
                this.is_loading = false;
                console.error(e);
            });
        },
        OnGoogleAuthFail (error) {
            this.is_loading = false;
            console.log(error)
        }
    }
}
</script>

<style>
</style>