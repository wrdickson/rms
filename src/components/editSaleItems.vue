<template>
  <v-layout row wrap>

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

    <v-flex xs12>
      <h1>Edit Sale Items</h1>
      <div class='table-wrapper'>
        <table class='data-table'>
          <thead>
            <tr>
              <th >Id</th>
              <th >Item Code</th>
              <th >Title</th>
              <th>Is Fixed Price</th>
              <th>Price</th>
              <th>Sales Group</th>
              <th>Group Title</th>
              <th>Tax Type</th>
              <th>Tax Title</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="item in salesItems"
              :key="item.id"
              v-bind:data-id="item.id"
              @click="recordSelect"
            >
              <td>{{item.id}}</td>
              <td>{{item.sales_item_code}}</td>
              <td>{{item.sales_item_title}}</td>
              <td>{{item.is_fixed_price}}</td>
              <td>{{item.price}}</td>
              <td>{{item.sales_group}}</td>
              <td>{{item.group_title}}</td>
              <td>{{item.tax_type}}</td>
              <td>{{item.tax_title}}</td>
            </tr>
          
          </tbody>
        </table>
      </div>
    </v-flex>
    
    <v-flex xs12>
      <v-btn color="info" @click="addDialog = true">
        Add Sales Item
      </v-btn>

    </v-flex>

    <!-- edit dialog -->
    <v-dialog
      fullscreen
      v-model="editDialog"
    >
      <v-card>
        <v-card-title>
          <h1>Edit Sales Item</h1>
        </v-card-title>
        <v-card-text>
          <v-layout row wrap>
            <v-flex xs6 sm6 md3>
              <v-text-field
                :clearable=true
                label="Item Code"
                v-model="recordClone.sales_item_code"
              ></v-text-field>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-text-field
                :clearable=true
                label="Item Title"
                v-model="recordClone.sales_item_title"
              ></v-text-field> 
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Is Fixed Price"
                :items="isFixedPriceOptions"
                v-model="recordClone.is_fixed_price"
              ></v-select>
            </v-flex>
            <template v-if="showPriceField">
              <v-flex xs6 sm6 md3>
                <v-text-field
                  label="Price"
                  v-model="recordClone.price"
                  :clearable=true
                ></v-text-field>
              </v-flex>
            </template>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Tax Type"
                :items="taxTypes"
                item-value="id"
                item-text="tax_title"
                v-model="recordClone.tax_type"
              ></v-select>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Sales Group"
                :items="salesGroups"
                item-value="id"
                item-text="group_title"
                v-model="recordClone.sales_group"
              ></v-select>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-text-field
                label="Group Order"
                v-model="recordClone.group_order"
                :clearable=true
              ></v-text-field>
            </v-flex> 
          </v-layout>
        </v-card-text>
        <v-card-actions class="justify-center">
          <v-btn
            color="info"
            @click="saveEdit"
          >Save</v-btn>
          <v-btn
            color="info"
            @click="closeEditDialog"
          >Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

     <!-- edit dialog -->
    <v-dialog
      fullscreen
      v-model="addDialog"
    >
      <v-card>
        <v-card-title>
          <h1>Edit Sales Item</h1>
        </v-card-title>
        <v-card-text>
          <v-layout row wrap>
            <v-flex xs6 sm6 md3>
              <v-text-field
                :clearable=true
                label="Item Code"
                v-model="recordClone.sales_item_code"
              ></v-text-field>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-text-field
                :clearable=true
                label="Item Title"
                v-model="recordClone.sales_item_title"
              ></v-text-field> 
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Is Fixed Price"
                :items="isFixedPriceOptions"
                v-model="recordClone.is_fixed_price"
              ></v-select>
            </v-flex>
            <template v-if="showPriceField">
              <v-flex xs6 sm6 md3>
                <v-text-field
                  label="Price"
                  v-model="recordClone.price"
                  :clearable=true
                ></v-text-field>
              </v-flex>
            </template>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Tax Type"
                :items="taxTypes"
                item-value="id"
                item-text="tax_title"
                v-model="recordClone.tax_type"
              ></v-select>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-select
                label="Sales Group"
                :items="salesGroups"
                item-value="id"
                item-text="group_title"
                v-model="recordClone.sales_group"
              ></v-select>
            </v-flex>
            <v-flex xs6 sm6 md3>
              <v-text-field
                label="Group Order"
                v-model="recordClone.group_order"
                :clearable=true
              ></v-text-field>
            </v-flex> 
          </v-layout>
        </v-card-text>
        <v-card-actions class="justify-center">
          <v-btn
            :disabled="!addFormIsComplete"
            color="info"
            @click="saveAdd"
          >Save</v-btn>
          <v-btn
            color="info"
            @click="closeAddDialog"
          >Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


  </v-layout>

</template>

<script>
import _ from 'lodash'
import api from './../api/api.js'
export default{
  computed: {
    addFormIsComplete: function(){
      //this is stupid
      //FIX IT!
      let isComplete = true;
      if( !this.recordClone.sales_item_code ){
        isComplete = false;
      }
      if(!this.recordClone.sales_item_title ){
        isComplete = false;
      }
      if(!this.recordClone.is_fixed_price ){
        isComplete = false;
      }
      if(!this.recordClone.tax_type ){
        isComplete = false;
      }
      if(!this.recordClone.sales_group ){
        isComplete = false;
      } 
      if(!this.recordClone.group_order ){
        isComplete = false;
      } 
      if(this.is_fixed_price == true && !this.recordClone.price ){
        isComplete = false;
      }  
      return isComplete;
    },
    showPriceField: function(){
      if(this.recordClone.is_fixed_price == true){
        return true
      } else { return false }
    }
  },
  created: function(){
    let self = this;
    //load tax types
    api.getTaxTypes().then(function( response ){
      self.taxTypes = response.data.tax_types
    })
    //load sales items
    api.getSalesItems().then(function( response ){
      self.salesItems = response.data.sales_items
    })
    //load sales groups
    api.getSalesGroups().then(function( response ){
      self.salesGroups = response.data.sales_groups
    })
  },
  data: function(){
    return{
      addDialog: false,
      editDialog: false,
      isFixedPriceOptions: [
        {
          value: "0",
          text: "false"
        },
        {
          value: "1",
          text: "true"
        }
      ],
      recordClone: {},
      salesGroups: [],
      salesItems: [],
      snackbar: false,
      snackbarText: '',
      taxTypes: [],
      user: this.$store.getters.getUser
    }
  },
  name: "EditSaleItems",
  methods:{
    closeAddDialog: function(){
      this.addDialog = false;
      this.recordClone = {};
    },
    closeEditDialog: function(){
      this.editDialog = false;
      this.recordClone = {};
    },
    recordSelect: function( e ){
      let recordId = e.target.parentNode.getAttribute('data-id')
      //set the clone of this record
      this.recordClone = _.cloneDeep( _.find(this.salesItems, function(o){
        return o.id == recordId
      }))
      this.editDialog = true
    },
    saveAdd: function(){
      let self = this;
      //TODO validate the inputs . . .

      //fix price if is_fixed price == false
      if(this.recordClone.is_fixed_price == false){
        this.recordClone.price = '0'
      }
      api.addSalesItem( this.user, this.recordClone ).then( function( response ){
        if( response.data.execute == true){
          self.salesItems = response.data.sales_items
          self.snackbarText = "Sales Item successfully saved."
          self.snackbar = true
          self.addDialog = false
          self.recordClone = {}
        } else { alert("Error") }
      });
    },
    saveEdit: function(){
      let self = this;
      //fix price if is_fixed price == false
      if(this.recordClone.is_fixed_price == false){
        this.recordClone.price = 0
      }
      api.updateSalesItem( this.user, this.recordClone ).then( function( response ){
        if(response.data.execute == true){
          //reset sales items
          self.salesItems = response.data.sales_items
          self.snackbarText = "Sales Item successfully updated."
          self.snackbar = true;
          self.editDialog = false;
          self.recordClone = {};
        } else { alert( "Error" ) }
      })
    }
  }
}
</script>

<style>
  .data-table{
    border-collapse: collapse;
    width: 100%;
  }
  .data-table tr:hover {
    background-color: #23c70e;
  }
  .data-table tbody {
    overflow: auto;
  }
  .data-table td {
    border: 1px solid green;
    padding: 9px;
    white-space: nowrap
  }
  .data-table th{
    border: 2px solid green;
    padding: 9px;
    white-space: nowrap
  }
  .table-wrapper{
    overflow-y: auto;
  }
</style>