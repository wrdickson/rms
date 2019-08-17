<template>
  <div>
    <ResActions
      v-if="reservationIsLoaded"
      @reload-reservation = "loadReservation"
      :reservation="reservation"
      :user="user"
    >
    </ResActions>
    <Customer
      :customer="customer"
      :showResetCustmer="showResetCustomer"
      @reset-customer="resetCustomer"
      @update-customer="updateCustomer"
      @create-customer="createCustomer"
      :availableSpaces="availableSpaces"
      :selectionGroups="filteredSpaces"
      @update-available-spaces="updateAvailableSpaces"
    />
    <Reservation
      :reservation="reservation"
      :customer="customer"
      :availableSpaces="availableSpaces"
      :selectionGroups="filteredSpaces"
      @update-available-spaces="updateAvailableSpaces"
      @reservation-changed="reservationChanged"
    />
    <v-btn
      :disabled="resOriginal"
      @click="updateReservation"
    >Update Reservation</v-btn>

    <Folio
      v-if="reservationIsLoaded"
      @reload-reservation="loadReservation"
      :reservation="reservation"
      :user="user"
    />

    <ResNotes
      :reservation="reservation"
      :user="user"
    
    />

    <v-snackbar
      v-model="snackbarTrigger"
      :color="snackbarColor"
      :multi-line="true"
      :timeout="4000"
      :top="true"
      :vertical="true"
    >
      {{ snackbarText }}
      <v-btn
        color="white"
        flat
        @click="snackbarTrigger = false"
      >
        Close
      </v-btn>
    </v-snackbar>
    
  </div>

</template>

<script>
  import Customer from './../components/customer.vue'
  import Reservation from './../components/reservation.vue'
  import ResNotes from './../components/resNotes.vue'
  import Folio from './../components/folio.vue'
  import ResActions from './../components/resActions.vue'
  import api from './../api/api.js'
  import _ from 'lodash'
  export default {
    components: {
      Customer,
      Reservation,
      ResNotes,
      Folio,
      ResActions
    },
    computed: {
        createButtonDisabled: {
          get: function(){
            let disabled = true;
            if( this.customer.id > 0 &&
                this.reservation.people > 0 &&
                this.reservation.beds > 0 &&
                this.reservation.space_id > 0 ){
              disabled  = false;  
            }
            return disabled            
          }
        },
        reservationIsLoaded: {
          get: function(){
            if (this.reservation.id > 0){
              return true;
            } else {
              return false;
            }
          }
        }
    },
    mounted: function(){
      console.log("ReservationView created . . . ");
      if(this.reservationId > 0){
        this.loadReservation();

      }
    },
    data: function(){
      return {
        availableSpaces: [],
        //default customer
        customer: {
          id: '0',
          lastName: '',
          firstName: '',
          address1: '',
          address2: '',
          city: '',
          region: '',
          postalCode: '',
          country: '',
          phone: '',
          email: '' 
        },
        filteredSpaces: [],
        reservation: {},
        resOriginal: true,
        selectGroups: this.$store.getters.getSelectGroups,
        showResetCustomer: false,
        snackbarColor: "green darken-4",
        snackbarTrigger: false,
        snackbarText: "snackbar",
        user: this.$store.getters.getUser
      }       
    },
    methods: {
      createCustomer: function(){
        const self = this;
        api.createCustomer( this.user, this.customer).then( function(response){
          console.log("res", response);
          if(response.data.execute == true){
            self.customer = response.data.newCustomer
          }
        });        
      },
      createReservation: function(){
        
      },
      customerSelect: function( customer ){
        console.log("cust", customer);
        this.customer = customer;
      },
      filterGroupsByDateAvailability: function(){
        let self = this;
        let filtered = [];
        let selG = JSON.parse(JSON.stringify(this.selectGroups));
        _.forEach(selG, function (itGroup){
          let group = {};
          group.id = itGroup.id
          group.order = itGroup.order;
          group.title = itGroup.title;
          group.groups = [];
          _.forEach( itGroup.groups, function(subGroup){
            if( _.includes( self.availableSpaces, subGroup.space_id)){
              group.groups.push(subGroup);
            }
          });
          filtered.push(group);
        });
        return filtered;       
      },

      loadReservation: function(){
        const self = this;
        api.getReservation(this.reservationId).then( function( response ){
          console.log("response from resView: ", response);
          //note that we load the customer from reservation data
          self.reservation = response.data;
          self.customer = response.data.customer_obj;
          //load the folio (to store . . . fix other properties as well
          self.$store.dispatch('loadFolio', self.reservation.folio);
          //nested ASYNC!!
          // now load space availability
          api.checkAvailabilityByDates( self.reservation.checkin, self.reservation.checkout).then( function(response){
            console.log("setting avail spaces @  resView created()");
            self.availableSpaces = Object.values(response.data.execute.availableSpaceIds);
            //update filtered . . .
            self.filteredSpaces = self.filterGroupsByDateAvailability();
            //nested ASYNC
            //and toggle unchanged
            self.resOriginal = true;
          });
        });
      },
      reservationChanged: function(){
        //enable the update button
        this.resOriginal = false;
      },
      resetCustomer: function(){
        this.customer = {
          id: '0',
          lastName: '',
          firstName: '',
          address1: '',
          address2: '',
          city: '',
          region: '',
          postalCode: '',
          country: '',
          phone: '',
          email: '' 
        };
      },
      updateAvailableSpaces: function(spaces){
        console.log("update spaces",spaces);
        this.availableSpaces = spaces;
        //update filteredSpaces
        console.log("recalculating filteredSpaces");
        this.filteredSpaces = this.filterGroupsByDateAvailability();

      },
      updateCustomer: function(){
        const self = this;
        this.$store.commit('showLoader');
        api.updateCustomer( this.customer ).then( function( response ){
          self.$store.commit('hideLoader');
          self.customer = response.data.updatedCustomer;
          console.log("resp", response);
        });
      },
      updateReservation: function(){
        let self = this;
        //current reservation has customer 
        console.log("updateReservation()", this.user, this.reservation);
        api.updateReservation(this.user, this.reservation).then( function ( response ){
          console.log("response",response);
          if(response.data.execute == true){
            self.snackbarText = "Reservation updated.";
            self.snackbarTrigger = true;
            self.resOriginal = true;
            //now reload reservations
            self.$store.dispatch('getReservations');
          }
        });
      }
    },
    name: "ReservationView",
    props: {
      reservationId: String
    },
    watch:{

    }
  }
</script>