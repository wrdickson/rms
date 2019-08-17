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

    <!-- page -->
    <v-layout>
      <v-flex>
        <table class="data-table">
          <thead>
            <tr>
              <th>Id</th>
              <th>Title</th>
              <th>Rate</th>
              <th>Is Current</th>
              <th>Order</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="item in taxTypes"
              :key="item.id"
              v-bind:data-id="item.id"
              @click="selectRecord"
            >
              <td>{{item.id}}</td>
              <td>{{item.tax_title}}</td>
              <td>{{item.tax_rate}}</td>
              <td>{{item.is_current}}</td>
              <td>{{item.display_order}}</td>
            </tr>
          </tbody>
        </table>
        <v-btn color="info" @click="addDialog = true">Add Tax Type</v-btn>
      </v-flex>
      <!-- edit dialog -->
      <v-dialog
        v-model="editDialog"
      >
        <v-card>
          <v-card-title>
            <h1>Edit Tax Type</h1>
          </v-card-title>
          <v-card-text>
            <v-layout row wrap>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  :clearable=true
                  label="Title"
                  v-model="recordClone.tax_title"
                ></v-text-field>
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  :clearable=true
                  label="Rate"
                  v-model="recordClone.tax_rate"
                ></v-text-field> 
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-select
                  label="Is Current"
                  :items="isCurrentOptions"
                  v-model="recordClone.is_current"
                ></v-select>
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  label="Display Order"
                  v-model="recordClone.display_order"
                  :clearable=true
                ></v-text-field>
              </v-flex>
            </v-layout>
          </v-card-text>
          <v-card-actions class="justify-center">
            <v-btn
              color="info"
              @click="save"
            >Save</v-btn>
            <v-btn
              color="info"
              @click="editDialog = false"
            >Cancel</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <!-- add dialog -->
      <v-dialog
        v-model="addDialog"
      >
        <v-card>
          <v-card-title>
            <h1>Add Tax Type</h1>
          </v-card-title>
          <v-card-text>
            <v-layout row wrap>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  :clearable=true
                  label="Title"
                  v-model="newRecord.tax_title"
                ></v-text-field>
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  :clearable=true
                  label="Rate"
                  v-model="newRecord.tax_rate"
                ></v-text-field> 
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-select
                  label="Is Current"
                  :items="isCurrentOptions"
                  v-model="newRecord.is_current"
                ></v-select>
              </v-flex>
              <v-flex xs6 sm6 md3>
                <v-text-field
                  label="Display Order"
                  v-model="newRecord.display_order"
                  :clearable=true
                ></v-text-field>
              </v-flex>
            </v-layout>
          </v-card-text>
          <v-card-actions class="justify-center">
            <v-btn
              color="info"
              @click="add"
            >Add Tax Type</v-btn>
            <v-btn
              color="info"
              @click="addDialog = false"
            >Cancel</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-layout>
  </div>
</template>

<script>
import _ from 'lodash'
import api from './../api/api.js'
export default{
  created: function(){
    let self = this;
    api.getTaxTypes().then(function( response ){
      self.taxTypes = response.data.tax_types;

    });
  },
  data: function(){
    return {
      addDialog: false,
      editDialog: false,
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
      newRecord: {
        tax_title: '',
        tax_rate: .0000,
        is_current: true,
        display_order: "0"
      },
      recordClone: {},
      snackbar: false,
      snackbarText: '',
      taxTypes: [],
      user: this.$store.getters.getUser
    }
  },
  methods: {
    add: function(){
      let self = this;
      api.addTaxType( this.user, this.newRecord ).then( function( response ){
        if(response.data.execute == true){
          //update tax types
          self.taxTypes = response.data.tax_types;
          //close dialog
          self.addDialog = false;
          self.snackbarText = "Tax type has been added";
          self.snackbar = true;
        } else {
          alert("error");
        }
      });
    },
    save: function(){
      let self = this;
      api.updateTaxType( this.user, this.recordClone ).then( function( response ){
        if(response.data.update == true){
          //update tax types
          self.taxTypes = response.data.tax_types;
          //close dialog
          self.editDialog = false;
          self.snackbarText = "Tax type has been updated";
          self.snackbar = true;
        } else {
          alert("error");
        }
      });
    },
    selectRecord: function(e){
      let recordId = e.target.parentNode.getAttribute('data-id');
      //set the clone of this record
      this.recordClone = _.cloneDeep( _.find(this.taxTypes, function(o){
        return o.id == recordId;
      }));
      this.editDialog = true;
    }
  },
  name:"EditTaxTypes"

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

  .data-table td {
    border: 1px solid green;
    padding: 9px;
  }
  .data-table th{
    border: 2px solid green;
    padding: 9px;
  }

</style>