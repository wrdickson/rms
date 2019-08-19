<template>
  <v-container>
    <v-slide-x-transition>
    </v-slide-x-transition>
    <div v-if="loaded">
      <v-row>
        <v-col cols="12" xs="12">
          <v-btn color="info" @click="generatePdf">Pdf</v-btn>
        </v-col>
      </v-row>
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
              <th>Folio</th>
              <th>Reservation</th>
            </tr>
            <tr
              v-for="payment in payments"
              v-bind:key="payment.id"
            >
              <td>{{payment.date_posted}}</td>
              <td>{{payment.payment_title}}</td>
              <td>{{payment.amount}}</td>
              <td>{{payment.posted_by_username}}</td>
              <td style="margin: 0px !important; padding: 0px !important;">
                <v-btn 
                  color="green darken-4"
                  tile 
                  width="100%"
                >
                  {{payment.folio}}
                </v-btn>
              </td>
              <td style="margin: 0px !important; padding: 0px !important;">
                <v-btn 
                  color="blue darken-4"
                  tile 
                  width="100%"
                >
                  {{payment.reservation}}
                </v-btn>              
              </td>
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
          <div class="tableWrapper">
            <table class="reportTable">
              <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Amount</th>
                <th>Folio</th>
                <th>Reservation</th>
                <th>Customer</th>
              </tr>
              <!-- rows fore each payment -->
              <tr
                v-for="payment in paymentsByPaymentType[ paymentType.id ]"
                v-bind:key="payment.id"
              >
                <td>{{payment.date_posted}}</td>
                <td>{{payment.payment_title}}</td>
                <td>{{payment.amount}}</td>
                <td style="margin: 0px !important; padding: 0px !important;">
                  <v-btn 
                    color="green darken-4"
                    tile 
                    width="100%"
                  >
                    {{payment.folio}}<v-icon right>mdi-open-in-new</v-icon>
                  </v-btn>
                </td>
                <td style="margin: 0px !important; padding: 0px !important;">
                  <v-btn 
                    color="blue darken-4"
                    tile 
                    width="100%"
                  >
                    {{payment.reservation}}<v-icon right>mdi-open-in-new</v-icon>
                  </v-btn>              
                </td>
                <td style="margin: 0px !important; padding: 0px !important;">
                  <v-btn 
                    color="orange darken-4"
                    tile 
                    width="100%"
                  >
                    {{payment.last_name}}, {{payment.first_name}}<v-icon right>mdi-open-in-new</v-icon>
                  </v-btn>              
                </td>         
              </tr>
              <!-- totals row -->
              <tr>
                <td colspan='2'>Total ====></td>
                <td>{{ paymentTypeTotals[ paymentType.id ] }}</td>
                <td>pti: {{ paymentType.id }}</td>
              </tr>
            </table>       
          </div>
        </v-flex>
      </v-layout>
    </div>
  </v-container>
</template>

<script>
import moment from 'moment'
import api from './../api/api.js'
import _ from 'lodash'
import pdfMake from 'pdfmake/build/pdfmake'
import pdfFonts from 'pdfmake/build/vfs_fonts'
//  should this be in the imports?
pdfMake.vfs = pdfFonts.pdfMake.vfs

export default{
  computed: {
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
    },
  },
  created: function(){
    if(this.shiftId > 0){
      let self = this;
      api.getShiftData( this.user, this.shiftId ).then( function( response ){
        self.shift = response.data.shift
        self.sales = response.data.sales
        self.payments = response.data.payments
        self.paymentTotal = response.data.payment_total
        self.paymentTypeTotals = response.data.payments_by_type
        //  nasty . . . nested async
        let that = self;
        api.getPaymentTypes().then( function( response ){
          that.paymentTypes = response.data.payment_types;
          that.loaded = true;
        });
      });    
    }
  },
  data: function(){
    return {
      loaded: false,
      payments: [],
      paymentTypeTotals: {},
      paymentTotal: 0,
      paymentTypes: [],
      generatedTime: moment().format("MMMM D, YYYY, h:mm:ss a"),
      sales: [],
      shift: {},
      user: this.$store.getters.getUser
    }
  },
  methods: {
    generatePdf(){
      //generate the basic document definition
      let docDefinition = {
        header: {
          text: 'Shift Report',
          style: ['f15']
        },
        footer: 'Footer here!',
        content: [],
        styles: {
          bold: {
            bold: true
          },
          f15: {
            fontSize: 15
          },
          f22: {
            fontSize: 22
          },
          center: {
            alignment: 'center'
          },
          table: {
            margin: [0, 5, 0, 15]
          }
        },
        defaultStyle: {
          fontSize: 8
        }
      }
      //iterate through the payment types
      let self = this
      _.each( this.paymentTypes, function( paymentType ){
        console.log('paymentType', paymentType)
        //create a text object for the payment header
        let obj = {
          text: paymentType.payment_title,
          style: 'f15'
        }
        //append it to the document
        docDefinition.content.push(obj)

        //create the table
        obj = {
          style: ['table'],
          table: {
            // headers are automatically repeated if the table spans over multiple pages
            // you can declare how many rows should be treated as headers
            headerRows: 1,
            widths: [ 150, 125, 100, 70 ],
            body: [
              [ 'Date', 'Type', 'Amount', 'Folio' ],
            ]
          }
        }
        //  iterate throuth the payments by type, adding 'rows'
        let total = 0
        _.forEach( self.paymentsByPaymentType[paymentType.id], function( payment ){
          let arr = []
          arr.push(payment.date_posted)
          arr.push(payment.payment_title)
          arr.push(payment.amount)
          arr.push(payment.folio)
          total = total + parseFloat(payment.amount)
          //push these 'rows' onto the table object
          obj.table.body.push(arr)
        })
        //make a row for totals
        let totalArray = ['Total', '===>', total, '']
        obj.table.body.push(totalArray)
        //  now push the table obj onto document content
        docDefinition.content.push(obj)
      });
      //open the .pdf in a new window
      pdfMake.createPdf(docDefinition).open()
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
  width: 100%;
  font-family: Tahoma, Geneva, sans-serif;
  font-size: 14px;
}
.reportTable th{
  border: 1px solid rgb(109, 187, 20);
  
}
.reportTable td{
  border: 1px solid rgb(109, 187, 20);
  padding-left: 3px;
  padding-right: 3px;
  white-space: nowrap;
}
.tableWrapper{
  overflow-x: auto;
}


/* width */
::-webkit-scrollbar {
  width: 15px;
}

/* Track */
::-webkit-scrollbar-track {
  box-shadow: inset 0 0 5px grey; 
  border-radius: 10px;
}

/* Track Piece */

/* Handle */
::-webkit-scrollbar-thumb {
  background:green; 
  border-radius: 10px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: greenyellow; 
}

</style>