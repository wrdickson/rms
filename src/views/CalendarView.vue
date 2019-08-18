<template>
  <v-container>
    <v-row no-gutters>
      <v-col cols='12' xs='12'>
        <p>CalendarView</p>
      </v-col>
    </v-row>
    <v-row no-gutters>
      <v-col cols="12" xs="2" sm="3" md="3">
        <table id="roomsTable" class="rooms-table" style="height: 200px">
          <thead>
            <tr>
              <th>Rooms</th>
            </tr>
          </thead>
          <tbody>
            <div id="roomInner" style="height: 200px; overflow-y: hidden">
              <tr v-for="n in 12" v-bind:key="n">
                <td>Room {{n}}</td>
              </tr>
            </div>              
          </tbody>
        </table>
      </v-col>
      <v-col cols="12" id="calendarTable" class="calendar-table" xs="10" sm="9" md="9">
        <table id="calendarTable" class="calendar-table" style="height: 200px">
            <tr>
              <th v-for="n in 50" v-bind:key="n" style="min-width: 35px; max-width: 35px;">{{n}}</th>
            </tr>
            <div id="calendarInner" style="height: 200px; overflow-y: auto; overflow-x: auto">
              <tr v-for="n in 12" v-bind:key = "n">
                <td v-for="m in 50" v-bind:key="m" style="min-width: 35px; max-width: 35px;">{{n}}{{m}}</td>
              </tr>
            </div>
        </table>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        

      </v-col>
    </v-row>

    

  </v-container>
</template>

<script>
export default {
  computed: {
    roomItems: {
      get: function(){
        return true;
      }
    }
  },
  data: function () {
    return {
      offsetTop: 0

    }
  },
  methods: {
    
    scroll1(){

    }
  },
  mounted(){
    document.getElementById('calendarInner').onscroll = function(e){
      console.log(e.target.scrollTop)
      document.getElementById('roomInner').scrollTop = e.target.scrollTop
    }
  },
  name: 'CalendarView'
}
</script>

<style scoped>
.rooms-table{
  border: 1px solid red;
  width: 100%;

}
.calendar-table{
  border: 1px solid blue;
  //width: 100%;
}
</style>