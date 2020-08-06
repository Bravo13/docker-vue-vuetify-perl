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
    <Menu/>
    <v-main>
      <router-view></router-view>
    </v-main>
  </v-app>
</template>

<script>
import Auth from './components/Auth';
import Menu from './components/Menu';

export default {
  name: 'App',

  components: {
    Auth,
    Menu
  },

  data: () => ({
  }),

  methods: {
  }
};
</script>
