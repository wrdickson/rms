<template>
  <v-form v-model="valid" ref="customerForm" class="compactForm">
    <v-row>
      <!-- Last Name text field -->
      <v-col rows="12" xs="5" sm="5">
        <v-text-field
          small
          v-model="customer.firstName"
          :rules="nameRules"
          :counter="20"
          label="First Name"
          required
        ></v-text-field>
      </v-col>
      <!-- First name textfield -->
      <v-col rows="12" xs="5" sm="5">
        <v-text-field
          v-model="customer.lastName"
          :rules="nameRules"
          :counter="20"
          label="Last Name"
          required
        ></v-text-field>
      </v-col>
      <v-col rows="12" xs="2" sm="2">
        <!-- Expand and hide customer details toggle -->
        <v-btn v-if="expandedCustomer" @click="toggleCustomerExpanded" color="primary" fab outlined>
          Less
        </v-btn>
        <v-btn v-else @click="toggleCustomerExpanded" color="primary" fab outlined>
          More
        </v-btn>
      </v-col>
    </v-row>
    <!-- Expanded customer details -->
    <v-expand-transition>
      <div v-if="expandedCustomer">
        <v-row>
          <!-- address1 -->
          <v-col rows="12" xs="12" sm="6" md="6">
            <v-text-field
              v-model="customer.address1"
              :rules="addressRules"
              label="Address 1"
            ></v-text-field>          
          </v-col><br/>
          
          <!-- address2 -->
          <v-col rows="12" xs="12" sm="6" md="6">
            <v-text-field
              v-model="customer.address2"
              :rules="addressRules"
              label="Address 2"
            ></v-text-field>          
          </v-col>
        </v-row>
        
        <v-row>
          <!-- City -->
          <v-col rows="12" xs="5" sm="5">
            <v-text-field
              v-model="customer.city"
              label="City"
            ></v-text-field>      
          </v-col>
          
          <!-- Region -->
          <v-col rows="12" xs="4" sm="4">
            <v-text-field
              v-model="customer.region"
              label="Region"
            ></v-text-field>      
          </v-col>
          
          <!-- Postal Code -->
          <v-col rows="12" xs="3" sm="3">
            <v-text-field
              v-model="customer.postalCode"
              label="Postal Code"
            ></v-text-field>      
          </v-col>     
        </v-row>
        
        <v-row>
          <!-- Phone -->
          <v-col rows="12" xs="6" sm="6">
            <v-text-field
              v-model="customer.phone"
              label="Phone"
            ></v-text-field>      
          </v-col>
          
          <!-- Email -->
          <v-col rows="12" xs="6" sm="6">
            <v-text-field
              v-model="customer.email"
              label="Email"
            ></v-text-field>      
          </v-col>    
        </v-row>
      </div>
    </v-expand-transition>
    <v-row>
      <v-col>
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
      </v-col>
    </v-row>
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