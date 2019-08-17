<template>

  <v-container>

    <v-snackbar
      v-model="snackbar"
      :timeout="3000"
      top
      :multi-line="true"
    >
      {{ snackbarText }}
      <v-btn
        color="snackbarColor"
        text
        @click="snackbar = false"
      >
        Close
      </v-btn>
    </v-snackbar>
    <v-row v-if="shift.id != 0">
      <v-alert
        type="success"
      >A shift is opened</v-alert>
    </v-row>

    <v-row v-if="shift.id == 0" align="center" justify="center">
      <v-col cols="12" xs="12" sm="9" md="6" lg="6">
        <v-card :loading="loading">
          <v-card-title>
            <h2>Select a shift to reopen</h2>
          </v-card-title>
          <v-card-text>
              <v-list-item-group>
                <v-list dense color="green darken-4">
                  <v-list-item
                    v-for="closedShift in formattedShifts"
                    v-bind:key="closedShift.id"
                    @click="select(closedShift.id)"
                  >
                    <v-list-item-content>
                      <v-list-item-title>
                        From: {{ closedShift.start_date }} To: {{ closedShift.end_date }}
                      </v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                </v-list>
              </v-list-item-group>
            </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  import _ from 'lodash'
  import moment from 'moment'
  import api from './../api/api.js'
  export default{
    computed: {
      formattedShifts: {
        get: function(){
          let formattedClosedShifts = []
          _.each( this.closedShifts, function(shift){
            let i = {}
            i = {
              id: shift.id,
              is_open: shift.is_open,
              user: shift.user,
              start_date: moment(shift.start_date).format('MMM D YYYY, h:mm:ss a'),
              end_date: moment(shift.end_date).format('MMM D YYYY, h:mm:ss a')
            }
            formattedClosedShifts.push(i)
          })
          return formattedClosedShifts
        }
      },
      shift: {
        get: function(){
          return this.$store.getters.getShift
        }
      }
    },
    created(){
      let self = this;
      api.reopenShiftOptions( this.user ).then( function( response ) {
        console.log('response', response)
        self.closedShifts = response.data.closed_shifts
        self.loading = false;
      });
    },
    data: function(){
      return {
        closedShifts: [],
        loading: true,
        snackbar: false,
        snackbarColor: "info",
        snackbarText: "",
        user: this.$store.getters.getUser
      }
    },
    methods: {
      select( shiftId ) {
        let self = this;
        this.loading = true;
        api.reopenShift( this.user, shiftId ).then( function( response ){
          self.loading = false;
          if(response.data.reopenShift == true){
            self.snackbarText = "Shift has been reopened"
            self.snackbarColor = "success"
            self.snackbar = true
            self.$store.commit('setShift', response.data.shift);

          } else {
            alert('error')
          }
        });
      }
    },
    name: "ReopenShift",
    props: {
      userId: Number
    }

  }

</script>

<style scoped>
</style>