<template>
    <v-col>
        <v-btn
            color="teal"
            fab
            v-bind:loading="isLoading"
            @click.stop="showDialog=true"
        >
            <v-icon>mdi-phone</v-icon>
        </v-btn>
        <v-dialog
            v-model="showDialog"
        >
            <v-card>
                <v-card-title>
                    <span class="headline">Phone auth</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12" sm="6" md="4">
                                <v-text-field v-model="phoneNumber" label="Phone" required></v-text-field>
                            </v-col>
                            <v-col v-if="confirmationState" cols="12" sm="6" md="4">
                                <v-text-field label="Code" v-model="code" required></v-text-field>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn v-if="!confirmationState" color="blue" text @click="sendPhone()">Start auth</v-btn>
                    <v-btn v-if="confirmationState" color="blue" text @click="sendCode()">Confirm code</v-btn>
                    <v-btn v-if="confirmationState" color="blue" text @click="sendPhone()">Send code again</v-btn>
                    <v-btn color="blue" text @click="closeDialog()">Close</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-col>
</template>

<script>
import axios from 'axios';

export default {
    methods: {
        sendPhone(){
            this.isLoading = true;
            this.confirmationState = true;

            axios.post('/auth/phone', { phone: this.phoneNumber })
            .then( (response) => {
                this.isLoading = false;
                this.confirmationState = true;
            })
            .catch((e) => {
                this.isLoading = false;
                this.confirmationState = false;
                console.error(e);
            });
        },

        sendCode(){
            this.isLoading = true;
            this.confirmationState = true;

            axios.post('/auth/phone', { phone: this.phoneNumber, code: this.code })
            .then( (response) => {
                this.$store.commit('auth/setAuthToken', response.data.token);
                this.closeDialog();
            })
            .catch((e) => {
                this.isLoading = false;
                this.confirmationState = false;
                console.error(e);
            });
        },

        closeDialog(){
            this.confirmationState = false;
            this.showDialog = false;
            this.isLoading = false;
            this.code = '';
        }
    },
    data: () => ({
        showDialog: false,
        confirmationState: false,
        isLoading: false,
        phoneNumber: '',
        code: '',
    })
}
</script>