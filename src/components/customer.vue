<template>
  <v-form v-model="valid" ref="customerForm" class="compactForm">
    <v-layout row>
      <!-- Last Name text field -->
      <v-flex xs5 sm5 >
        <v-text-field
          small
          v-model="customer.firstName"
          :rules="nameRules"
          :counter="20"
          label="First Name"
          required
        ></v-text-field>
      </v-flex>
      <!-- First name textfield -->
      <v-flex xs5 sm5 class="margin5">
        <v-text-field
          v-model="customer.lastName"
          :rules="nameRules"
          :counter="20"
          label="Last Name"
          required
        ></v-text-field>
      </v-flex>
      <v-flex xs2 sm2>
        <!-- Expand and hide customer details toggle -->
        <v-btn v-if="expandedCustomer" @click="toggleCustomerExpanded" color="primary" fab outline small>
          Less
        </v-btn>
        <v-btn v-else @click="toggleCustomerExpanded" color="primary" fab outline small>
          More
        </v-btn>
      </v-flex>
    </v-layout>
    <!-- Expanded customer details -->
    <div v-if="expandedCustomer">
      <v-layout>
        <!-- address1 -->
        <v-flex xs12 sm6 md6>
          <v-text-field
            v-model="customer.address1"
            :rules="addressRules"
            label="Address 1"
          ></v-text-field>          
        </v-flex><br/>
        
        <!-- address2 -->
        <v-flex xs12 sm6 md6>
          <v-text-field
            v-model="customer.address2"
            :rules="addressRules"
            label="Address 2"
          ></v-text-field>          
        </v-flex>
      </v-layout>
      
      <v-layout row wrap>
        <!-- City -->
        <v-flex xs5 sm5>
          <v-text-field
            v-model="customer.city"
            label="City"
          ></v-text-field>      
        </v-flex>
        
        <!-- Region -->
        <v-flex xs4 sm4>
          <v-text-field
            v-model="customer.region"
            label="Region"
          ></v-text-field>      
        </v-flex>
        
        <!-- Postal Code -->
        <v-flex xs3 sm3>
          <v-text-field
            v-model="customer.postalCode"
            label="Postal Code"
          ></v-text-field>      
        </v-flex>     
      </v-layout>
      
      <v-layout row wrap>
        <!-- Phone -->
        <v-flex xs6 sm6>
          <v-text-field
            v-model="customer.phone"
            label="Phone"
          ></v-text-field>      
        </v-flex>
        
        <!-- Email -->
        <v-flex xs6 sm6>
          <v-text-field
            v-model="customer.email"
            label="Email"
          ></v-text-field>      
        </v-flex>    
      </v-layout>
    </div>
    <v-layout row>
      <v-btn
        v-if="showResetCustomer"
        v-on:click="$emit('reset-customer')"
      >
        Reset Customer
      </v-btn>
      <v-btn
        v-if="customerIsSelected"
        :disabled="!valid"
        @click="updateCustomer"
        outline
      >
        Update Customer
      </v-btn>
      <v-btn
        v-if="!customerIsSelected"
        :disabled="!valid"
        @click="createCustomer"
      >
        Create Customer
      </v-btn>
    </v-layout>
  </v-form>
</template>

<script>
export default {
  computed: {
    customerIsSelected: {
        get: function(){
          if( this.customer.id > 0){
            return true;
          } else { return false; }
        }
    }
  },
  data: function(){
    return{
      valid: false,
      expandedCustomer: false,
      expandedCustomerText: "More",
      //form rules . . .
      addressRules: [
        v => v.length <= 40 || 'FirstName must be less than 40 characters'      
      ],
      nameRules: [
        v => !!v || 'Name is required',
        v => v.length <= 20 || 'FirstName must be less than 20 characters'
      ],    
    }
  },
  methods: {
    createCustomer: function(){
      this.$emit('create-customer');
    },
    resetCustomer: function(){
      this.$emit("reset-customer");
    },
    submit: function(){
      console.log(this.customer);
    },
    toggleCustomerExpanded: function(){
      this.expandedCustomer = !this.expandedCustomer;
    },
    updateCustomer: function(){
      this.$emit('update-customer');
    }
  },
  props: {
    customer: Object,
    showResetCustomer: Boolean
  }

}
</script>
<style scoped>

.margin5{
  margin-left: 5px;
}

</style>