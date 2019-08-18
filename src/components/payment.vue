<template>
  <div>

    <!-- snackbar -->
    <div class="text-center">
      <v-snackbar
        v-model="snackbar"
        :timeout=3000
        color="amber darken-4"
        top
        multi-line
      >
        {{ snackbarText }}
        <v-btn
          color="info"
          text
          @click="snackbar = false"
        >
          Close
        </v-btn>
      </v-snackbar>
    </div>



    <v-row no-gutters>
      <v-col rows="12" xs="12">
        <h2>Payment</h2>
      </v-col>
    </v-row>
    <v-row no-gutters>
      <v-col cols="12" xs="12">
        <table class="paymentTable">
          <tr>
            <th>Date</th>
            <th>Type</th>
            <th>Amount</th>
            <th>By</th>
          </tr>
          <tr
            v-for="payment in reservation.folio_obj.payments"
            v-bind:key="payment.id"
          >
            <td>{{payment.date_posted}}</td>
            <td>{{payment.payment_title}}</td>
            <td>{{payment.amount}}</td>
            <td>{{payment.posted_by_username}}</td>
          
          </tr>
              <tr>
                <td>TOTAL PAYMENTS ==></td>
                <td></td>
                <td>{{ paymentTotal }}</td>
                <td></td>           
              </tr>        
        </table>
      </v-col>
    </v-row>
    <v-flex xs12>
      <v-btn color="info" @click="paymentDialog = true">
        Post Payment
      </v-btn>
    </v-flex>

    <v-dialog
      v-model="paymentDialog"
    >
      <v-card>
        <v-toolbar>
          <v-btn 
            color="blue lighten-1"
            @click="paymentDialog = false"
          >  
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
        </v-toolbar>
        <v-card-title>
          <h2>Post a payment</h2>
        </v-card-title>
        <v-card-text>
          <v-layout row wrap>
            <v-flex xs6 sm3>
              <v-select
                label="Payment Type"
                :items="paymentTypes"
                item-text="payment_title"
                item-value="id"
                v-model="newPayment.payment_type"
              ></v-select>
            </v-flex>
            <v-flex xs6 sm3>
              <v-text-field
                label="Amount"
                v-model="newPayment.amount"
                clearable
              ></v-text-field>
            </v-flex>
          </v-layout>
        </v-card-text>
        <v-card-actions>
          <v-btn
            v-if="newPayment.payment_type > 0 && newPayment.amount > 0"
            color="blue lighten-1"
            @click="savePayment"
          >Post Payment</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>

</template>

<script>
  import api from './../api/api.js'
  export default{
    created: function(){
      let self = this
      api.getPaymentTypes().then( function( response ){
        self.paymentTypes = response.data.payment_types
      });
    },
    data: function(){
      return{
        newPayment: {
          payment_type: '',
          amount: ''
        },
        paymentDialog: false,
        paymentTypes: [],
        snackbar: false,
        snackbarText: ''
        
      }
    },
    methods: {
      savePayment(){
        //  TODO validate this better
        let self = this;
        let fixedAmount = parseFloat(this.newPayment.amount).toFixed(2);
        let dbPayment = {
          posted_by: this.user.userId,
          amount: fixedAmount,
          payment_type: this.newPayment.payment_type,
          folio: this.reservation.folio,
          shift: this.shift.id
        }
        api.postPayment( this.user, dbPayment ).then( function( response ){
          //clear the new payment
          self.newPayment = {
            payment_type: '',
            amount: ''
          }          
          if(response.data.execute == true){
            self.paymentDialog = false
            self.snackbarText = "Payment has successfully been saved."
            self.snackbar = true
            self.$emit( "payment-saved" )
          } else { alert( "There was an error.  Payment NOT POSTED!") }

        });
      }
    },
    name:"Payment",
    props: {
      reservation: Object,
      user: Object,
      shift: Object,
      paymentTotal: Number      
    }
  }
</script>

<style>
.paymentWrapper{
  border-radius: 15px;
  padding: 12px;
  background-color:darkblue;
}
.paymentTable {
  border-collapse: collapse;
  width: 100%;
  background-color: darkblue;
}
.paymentTable th {
  border: 2px solid blue;
  padding: 3px;
}
.paymentTable td {
  border: 1px solid blue;
  padding: 3px;
}


</style>

