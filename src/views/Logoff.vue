<template>
  <div>
    <h4>Logoff</h4>
  </div>
</template>

<script>
  import api from './../api/api.js'
  export default{
    computed: {
      user: function(){
        return this.$store.getters.getUser;
      },
      userId: function() { return this.user.userId },
      key: function() { return this.user.key }
    
    },
    mounted: function(){
      
      api.logoff(this.userId, this.key).then( (response ) => {
          console.log("logoff response:", response);
          this.$store.commit('setUserToGuest');
        }
      );
      
    }
  
  }
</script>