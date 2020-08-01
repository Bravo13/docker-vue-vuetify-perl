<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      <v-spacer></v-spacer>
      <div class="d-flex align-center">
        <Auth/>
      </div>


    </v-app-bar>

    <v-main>
      <HelloWorld/>
    </v-main>
  </v-app>
</template>

<script>
import HelloWorld from './components/HelloWorld';
import Auth from './components/Auth';

import axios from 'axios';

export default {
  name: 'App',

  components: {
    HelloWorld,
    Auth
  },

  data: () => ({
    axios
  }),

  methods: {
    http: () => this.axios
  }
};
</script>
