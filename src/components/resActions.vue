<template>
  <div>
    <v-btn
      v-if="showCheckin" 
      color="green"
      @click="checkin"
    >
      Check In
    </v-btn>
    <v-btn
      v-if="showCheckout" 
      color="green"
      @click="checkout"
    >
      Check Out
    </v-btn>

  </div>
</template>

<script>
  import api from './../api/api.js'
  export default {
    computed: {
      showCheckin: {
        get: function(){
          if( this.reservation.status < 3 ){
            return true;
          } else { return false; }
        }
      },
      showCheckout: {
        get: function(){
          if( this.reservation.status == 3 ){
            return true;
          } else { return false; }
        }
      }
    },
    methods: {
      checkin: function(){
        let self = this;
        api.checkinReservation( this.user, this.reservation.id ).then( function ( response ){
          if( response.data.success == true ){
            //reload reservations @ resTable
            self.$store.dispatch('getReservations');
            //have the parent reload reservation
            self.$emit('reload-reservation');
          } else {
            alert("error");
          }
          
        });
      },
      checkout: function(){
        let self = this;
        api.checkoutReservation( this.user, this.reservation.id ).then( function ( response ){
          if( response.data.success == true ){
            //reload reservations @ resTable
            self.$store.dispatch('getReservations');
            //have the parent reload reservation
            self.$emit('reload-reservation');
          } else {
            alert("error");
          }
        });
      }
    },
    name: "ResActions",
    props: {
      reservation: Object,
      user: Object
    }

  }
</script>

<style>

</style>