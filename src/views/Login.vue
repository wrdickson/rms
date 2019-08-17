<template>
  <div>
    <v-layout >
      <v-flex xs8 sm6 md4 lg3>
        <v-card>  
          <v-card-title primary-title> 
            <h3 class="headline mb-0">Login</h3>
          </v-card-title> 
          <v-card-text>
            <v-text-field
              v-model="username1"
              label="Username"
            >
            </v-text-field><br>
            <v-text-field 
              v-model="password1"
              label="Password"
              type='password'
            >
            </v-text-field><br>
          </v-card-text>    
          <v-card-actions>
            <v-btn 
              @click="loginCheck"
              color="primary"
              ripple
            >
              Login
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>
    </v-layout>
    
    <v-layout row>
      <v-flex xs12> 
        <hr>
        <div>Username: {{ user.username }} </div>
        <div>UserId: {{ user.userId }} </div>
        <div>UserPerm: {{ user.permission }} </div>
        <div>UserKey: {{ user.key }} </div>
        <hr>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import api from './../api/api.js'
export default{
  computed: {
    user: function(){
      return this.$store.getters.getUser;
    }
  },
  data: function(){
    return {
      username1: '',
      password1: ''
    }
  },
  methods: {
    loginCheck: function(){
      let self = this;
      this.$store.commit('showLoader');
      api.login(this.username1, this.password1).then( ( response ) => {
        this.$store.commit('hideLoader');
        if(response.data.login.pass > 0){
          //set session . . .
          sessionStorage.setItem("username", response.data.login.username);
          sessionStorage.setItem("userId", response.data.login.id);
          sessionStorage.setItem("permission", response.data.login.permission);
          sessionStorage.setItem("key", response.data.login.user_key);
          //set the store
          let obj = {
            userId: response.data.login.id,
            username: response.data.login.username,
            permission: response.data.login.permission,
            key: response.data.login.user_key
          };
          this.$store.commit('setUser', obj)
          //now look for an open shift
          api.getUserShift( response.data.login.id ).then( function( response ){
            console.log("openShift@login", response)
          });
        } else {
          //set session . . .
          sessionStorage.setItem("username", "Guest");
          sessionStorage.setItem("userId", 0);
          sessionStorage.setItem("permission", 0);
          sessionStorage.setItem("key", 0);
          this.$store.commit('setUserToGuest')
        }
        //either way, clear the inputs
        this.username1 = '',
        this.password1 = ''
        //go home
        self.$router.push('home');
      });
    }
  }
}
</script>

<style>

</style>