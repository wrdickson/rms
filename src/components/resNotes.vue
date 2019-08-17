<template>
  <div>
    <table class="tableNotes">
      <thead>
        <tr>
          <th>Note</th>
          <th class="thBy">By</th>
          <th class="thDate">Date</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="note in formattedNotes" v-bind:key="note.keyDate">
          <td>{{ note.text }}</td>
          <td>{{ note.by }}</td>
          <td>{{ note.date }}</td>
        </tr>
      </tbody>
    </table>
    <v-btn @click="showAddNoteDialog" color="success">Add Note</v-btn>

    <!-- Add Note dialog -->
    <v-dialog
      v-model="addNoteDialog"
    >
      <v-card>
        <v-card-title>{{ noteModalTitle }}</v-card-title>
        <v-card-text>
          <v-textarea
            name="noteInput"
            label="Add Note"
            v-model="noteText"
          ></v-textarea>
        </v-card-text>
        <v-card-actions>
          <v-btn @click="saveNote">Save</v-btn>
          <v-btn @click="addNoteDialog = false">Close</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>

</template>

<script>
import moment from 'moment'
import _ from 'lodash'
import api from './../api/api.js'
export default{
  computed: {
    formattedNotes: function(){
      //before the reservation is loaded, is has no property 'notes'
      //and we get an error here
      if(this.reservation.hasOwnProperty('notes') == true){
          let fNotes = [];
          let iObj;
          _.forEach(this.reservation.notes, function( note ){
            iObj = {
              date: moment(note.date).format("MMM D YYYY"),
              keyDate: note.date,
              by: note.by,
              text: note.text
            };
            fNotes.push(iObj);
          });
          return fNotes;
      } 
      else {
        return [];
      }
    },
    noteModalTitle: function(){
      if(this.reservation.hasOwnProperty('customer_obj') == true){
        return this.reservation.customer_obj.lastName + " reservation. " + moment(this.reservation.checkin).format('MMM D YYYY') + " - "+ moment(this.reservation.checkout).format('MMM D YYYY') ;
      } else {
        return '';
      }
    }

  },
  data: function(){
    return{
      addNoteDialog: false,
      noteText: ''
    }
  },
  methods: {
    saveNote: function(){
      console.log(this.noteText);
      let noteObj = {
        date: moment(),
        by: this.user.username,
        text: this.noteText
      }
      //this.reservation.notes.push(noteObj);
      //this.$emit('addNote', this.noteText);
      let self = this;
      api.addReservationNote( this.user, this.reservation.id, noteObj).then(function(response){
        console.log("response");
        if( response.data.execute == true ){
          self.reservation = response.data.updatedReservation;
        }
      });
    },
    showAddNoteDialog: function(){
      this.noteText = '';
      this.addNoteDialog = true;
    }
  },
  name: "ResNotes",
  props: {
    reservation: Object,
    user: Object
  }

}
</script>

<style>
.tableNotes{
  border: 1px solid #eee;
  border-collapse: collapse;
  width: 100%;
}
.tableNotes td{
  border: 1px solid #eee;
  padding: 2px;
  text-align:left;
}
.tableNotes th{
  border: 2px solid rgb(97, 97, 218);
}
.thBy{
  width: 60px;
}
.thDate{
  width: 80px;
}

</style>