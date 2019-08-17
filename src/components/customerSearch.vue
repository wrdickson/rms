<template>
  <div>
    <v-layout row>
      <h3>Search Customers</h3>    
    </v-layout>
    <v-layout row>
      <v-flex xs6>
        <v-text-field
          label="Last Name"
          v-model='searchCustomer.lastName'
          clearable
        ></v-text-field>
      </v-flex>
      <v-flex xs6>
        <v-text-field
          label="First Name"
          v-model='searchCustomer.firstName'
          clearable
        ></v-text-field>
      </v-flex>
    </v-layout>
    <v-layout row>
      <v-btn color="primary" @click="searchCustomers">Search</v-btn>
    </v-layout>
    
    <v-dialog
      v-model="showCustomerSelect"
    
    >
      <div class="customerSelectWrapper">
        <v-data-table
          :items="searchCustomerList"
          class="customerSelect"
          :headers="customerSelectHeaders"
        >
          <template v-slot:items="props">
            
              <td
                @click="clickCustomerSelect"
                :customerId="props.item.id"
                class="text-xs-left lastName"
              >
                {{ props.item.lastName }}
              </td>
              <td
                @click="clickCustomerSelect"              
                :customerId="props.item.id"
                class="text-xs-left firstName"
              >
                {{ props.item.firstName }}
              </td>
              <td
                @click="clickCustomerSelect"              
                :customerId="props.item.id"
                class="text-xs-left address1"
              >
                {{ props.item.address1 }}
              </td>
              <td
                 @click="clickCustomerSelect"             
                :customerId="props.item.id"
                class="text-xs-left address1"
              >
                {{ props.item.address2 }}
              </td>
              <td 
                @click="clickCustomerSelect"              
                :customerId="props.item.id"
                class="text-xs-left city"
              >
                {{ props.item.city }}
              </td>
              <td
                @click="clickCustomerSelect"             
                :customerId="props.item.id"
                class="text-xs-left phone"
              >
                {{ props.item.phone }}
              </td>
              <td 
                @click="clickCustomerSelect"              
                :customerId="props.item.id"
                class="text-xs-left email"
              >
                {{ props.item.email }}
              </td>
            
          </template>
        </v-data-table>
      </div>
    </v-dialog>
    

  </div>
</template>

<script>
import api from './../api/api.js'
export default {
  computed: {
  
  },
  data: function(){
    return{
      
      customerSelectHeaders: [
        {
          text: 'Last Name',
          align: 'left',
          sortable: true,
          value: 'lastName'
        },
        { text: 'First Name', value: 'firstName' },
        { text: 'Address1', value: 'address1' },
        { text: 'Address2', value: 'address2' },
        { text: 'City', value: 'city' },
        { text: 'Phone', value: 'phone' },
        { text: 'Email', value: 'email' }        
      ],
      searchCustomer: {
        lastName: '',
        firstName: ''
      },
      searchCustomerList: [],
      showCustomerSelect: false
    }
  },
  methods: {
    clickCustomerSelect: function(e){
      console.log( 'click',e.target.getAttribute('customerId') );
      let c = this.searchCustomerList.filter(item => item.id == e.target.getAttribute('customerId') );
      console.log("c",c[0]);
      this.workingCustomer = c[0];
      this.showCustomerSelect = false;
      
      this.$emit("customer-selected", c[0]);
    },
    searchCustomers: function(){
      this.showCustomerSelect = true;
      console.log("search");
      let self = this;
      this.$store.commit('showLoader');
      api.searchCustomers(this.searchCustomer.lastName, this.searchCustomer.firstName).then( function( response ){
        self.$store.commit('hideLoader');
        console.log("response", response.data.customers);
        self.searchCustomerList= response.data.customers;
      });
    }
  }
}
</script>

<style scoped>
  .customerSelect td{
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    height: 32px;
    padding: 0, 0px;
  }
  .customerSelectWrapper{
    overflow-x: auto;
    border: 2px solid #def;
    max-height: 450px;
    overflow-y: auto;
    border-spacing: 0px !important;
  }

  .lastName{
    min-width: 70px;
    max-width: 70px;
  }  
  .firstName{
    min-width: 70px;
    max-width: 70px;
  }
  .email{
    min-width: 70px;
    max-width: 70px;
  }
  .phone{
    min-width: 100px;
    max-width: 100px;
  }  
  .address1{
    min-width: 100px;
    max-width: 100px;
  }
  .address2{
    min-width: 130px;
    max-width: 130px;  
  }
  .city{
    min-width: 100px;
    max-width: 100px;
  } 
  .region{
    min-width: 100px;
    max-width: 100px;
  }
  .postalCode{
    min-width: 100px;
    max-width: 100px;
  } 
  .country{
    min-width: 100px;
    max-width: 100px;
  }  

 
</style>