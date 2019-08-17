<template>
  <div>
    <h3>Edit Sale Types</h3>
    <table class="data-table">
      <thead>
        <tr>
          <th>Id</th>
          <th>Title</th>
          <!-- <th>Tax Type</th> -->
          <th>Tax Title</th>
          <th>Tax Rate</th>
          <th>Is Current</th>
          <th>Display Order</th>
        </tr>
      </thead>
      <tbody>
        <tr 
          v-for="item in saleTypes"
          :key="item.id"
          v-bind:data-sale-type-id="item.id"
          @click="selectRow"
        >
          <td v-bind:data-sale-type-id="item.id" >{{item.id}}</td>
          <td v-bind:data-sale-type-id="item.id" >{{item.title}}</td>
          <!-- <td v-bind:data-sale-type-id="item.id" >{{item.tax_type}}</td> -->
          <td v-bind:data-sale-type-id="item.id" >{{item.tax_title}}</td>
          <td v-bind:data-sale-type-id="item.id" >{{item.tax_rate}}</td>
          <td v-bind:data-sale-type-id="item.id" >{{item.is_current}}</td>
          <td v-bind:data-sale-type-id="item.id" >{{item.display_order}}</td>
        </tr>
      </tbody>
    </table>
    <!-- edit sale type -->
    <div class="edit-sale-type"
      v-if="showEditSaleType"
    >
      <v-layout>
        <h3>Edit Selected Sale Type</h3>
      </v-layout>
      <v-layout row wrap>
        <!-- title -->
        <v-flex xs6>
          <v-text-field
            label="Title"
            v-model="saleTypeClone.title"
          >
          </v-text-field>
        </v-flex>
        <!-- tax_type -->
        <v-flex xs6>
          <v-select
            label="Tax Type"
            :items="taxTypes"
            item-text="tax_title"
            item-value="id"
            v-model="saleTypeClone.tax_type"
          >
          </v-select>
        </v-flex>
        <!-- is_current -->
        <v-flex xs6>
          <v-select
            label="Is Current"
            :items="isCurrentOptions"
            v-model="saleTypeClone.is_current"
          >
          </v-select>
        </v-flex>
        <!-- display_order -->
        <v-flex xs6>
          <v-text-field
            label="Display Order"
            v-model="saleTypeClone.display_order"
          >
          </v-text-field>
        </v-flex>
      </v-layout>
      <v-layout row wrap>
        <v-btn @click="revert" color="warning">
          Revert
        </v-btn>
        <v-btn @click="save" color="success">
          Save
        </v-btn>
        <v-btn @click="showEditSaleType = false" color="danger">
          Cancel
        </v-btn>
      </v-layout>
    </div>
    <div>
      <v-btn
        v-if="showEditSaleType == false"
        color="info" 
        @click="showAddSaleType = !showAddSaleType"
      >
        Add Sale Type
      </v-btn>
    </div>
    <!-- add sale type -->
    <div v-if="showAddSaleType">
      <h3>Add Sale Type</h3>
      <v-layout row wrap>
        <!--title -->
        <v-flex xs6>
          <v-text-field
            label="Title"
            v-model="newSaleType.title"
          ></v-text-field>
        </v-flex>
        <!-- tax_type -->
        <v-flex xs6>
          <v-select
            label="Tax Type"
            :items="taxTypes"
            item-text="tax_title"
            item-value="id"
            v-model="newSaleType.tax_type"
          >
          </v-select>
        </v-flex> 
        <!-- is_current -->
        <v-flex xs6>
          <v-select
            label="Is Current"
            :items="isCurrentOptions"
            v-model="newSaleType.is_current"
          >
          </v-select>
        </v-flex> 
        <!-- display_order -->
        <v-flex xs6>
          <v-text-field
            label="Display Order"
            v-model="newSaleType.display_order"
          >
          </v-text-field>
        </v-flex>      
      </v-layout>
      <v-btn
        color="info"
        @click="showAddSaleType = !showAddSaleType"
      >
        Cancel
      </v-btn>
      <v-btn
        color="success"
        @click="saveNewSaleType"
      >
        Save
      </v-btn>
    </div>
  </div>
</template>

<script>
import api from './../api/api.js'
import _ from 'lodash'
export default{
  computed:{
    taxTypes: function(){
      return this.$store.getters.getTaxTypes
    },
    taxTypeOptions: function(){
      let taxTypeOptionArray = [];
      _.forEach( this.taxTypes, function ( taxType ){
        taxTypeOptionArray.push( taxType.tax_title );
      });
      return taxTypeOptionArray;
    }
  },
  mounted: function(){
    let self = this;
    //TODO . . bump this to init and store
    api.getSaleTypes().then( function( response ){
      console.log("respo",response);
      self.saleTypes = response.data.sale_types;
    });
    console.log("this.$store.getters.getTaxTypes", this.$store.getters.getTaxTypes);
  },
  data: function(){
    return{
        headers: [
          { text: 'Id', value: 'id' },
          { text: 'Title', value: 'title' },
          { text: 'Tax Type', value: 'tax_type' },
          { text: 'Tax Title', value: 'tax_type_title' },
          { text: 'Tax Rate', value: 'tax_rate' },
          { text: 'Is Current', value: 'is_current' },
          { text: 'Display Order', value: 'display_order' }
        ],
        isCurrentOptions: [
          {
            value: "0",
            text: "false"
          },
          {
            value: "1",
            text: "true"
          }
        ],
        max25chars: v => v.length <= 25 || 'Input too long!',
        newSaleType: {
          title: "",
          tax_type: "0",
          is_current: "0",
          display_order: "0"
        },
        saleTypes: [],
        saleTypeClone: {},
        selectedSaleType: {},
        showAddSaleType: false,
        showEditSaleType: false,
        snack: false,
        snackColor: "green",
        snackText: "Snack text",
        user: this.$store.getters.getUser
    }
  },
  methods:{
      revert: function(){
        this.saleTypeClone = _.cloneDeep(this.selectedSaleType);
      },
      save: function(){
        //we only send the new tax_type (id), NOT tax_type_title or tax_rate
        //which have NOT been updated
        let newSaleType = {
          id: this.saleTypeClone.id,
          title: this.saleTypeClone.title,
          is_current: this.saleTypeClone.is_current,
          tax_type: this.saleTypeClone.tax_type,
          display_order: this.saleTypeClone.display_order
        };
        let self = this;
        api.updateSaleType( this.user, newSaleType ).then( function( response ){
          if( response.data.update == true){
            self.saleTypes = response.data.sale_types;
            //hide editor
            self.showEditSaleType = false;
          } else {
            alert("error");
          }
        });
      },
      saveNewSaleType: function(){
        let self = this;
        api.addNewSaleType( this.user, this.newSaleType ).then( function( response ){
          console.log( "save", response );
          if( response.data.execute == true){
            self.saleTypes = response.data.sale_types;
            //hide add
            self.showAddSaleType = false;
          } else {
            alert("Error");
            self.showAddSaleType = false;
          }
        });
      },
      selectRow( e ){
         let saleTypeId = e.target.getAttribute("data-sale-type-id");
         let selectedSaleType = _.find(this.saleTypes, function( o ){
           return o.id == saleTypeId;
         });
         console.log("selectedSaleType", selectedSaleType);
         this.selectedSaleType = selectedSaleType;
         this.saleTypeClone = _.cloneDeep(selectedSaleType);
         //show editor
         this.showEditSaleType = true;
         this.showAddSaleType = false;
      }
  },
  name: "EditSaleTypes"
}
</script>

<style>
  .data-table{
    border-collapse: collapse;
  }
  .data-table tr:hover {
    background-color: #23c70e;
  }

  .data-table td {
    border: 1px solid green;
    padding: 9px;
  }
  .data-table th{
    border: 2px solid green;
    padding: 9px;
  }
  .edit-sale-type{
    border: 2px solid blue;
    padding: 5px;
    border-radius: 12px;
    background-color: rgb(66, 17, 182)
  }
</style>