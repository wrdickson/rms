<template>
  <div>
    <v-form class="compactForm">
      <v-row >
        <v-col cols="12" xs="6" sm="4" md="3">
          <!-- Checkin datepicker -->
          <v-menu
            ref="ciMenu"
            v-model="checkinMenu"
            :close-on-content-click="false"
            :nudge-right="40"
            :return-value.sync="reservation.checkin"
            lazy
            transition="scale-transition"
            offset-y
            full-width
            min-width="290px"
          >
            <template v-slot:activator="{ on }">
              <v-text-field
                v-model="checkinFormatted"
                label="Checkin"
                prepend-icon="mdi-calendar-month-outline"
                readonly
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker 
              v-model="reservation.checkin" 
              @input="ciInput"
            />
          </v-menu>
        </v-col>
        
        <!-- Checkout datepicker -->
        <v-col cols="12" xs="6" sm="4" md="3">
          <v-menu
            ref="coMenu"
            v-model="checkoutMenu"
            :close-on-content-click="false"
            :nudge-right="40"
            :return-value.sync="reservation.checkout"
            lazy
            transition="scale-transition"
            offset-y
            full-width
            min-width="290px"
          >
            <template v-slot:activator="{ on }">
              <v-text-field
                v-model="checkoutFormatted"
                label="Checkout"
                prepend-icon="mdi-calendar-month-outline"
                readonly
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker 
              v-model="reservation.checkout" 
              @input="coInput"
              />
          </v-menu>
        </v-col>
        
        <!-- Space picker dialog -->
        <v-col rows="12" xs="6" sm="4" md="3">
          <v-text-field
            label="Space"
            required
            v-model="spaceName"
            @click="spaceModal"
          ></v-text-field>
          <v-dialog
            v-model="spaceDialog"
            max-width="290"
          >
            <v-card>
              <v-card-text>
                <ul class="spaceList">
                  <li v-for="item in selectionGroups"
                    v-bind:key="item.title"
                  >
                    <v-select
                      :items="item.groups"
                      :label="item.title"
                      @change="spaceSelect"
                      
                    >
                    </v-select>
                  </li>
                </ul>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                  @click="spaceDialog = false"
                >
                  Close
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>        
        </v-col>
        
        <!-- People select -->  
        <v-col cols="12" xs="3" sm="3" md="1">
          <v-select
            :items="peopleOptions"
            v-model="peopleSelect"
            label="People"
            item-text="text"
            item-value="value"
          ></v-select>        
        </v-col> 

        <!-- Beds select -->  
        <v-col cols="12" xs="3" sm="3" md="1">
          <v-select
            :items="bedOptions"
            v-model="bedsSelect"
            label="Beds"
            item-text="text"
            item-value="value"
          ></v-select>        
        </v-col>     
   
      </v-row>
    </v-form>

  </div>
</template>

<script>
import _ from 'lodash'
import moment from 'moment'
import api from './../api/api.js'
export default{

  computed:{
    bedsSelect: {
      get: function(){
        return this.reservation.beds;
      },
      set: function(val){
        this.reservation.beds = val;
      }
    },
    checkinFormatted: {
      get: function(){
        return moment(this.reservation.checkin).format('MMM DD YYYY');
      }
    },
    checkoutFormatted: {
      get: function(){
        return moment(this.reservation.checkout).format('MMM DD YYYY');
      }
    },
    peopleSelect: {
      get: function(){
        return {
          text: this.reservation.people,
          value: this.reservation.people
          }
      },
      set: function(val){
        console.log("val",val);
        this.reservation.people = val;
      }
    }, 
    spaceName: function(){
      if(this.reservation.space_id > 0){
        return this.$store.getters.getSpaces[this.reservation.space_id].description;
      } else  { return '';}
    },
    selectGroups: function(){
      return this.$store.getters.getSelectGroups;
    },
    spacesByType: function(){
      let self = this;
      let arr = [];
      _.each(this.spaceTypes, function(type){
          console.log("type @ it",type);
          arr[type.id] = _.filter(self.spaces, function(space){
            return space.space_type == type.id;
          });
      });
      return arr;
    }
  },
  data: function(){
    return{
      
      //note that value is a string . . . problems until I figured
      //this out
      bedOptions: [
        { text: "0", value: '0' },
        { text: "1", value: '1' },
        { text: "2", value: '2' },
        { text: "3", value: '3' },
        { text: "4", value: '4' },
        { text: "5", value: '5' },
        { text: "6", value: '6' },
        { text: "7", value: '7' },
        { text: "8", value: '8' },
        { text: "9", value: '9' },
        { text: "10", value: '10' },
        { text: "11", value: '11' },
        { text: "12", value: '12' }       
      ],
      //note that value is a string . . . problems until I figured
      //this out
      peopleOptions: [
        { text: "0", value: '0' },
        { text: "1", value: '1' },
        { text: "2", value: '2' },
        { text: "3", value: '3' },
        { text: "4", value: '4' },
        { text: "5", value: '5' },
        { text: "6", value: '6' },
        { text: "7", value: '7' },
        { text: "8", value: '8' },
        { text: "9", value: '9' },
        { text: "10", value: '10' },
        { text: "11", value: '11' },
        { text: "12", value: '12' }       
      ],
      
      //these control the visibility of the datepickers
      checkinMenu: false,
      checkoutMenu: false,
      spaceDialog: false,
      spaces: this.$store.getters.getSpaces,
      spaceTypes: this.$store.getters.getSpaceTypes,
      user: this.$store.getters.getUser
    }
  },
  methods: {
    ciInput: function(){
        this.$store.commit('showLoader');
        //we need this to flag the query as to whether this is
        //an existing reservtion or not.
        let isNewReservation = true;
        if(this.reservation.id > 0){
          isNewReservation = false;
        }
        const self = this;
        self.$store.commit('showLoader');
        api.checkAvailability( this.reservation.id, this.user, isNewReservation, this.reservation.checkin, this.reservation.checkout, this.reservation.space_id, this.reservation.people, this.reservation.beds).then( function(response){
          console.log("response from checkAvail", response);
          if( response.data.is_available == true){
            //commit the new data
            self.$refs.ciMenu.save(self.reservation.checkin); 
            //update available spaces based on the new date
            api.checkAvailabilityByDates( self.reservation.checkin, self.reservation.checkout ).then( 
              function( response ){
                self.$store.commit('hideLoader');
                self.$emit('update-available-spaces', Object.values(response.data.execute.availableSpaceIds) );
                self.checkinMenu = false;
              });  
          } else {
            self.$store.commit('hideLoader');
            self.checkinMenu = false;
            alert("not available");
          }
        });
    },
    coInput: function(){
        let self = this;
        this.$store.commit('showLoader');
        //we need this to flag the query as to whether this is
        //an existing reservtion or not.
        let isNewReservation = true;
        if(this.reservation.id > 0){
          isNewReservation = false;
        }
        api.checkAvailability( this.reservation.id, this.user, isNewReservation, this.reservation.checkin, this.reservation.checkout, this.reservation.space_id, this.reservation.people, this.reservation.beds).then( function(response){
          if( response.data.is_available == true){
            //commit the new data
            self.$refs.coMenu.save(self.reservation.checkout);          
            //update available spaces
            api.checkAvailabilityByDates( self.reservation.checkin, self.reservation.checkout ).then( 
              function( response ){
                self.$store.commit('hideLoader');
                self.$emit('update-available-spaces', Object.values(response.data.execute.availableSpaceIds) );
                self.checkoutMenu = false;
              });  
          } else {
            self.$store.commit('hideLoader');
            self.checkoutMenu = false;
            alert("not available");
          }
        });
    },
    emitResChange: function(){
      this.$emit('reservation-changed');
    },
    spaceModal: function(){
      //check to see if spaces are loaded
      this.spaceDialog = true;
    },
    spaceSelect: function(evt){
      //evt is the value from the the select
      //which is the space_id
      //set space_id
      this.reservation.space_id = evt;
      //set space_code
      this.reservation.space_code = this.$store.getters.getSpaces[evt].space_code;
      this.reservation.space_name = this.$store.getters.getSpaces[evt].description;
      //close the modal
      this.spaceDialog = false;
    }
  },
  mounted: function(){
    //  THIS IS SUPER IMPORTANT
    //  run this @mount to get the filtered spaces properly built
    let self = this;
    api.checkAvailabilityByDates( self.reservation.checkin, self.reservation.checkout ).then( 
      function( response ){
        self.$store.commit('hideLoader');
        self.$emit('update-available-spaces', Object.values(response.data.execute.availableSpaceIds) );
        self.checkinMenu = false;
      });
  },
  props: {
    availableSpaces: Array,
    reservation: Object,
    customer: Object,
    selectionGroups: Array
  },
  watch: {
    'reservation.checkin': function(val, oldVal){
      console.log("checkin change",val, oldVal);
      this.emitResChange();
    },
    'reservation.checkout': function(val, oldVal){
      console.log("checkout change",val, oldVal);
      this.emitResChange();
    },
    'reservation.space_id': function(val, oldVal){
      console.log("space_id change",val, oldVal);
      this.emitResChange();
    },
    'reservation.people': function(val, oldVal){
      console.log("people change",val, oldVal);
      this.emitResChange();
    },
    'reservation.beds': function(val, oldVal){
      console.log("beds change",val, oldVal);
      this.emitResChange();    
    }
  }
}
</script>

<style scoped>

.spaceList ul{
  list-style: none;
}
.spaceList li{
  display: inline;
}


</style>