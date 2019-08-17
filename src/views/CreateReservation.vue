<template>
  <div>
    <SearchCustomer
      @customer-selected="customerSelect"
    />
    <Customer
      :customer="customer"
      :showResetCustomer="showResetCustomer"
      @reset-customer="resetCustomer"
      @update-customer="updateCustomer"
      @create-customer="createCustomer"
    />
    <Reservation
      :reservation="reservation"
      :customer="customer"
      :availableSpaces="availableSpaces"
      :selectionGroups="filteredSpaces"
      @update-available-spaces="updateAvailableSpaces"
    />
    <v-btn
      color="success"
      :disabled="!reservationGo"
      @click="createReservation"
    >
      Create Reservation
    </v-btn>    
  </div>
</template>

<script>
  
  import Customer from './../components/customer.vue'
  import Reservation from './../components/reservation.vue'
  import SearchCustomer from './../components/customerSearch.vue'
  import moment from 'moment'
  import api from './../api/api.js'
  import _ from 'lodash'
  export default {
    components: {
      Customer,
      Reservation,
      SearchCustomer
    },
    computed: {
      reservationGo: function(){
        if(this.customer.id > 0){
          return true;
        } else {
          return false;
        }
      }
    },
    created: function(){
      let self = this;
      api.checkAvailabilityByDates( self.checkin, self.checkout).then( function(response){
        console.log("setting avail spaces");
        self.availableSpaces = response.data.execute.availableSpaceIds
        //update filtered . . .
        self.filteredSpaces = self.filterGroupsByDateAvailability();
      });
    },
    data: function(){
      return{
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
        reservation: {
          id: '0',
          //checkin value are passed to the component as params
          //by the router
          checkin: moment(this.$route.params.checkin).format('YYYY-MM-DD'),
          checkout: moment(this.$route.params.checkout).format('YYYY-MM-DD'),
          space_code: this.$store.getters.getSpaces[this.$route.params.spaceId].space_code,
          //spaceId is passed to the component as a param by the router
          space_id: this.$route.params.spaceId,
          people: '1',
          beds: '1',
          space_name: this.$store.getters.getSpaces[this.$route.params.spaceId].description,
          customer: '0'
        },
        selectGroups: this.$store.getters.getSelectGroups,
        showResetCustomer: true,
        user: this.$store.getters.getUser
      }   
    },
    methods: {
      createCustomer: function(){
        const self = this;
        api.createCustomer( this.user, this.customer).then( function(response){
          console.log("res", response);
          if(response.data.newCustomerId  > 0 ){
            self.customer = response.data.newCustomer
            self.reservation.customer = self.customer.id;
          }else{
            alert("Error. Customer not created.");
          }
        });        
      },
      createReservation: function(){
        console.log("createReservation()");
        console.log("reservation", this.reservation);
        console.log("customer", this.customer);
        console.log("user", this.user);
        //TODO validate reservation
        let self = this;
        
        api.addReservation( this.user, this.reservation).then( function( response ){
          console.log("createRes response", response);
          console.log(response.data.stmt.queryString);
          if(response.data.execute == true){
            //now reload reservations
            self.$store.dispatch('getReservations');
            //navigate to that reservation 
            let resId = response.data.insertId;
            self.$router.push( { name: 'reservations', params: { reservationId: resId } } );
          }
        });
        
      },
      customerSelect: function( customer ){
        //console.log("cust @ createReservationView", customer);
        this.customer = customer;
        this.reservation.customer = customer.id;
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
      resetCustomer: function(){
        //console.log("resetCustomer fires");
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
        //maybe this shoule work off a watch()?
        this.reservation.customer = '0';
      },
      updateAvailableSpaces: function(spaces){
        //console.log("update spaces",spaces);
        this.availableSpaces = spaces;
        //update filteredSpaces
        //console.log("recalculating filteredSpaces");
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
      }
    },
    name: 'CreateReservationView',
    watch: {
      checkin: function(val, oldVal){
        console.log("checkin change", val, oldVal);
      }
    },
    props: {
      checkin: String,
      checkout: String,
      spaceId: String
    }
  }

</script>