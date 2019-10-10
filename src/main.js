import Vue from 'vue'
import vuetify from '@/plugins/vuetify'
import App from './App.vue'
import router from './router'
import store from './store'



Vue.config.productionTip = false



new Vue({
    created(){
      //see if we have a user in Session Storage
      //yes? commit it to store 
      if(sessionStorage.getItem('username') && sessionStorage.getItem('userId') && sessionStorage.getItem('permission') && sessionStorage.getItem('key')){
        let obj = {
          username: sessionStorage.getItem('username'),
          userId: sessionStorage.getItem('userId'),
          permission: sessionStorage.getItem('permission'),
          key: sessionStorage.getItem('key')
        };
        this.$store.commit('setUser', obj);
      //no? commit default 'Guest' user
      }else{
        this.$store.commit('setUserToGuest');
      }
    },
  vuetify,
  router,
  store,
  render: h => h(App)
}).$mount('#app')
