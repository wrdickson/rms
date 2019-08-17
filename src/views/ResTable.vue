<template>
  <div>
    <v-layout wrap>
      <v-flex xs12 sm3 md2>
        <v-btn fab small @click='minusDay'>
          -1
        </v-btn>      
        <v-btn fab small @click='minusWeek'>
        -7
        </v-btn>
        <v-btn fab small @click='minusMonth'>
        -30
        </v-btn>

        <v-menu
          ref="resDate"
          v-model="resDatePicker"
          :close-on-content-click="false"
          :nudge-right="40"
          :return-value.sync="start"
          transition="scale-transition"
          offset-y
          label='Calendar Start'
          min-width="290px"
        >
          <template v-slot:activator="{ on }">
            <v-text-field
              v-model="resStartFormatted"
              prepend-icon="mdi-calendar-month-outline"
              readonly
              v-on="on"
            ></v-text-field>
          </template>
          <v-date-picker 
            v-model="start" 
            @input="resDateInput"
          />
        </v-menu>

        <v-btn fab small @click='plusDay'>
        +1
        </v-btn>        
        <v-btn fab small @click='plusWeek'>
        +7
        </v-btn>
        <v-btn fab small @click='plusMonth'>
        +30
        </v-btn>
      
      </v-flex>

      <v-flex xs12 sm9 md10>
        <div style="float: left;" >
          <table class="groupsTable">
            <tbody>
              <!-- this is the blank td at the top of the column -->
              <tr style="height: 49px; border: 1px solid white;">
                <td class="groupTd"> {{ resYear }}</td>
              </tr>
              <div
                id="groupsTable"
                class="groupsTable"
                :style='tableWrapperHeight'
              >
                <!-- APPEND groups here -->
                <tr 
                  v-for="space in spaces"
                  v-bind:key="space.space_id"
                  :id='space.space_id'
                  :data-subspaces='space.subspaces'
                  @click="groupClick"
                > 
                  <td 
                    nowrap 
                    :id="space.space_id"
                    :data-subspaces='space.subspaces'
                    :class='space.tdClass'
                  >
                    {{space.description}}
                    <v-icon
                      v-if=" space.show_subspaces == '1' "
                      small
                    >
                    mdi-arrow-down-drop-circle-outline
                    </v-icon>
                    
                    <v-icon
                      v-if=" space.show_subspaces == '0' && space.subspaces "
                      small
                    >
                    mdi-arrow-right-drop-circle-outline
                    </v-icon>
                    
                  </td>
                </tr>
                <!-- dummy tr -->
                <tr class='groupsTf'>
                  <td class='groupTd dummyTd'></td>
                </tr>
               
              </div>  
            </tbody>
          </table>      
        </div>
        <div id="controlWrapper"
          :style='controlWrapperHeight'
        >
            <div id="tableWrapper"
              :style='tableWrapperHeight'
            >
              <v-flex xs12 sm12>
                <div id="hTable"></div>
                
                <table class="headerTable">
                  <thead></thead>
                  <tbody>
                    <tr>
                      <td 
                        v-for="days in dayArray"
                        :key="days"
                        class="itemTd">
                        
                        {{ days }}
                      </td>
                    </tr> 
                  </tbody>
                </table>
              </v-flex>
              <v-flex xs12 sm12>
                <table id='resTable' class='resTable'>
                  <div id="innerDiv"
                    :style='itemTableHeight' 
                  >
                    <tbody id="resTbody">
                    <!-- append reservation grid here -->
                      <tr
                        v-for="space in spaces"
                        :id='space.space_id'
                        :key="space.space_id"
                      >
                        <td
                          v-for='date in dateArray'
                          v-bind:key='date'
                          :id="space.space_id + '|' + date"
                          :data-date= "date" 
                          :data-space-id= "space.space_id"
                          class='itemTd resTd'
                          @click="resClick(space.space_id, date, $event)"
                          nowrap
                        >
                        </td>
                      </tr>
                    <!-- dummy tr -->
                    <tr id='dTr'>
                      <td class='dummyTd'></td>
                    </tr>
                    </tbody>

                  </div>
                </table>
              </v-flex>
            </div>
        </div>
      </v-flex>
    </v-layout>
  </div>
</template>
<script>
  import Moment from 'moment'
  import api from './../api/api.js'
  import { extendMoment } from 'moment-range'
  import _ from 'lodash'
  const uuidv4 = require('uuid/v4')
  export default {
    name: "ResTable",
    beforeUpdate: function(){
      console.log("beforeUpdate");
    },
    computed: {
      controlScrollTop: {
        get: function(){
          return this.cScrollTop;
        },
        set: function( val ){
          this.cScrollTop = val;
        }      
      },
      controlWrapperHeight: {
        get: function(){
          let computedHeight = this.windowInnerHeight - 73;
          return 'height: ' + computedHeight + 'px; margin-left = -25px;';
        }
      },
      dateArray: {
        get: function(){
          const moment = extendMoment(Moment);
          const range = moment.range(this.start, this.end);
          const days = Array.from(range.by('days'));
          let daysArr = days.map(m => m.format('YYYY-MM-DD'));
          return daysArr;
        }
      },
      dayArray: {
        get: function(){
          const moment = extendMoment(Moment);
          const range = moment.range(this.start, this.end);
          const days = Array.from(range.by('days'));
          let daysArr = days.map(m => m.format('MM DD'));
          return daysArr;
        }
      },
      itemTableHeight: {
        get: function(){
          let computedHeight = this.windowInnerHeight - 107;
          return 'height: ' + computedHeight + 'px;';
        }      
      },
      selectGroups: {
        get: function(){
          return  this.$store.getters.getSelectGroups;
        }      
      },
      tableWrapperHeight: {
        get: function(){
          let computedHeight = this.windowInnerHeight - 116;
          return 'height: ' + computedHeight + 'px;';
        }      
      },
      end: {
        get: function(){
          return  this.$store.getters.getResViewEnd;
        }
      },
      reservations: {
        get: function(){
          return this.$store.getters.getReservations;
        }
      },
      start: {
        get: function(){
          return  this.$store.getters.getResViewStart;
        },
        set: function(val){
          console.log("val @ set",val);
          this.$store.commit('resViewSetStart', val);
        }
      },
      resStartFormatted: {
        get: function(){
            return Moment(this.$store.getters.getResViewStart).format('MMM DD YYYY');
        }
      },
    
      resYear: {
        get: function(){
          const start = this.start;
          const end = this.end;
          if( Moment(start).format('YYYY') === Moment(end).format('YYYY') ){
            return Moment(start).format('YYYY');
          } else {
            return Moment(start).format('YYYY') + "/" + Moment(end).format('YYYY');
          } 
        }
      },

      spaces: {
        get: function(){
          let self = this;
          let rootArr = [];
          //get the root spaces
          _.each( this.spacesData, function( space ){
            if( space.child_of == '0'){
              //this will help with render
              space.tdClass = 'indent0';
              rootArr.push(space);
              //append children
              _.forEach(self.spacesData, function( iSpace ){
                if( iSpace.child_of == space.space_id && space.show_subspaces == true){
                  iSpace.tdClass = 'indent1';
                  rootArr.push(iSpace);
                  //append children
                  _.forEach(self.spacesData, function( jSpace ){
                    if( jSpace.child_of == iSpace.space_id && iSpace.show_subspaces == true){
                      jSpace.tdClass = 'indent2';
                      rootArr.push(jSpace);
                    }
                  });
                }
              });
            }
          });
          return rootArr;
        }
      },
      spacesData: function(){
        return this.$store.getters.getSpaces;     
      },
      tableGroups: {
        get: function(){
          let arr = Array();
          _.forEach( this.selectGroups, function(group1){
            //add the title
            let obj = {
              title: group1.title,
              space_id: group1.id + group1.title
            }
            arr.push(obj);
            //iterate through
            _.forEach( group1.groups, function(groupSub){
              let obj2 = {
                title: groupSub.text,
                space_id: groupSub.space_id
              }
              arr.push(obj2);
            });
          });
          return arr;
        }
      }
    },
    mounted: function(){
      this.$nextTick( function(){
        console.log('mounted');
        this.constructTable();
      });
    },
    data: function(){
      return {
        cScrollTop: 0,
        resDatePicker: false,
        resStart: '2019-05-01',
        uuid: '',
        windowInnerHeight: 200,
        sTop: 0
      }
    },
    methods: {
      clickGroupTr: function(e){
        console.log("e.target", e.target.id.substring(6));
        let space_id = e.target.id.substring(6);
        let tar = _.find(this.spaces,  function(space){
          return space.space_id == space_id;
        })
        tar.show_subspaces = !tar.show_subspaces;
        console.log( "tar",tar );
      },
      constructTable: function(){
        let self = this;

        //this is where we coordinate scrolling between the two tables
        document.getElementById('innerDiv').onscroll = function(e){
          //console.log('scrollheight',document.getElementById('innerDiv').scrollHeight);
          //console.log('bot',document.getElementById('innerDiv').getBoundingClientRect().bottom);
          //console.log('dif', document.getElementById('innerDiv').getBoundingClientRect().bottom - document.getElementById('innerDiv').scrollTop);
          //console.log('windowheight', window.innerHeight);
          
          document.getElementById('groupsTable').scrollTop = e.target.scrollTop;
          
        };
        //this basically disables group table scroll
        document.getElementById('groupsTable').onscroll = function(){
          document.getElementById('groupsTable').scrollTop = document.getElementById('innerDiv').scrollTop;
        };
        //control height based on window size
        window.addEventListener("resize", function(e){
          self.windowInnerHeight = e.currentTarget.innerHeight;
        });
        //console.log("window",window);
        self.windowInnerHeight = window.innerHeight;
        
        //add the reservations
        //clear
        let all = document.getElementsByClassName('resTd');
        //console.log("all.length", all.length);
        this.$store.commit('showLoader');
        _.forEach(all, function( element ){
          element.innerHTML = '';
          element.classList.remove('resMiddleTd');
        });
        //first, iterate through each reservation
        _.forEach(this.reservations, function(res){
          let spaceArray = res.space_code.split(',');
          //next, iterate through the space array
          //this is to block subspaces on the table
          _.forEach(spaceArray, function(space){
            //shave off the last day since we don't show the checkout day on the grid
            let range1 = Moment.range(res.checkin, Moment(res.checkout).subtract(1, 'days') );
            let days1 = Array.from(range1.by('days'));
            let resArr = days1.map(m => m.format('YYYY-MM-DD'));
            let iterateCount = 0;
            let lastDay = resArr.length - 1;
            _.forEach(resArr, function( d ){
              //let selector = res.space_id + '|' + d;
              let selector = space + '|' + d;
              if(document.getElementById(selector)){
                //by adding the data-res-id attribute, it will signal
                //that this cell is reserved
                document.getElementById(selector).setAttribute('data-res-id', res.id)
                switch( res.status ){
                  case "1":
                    document.getElementById(selector).innerHTML = "<div data-res-id='" + res.id +"' class='reserved'>*</div>";
                    break;
                  case "2":
                    document.getElementById(selector).innerHTML = "<div data-res-id='" + res.id +"' class='reserved_deposit'>*</div>";
                    break; 
                  case "3":
                    document.getElementById(selector).innerHTML = "<div data-res-id='" + res.id +"' class='reserved_checkedin'>*</div>";
                    break; 
                  case "4":
                    document.getElementById(selector).innerHTML = "<div data-res-id='" + res.id +"' class='reserved_checkedout'>*</div>";
                    break;              
                }
                switch( iterateCount ){
                  case 0:
                    //handle the case where this is a one day reservation
                    if( resArr.length == 1){
                      document.getElementById(selector).classList.add('resSingleTd')
                    } else {
                      document.getElementById(selector).classList.add('resFirstTd')
                    }
                    break;
                  case lastDay:
                    document.getElementById(selector).classList.add('resLastTd')
                    break;                  
                  default:
                    document.getElementById(selector).classList.add('resMiddleTd')
                }
              }
              iterateCount += 1;              
            });
          });
        });
        this.$store.commit('hideLoader');
      },
      generateUuid: function(){
        this.uuid = uuidv4();
        let u = uuidv4();
        return u;
      },
      groupClick: function(e){
        console.log("groupClick",e.target.parentNode.id);
        let spaceId = e.target.parentNode.id;
        let ss = e.target.parentNode.attributes['data-subspaces'].value.split(',')[0];
        if(ss != ''){
          console.log('toggle', spaceId);
          this.$store.commit('toggleSpaceShowSubspaces', spaceId);
        }
      }, 
      resClick: function(space_id, date, event ){
        let self = this;
        console.log("event.target", event.target);
        if(event.target.hasAttribute('data-res-id') == true){
          const resId = event.target.getAttribute('data-res-id');
          console.log("go to reservation ", resId );
          this.$router.push( { name: 'reservations', params: { reservationId: resId } } );
        }else{
          const checkin = event.target.getAttribute('data-date');
          const checkout = Moment( event.target.getAttribute('data-date') ).add(1,'days').format('YYYY-MM-DD');
          const spaceId = event.target.getAttribute('data-space-id');
          //make sure that space is available . . . 
          //what can happen is that this space is the parent of something that is NOT available
          api.checkAvailability( 0, this.user, true, checkin, checkout, spaceId, 1, 1).then( function( response ){
            console.log("avail:", response.data);
            if(response.data.is_available == true){
              self.$router.push( {name: 'createReservation', params: { checkin: checkin, checkout: checkout, spaceId: spaceId } });
            } else {
              alert("not available");
            }
          });

        }
      },        
      scrollRight: function(){
        console.log("scrollRight");
      },
      scrollRightTrigger: function(){
        console.log("scrollRightTrigger @ resTable");
      },
      //at initialize, we need the window height
      setInitialWindowHeight: function(){
        this.windowInnerHeight = window.innerHeight;
      },
      timelineClick: function(e){
        console.log("e",e);
      },
      
      //navigation

      resDateInput: function( ){
        this.resDatePicker = false;
        this.$refs.resDate.save(this.start);
      },
      minusWeek: function(){
        this.$store.commit('resViewMinusWeek');
      },
      minusDay: function(){
        this.$store.commit('resViewMinusDay');
      },
      minusMonth: function(){
        this.$store.commit('resViewMinusMonth');
      },
      plusDay: function(){
        this.$store.commit('resViewPlusDay');
      },
      plusMonth: function(){
        this.$store.commit('resViewPlusMonth');
      },
      plusWeek: function(){
        this.$store.commit('resViewPlusWeek');
      }
 
    },
    updated: function(){
      console.log("updated");
      this.constructTable();
    },
    watch: {
      reservations: function(val, oldVal){
        console.log("reservations changed", val, oldVal);
        this.constructTable();
      },
      spacesData: function(){
        console.log("spacesData change");
      },
      start: function( val, oldVal){
        console.log("start changed",val,oldVal);
        //this.constructTable();
      }
    }
  }
</script>
<style>
  
  .reserved{
    background-color: rgb(145, 255, 0); 
    color:rgb(145, 255, 0); 
    height: 100%;
    width: 100%;
    margin-top: -2px !important;
    margin-bottom: -2px !important;
  }

  .reserved_checkedin{
    background-color: blue; 
    color: blue;
    height: 100%;
    width: 100%;
    margin-top: -2px !important;
    margin-bottom: -2px !important;
  }

  .reserved_checkedout{
    background-color: rgb(131, 131, 224); 
    color: rgb(131, 131, 224); 
    height: 100%;
    width: 100%;
    margin-top: -2px !important;
    margin-bottom: -2px !important;
  }

  .reserved_deposit{
    background-color: green; 
    color: green;
    height: 100%;
    width: 100%;
    margin-top: -2px !important;
    margin-bottom: -2px !important;
  }
  .resFirstTd{
    padding-left: 4px;
  }
  .resLastTd{
    padding-right: 4px;
  }
  .resMiddleTd{
    padding-right: 0px;
    padding-right: 0px;
  }
  .resSingleTd{
    padding-left: 4px;
    padding-right: 4px;
  }
 
  .indent1{
    padding-left: 16px !important;
  }
  .indent2{
    padding-left: 24px !important;
  }
  
  .dTr{
    height: 26px !important;
  }
  .dummyTr td{
    border: 1px solid #303030 !important;

  }
  .dummyTd{
    //height: 1px !important;
  }
  .groupsTable{
    border-collapse: collapse;
    //border-spacing: 1px;
    overflow-y: hidden;
    overflow-x: scroll;
  }
  .groupsTable tr{
    height: 26px;
  }
  .groupsTable td{
    border: 1px solid #7986CB;
    padding-left: 8px;
  }
  .groupsTable td.dummyTd{
    border: 0;
  }
  .groupsTableFirstTr{
    height: 28px;
  }
  .groupTd{
    min-width: 124px;
    max-width: 124px;
  }
  .groupsTr{
    height: 26px;
  }
  .itemTd{
    min-width: 34px;
    max-width: 34px;
    overflow: hidden;
  }
  #innerDiv{
    overflow-y: auto;
  }
  .headerTable{
    border-collapse: collapse;
  }
  .headerTable tr{
    height: 28px;
  }
  .headerTable td{
    border: 1px solid white;
    text-align: center;
  }
  .resTable{
    border-collapse: collapse;
  }
  .resTable tr{
    height: 26px;
  }
  .resTable td{
    border: 1px solid #7986CB;
  }
  .resTable td.dummyTd{
    border: 1px solid #303030;
  }
  #controlWrapper{
    margin-left: -24px;
    //border-left: 1px solid #7986CB;
    background-color: #303030;
    
    z-index: 5;
    overflow-x: auto;
    overflow-y: hidden;
  }
</style>