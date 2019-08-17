<template>
  <div v-if="loaded">
    <v-layout>
      <v-flex xs12>
          <h2 class="text-xs-center">Shift Report</h2>
       </v-flex>
      
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <p>User: {{ this.user.username }}</p>
      </v-flex>
      <v-flex xs12>
        <p>Report Generated: {{ generatedTime }}</p>
      </v-flex>
      <v-flex xs12>
        <p>Shift Id: {{ shift.id }}</p>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <h2>All Payments</h2>
      </v-flex>
      <v-flex xs12>
        <table class="reportTable">
          <tr>
            <th>Date</th>
            <th>Type</th>
            <th>Amount</th>
            <th>By</th>
          </tr>
          <tr
            v-for="payment in payments"
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

      </v-flex>
    </v-layout>
    <v-layout row  wrap v-for="paymentType in paymentTypes" v-bind:key="paymentType.id">
      <v-flex xs12 >
        <h2>Payment Type: {{paymentType.payment_title}}</h2>
      </v-flex>
      <v-flex xs12>
        <table class="reportTable">
          <tr>
            <th>Date</th>
            <th>Type</th>
            <th>Amount</th>
            <th>By</th>
          </tr>
          <tr
            v-for="payment in paymentsByPaymentType[ paymentType.id ]"
            v-bind:key="payment.id"
          >
            <td>{{payment.date_posted}}</td>
            <td>{{payment.payment_title}}</td>
            <td>{{payment.amount}}</td>
            <td>{{payment.posted_by_username}}</td>
          
          </tr>
     
        </table>       

      </v-flex>
    </v-layout>

    
  </div>


</template>

<script>
import moment from 'moment'
import api from './../api/api.js'
import _ from 'lodash'
export default{
  computed: {
    paymentTotal: {
      get: function(){
        let paymentTotal = 0;

        _.forEach(this.payments, function( payment ){
          paymentTotal = paymentTotal + parseFloat(payment.amount);
        })
        return paymentTotal;
        
      }
    },
    paymentsByPaymentType: {
      get: function(){
        let typedPayments = {};
        let self = this;
        _.forEach(this.paymentTypes, function( paymentType ){
          typedPayments[ paymentType.id ] = [];
          _.forEach(self.payments, function( payment ){
            if( payment.payment_type == paymentType.id ){
              typedPayments[ paymentType.id ].push( payment )
            }
          });
        });
        return typedPayments
      }
    }
  },
  created: function(){
    
    if(this.shiftId > 0){
      let self = this;
      api.getShiftData( this.user, this.shiftId ).then( function( response ){
        console.log("shift respoknse", response )
        self.shift = response.data.shift
        self.sales = response.data.sales
        self.payments = response.data.payments
        //  nasty . . . nested asynch
        let that = self;
        api.getPaymentTypes().then( function( response ){
          that.paymentTypes = response.data.payment_types;
          that.loaded = true;
        });
        

      });    
    }
  },
  data:function(){
    return {
      loaded: false,
      payments: [],
      paymentTypes: [],
      generatedTime: moment().format("MMMM D, YYYY, h:mm:ss a"),
      sales: [],
      shift: {},
      user: this.$store.getters.getUser
    }
  },
  name:"ShiftReport",
  props:{
    shiftId: String
  }
}
</script>

<style>
.reportTable{
  border-collapse: collapse;
  width: 100%
}
.reportTable th{
  border: 1px solid rgb(109, 187, 20);
}
.reportTable td{
  border: 1px solid rgb(109, 187, 20);
}

</style>