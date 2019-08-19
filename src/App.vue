<template>
  <v-app>
    <div v-if="loaderShown">
      <Spin/>
    </div>  
    <v-navigation-drawer
      v-model="drawer"
      mobile-break-point="600"
      clipped
      app
      width="200"
    >
      <div v-if="user.userId > 0">
        <v-card class='menu-buttons'>
          <v-card-text>
            <v-btn
              v-if="shift.id == 0"
              @click="openShift" 
              color="success">
            Open Shift
            </v-btn>
            <v-btn
              v-if="shift.id > 1" 
              @click="closeShift" 
              color="success">
            Close Shift
            </v-btn>
            <v-btn
              v-if="shift.id > 1" 
              @click="shiftReport" 
              color="success">
            Shift Report
            </v-btn>
            <v-btn
              v-if="shift.id == 0"
              @click="reopenShift"
              color="success"
              >Reopen Shift</v-btn>
          </v-card-text>
        </v-card>
      </div>
      <v-list dense>
        <!--
          Note the "/" before each route.
          If these are absent, it will route correctly when clicking on these links
          but after a programatically executed route change (ie /reservations/13),
          these links will no longer work correctly.
          Confusing as hell, point being
          DO NOT OMIT THE PRECEDING FORWARD SLASH
        -->
        
        <v-list-item to="/home">
          <v-list-item-action>
            <v-icon>mdi-home</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Home</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        
        <v-list-item v-if="!userIsLoggedIn" to="/login" >
          <v-list-item-action>
            <v-icon>mdi-account</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title >Login</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        
        <v-list-item  v-if="userIsLoggedIn" @click="logoff" >
          <v-list-item-action>
            <v-icon>mdi-account</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title >Logoff</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <!-- from here down, only visible to logged in users -->
        <div v-if="user.userId > 0">
          <v-list-item to="/resTable">
            <v-list-item-action>
              <v-icon>mdi-table-large</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>ResTable</v-list-item-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item to="/calendarView">
            <v-list-item-action>
              <v-icon>mdi-table-large</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>CalendarView</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </div>

        

        <!-- from here down, only visible to logged userw permission > 7 --> 
        <div v-if="user.permission > 7">
          <v-list-item v-ripple to="/adminPanel">
            <v-list-item-icon>
              <v-icon>mdi-account</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title >Admin Panel</v-list-item-title>
            </v-list-item-content>
          </v-list-item>


         </div>        

      </v-list>
      <div>
        ShiftId: {{ shift.id }} <br/>
        UserIsLoggedIn: {{ userIsLoggedIn }}
      </div>
    </v-navigation-drawer>
    <v-app-bar color="indigo" dense app>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" ></v-app-bar-nav-icon>
      <v-toolbar-title>Lazy Lizard Reservations</v-toolbar-title>
      <v-spacer></v-spacer>

    </v-app-bar>
    <v-content>
      <v-container fluid >
          <router-view></router-view>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
  import api from './api/api.js'
  import Spin from './components/spin.vue' 
  export default {
    components: {
      Spin
    },
    created: function(){
      //load initial space information
      var self = this;
      api.getSpaces().then( function(response){
        self.$store.commit('setSpaces', response.data.spaces);
      });
      api.getSpaceTypes().then( function(response){
        self.$store.commit('setSpaceTypes', response.data.space_types);
      });
      api.getSelectGroups().then( function(response){
        self.$store.commit('setSelectGroups', response.data.selectGroups);
      });
      api.getReservations().then( function(response){
        self.$store.commit('setReservations', response.data);
      });
      api.getSaleTypes().then( function(response){
        console.log("sale types", response );
      });
      api.getTaxTypes().then( function( response ){
        self.$store.commit( 'setTaxTypes', response.data.tax_types );
      });
    },
    computed: {
      loaderShown: function(){
        return this.$store.getters.getLoaderShown
      },
      routeIsResTable: function(){
        if(this.$route.name == 'resTable'){
          return true;
        }else{
          return false;
        }
      },
      shift: function(){
        return this.$store.getters.getShift
      },
      user: function(){
        return this.$store.getters.getUser
      },
      userIsLoggedIn: function(){
        if(this.user.userId > 0){
          return true;
        } else {
          return false;
        }
      }
    },
    data: function(){
        return {
            drawer: null,
            
            resDatePicker: false,
            resStart: '2019-05-21',
         }
    },
    methods: {
      closeShift: function(){
        let self = this;
        alert("When built out, user will have to complete shift termination procedures here.");
        api.closeShift( this.user, this.shift ).then( function( response ){
          console.log("closeShift", response )
          if( response.data.execute == true ){
            self.$store.commit('setShiftClosed')
          }
        })
      },
      logoff: function(){
        //logoff
        console.log("user before logoff", this.user);
        this.$store.commit('setUserToGuest');
        console.log("user after logoff", this.user);
        api.logoff(this.user.userId, this.user.key).then( (response ) => {
            console.log("logoff response:", response);
        });
        //clear sessionStorage
        sessionStorage.clear()
        //regardless, nav home
        this.$router.push('/home');
      },
      reopenShift: function(){
        this.$router.push( { name: 'reopen-shift', params: { userId: parseInt(this.user.userId) } } );
        /*
        api.reopenShiftOptions( this.user ).then( function( response ) {
          console.log("reopen response", response )
        });
        */
      },
      openShift: function(){
        let self = this;
        //let startDate = moment().format("YYYY MM DD;
        api.openShift(this.user).then( function(response){
          console.log("response");
          self.$store.commit('setShift', response.data.shift);
        });

      },
      shiftReport: function(){
        //navigate to shift report
        let shiftId = this.shift.id;
        this.$router.push( { name: 'shiftReport', params: { shiftId: shiftId } });
      }
    },
    name: 'App',
    props: {
      source: String
    }
  }
</script>

<style>
.menu-buttons button{
  margin-bottom: 5px;
}

</style>
