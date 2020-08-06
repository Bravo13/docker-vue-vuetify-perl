import Vue from 'vue'
import Vuex from 'vuex'

import auth from './modules/auth';

import axios from 'axios';

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  },
  mutations: {
  },
  actions: {
    call: function(context, reqData){
      let url = reqData.url;
      let data = reqData.data || {};
      const that = this;
      data.token = context.rootGetters['auth/getAuthToken'];
      return axios.post(url, data)
        .catch((e)=>{
          const response = e.response;
          const status = response.status;
          const data = response.data;
          if( status == 400 ){
            that._vm.$dialog.message.error(data.error, {
              position: 'top-right'
            });
          } else {
            that._vm.$dialog.message.error('Somethiing went wrong', {
              position: 'top-right'
            });
            console.error(response);
          }
        });
    }
  },
  modules: {
    auth
  }
})
