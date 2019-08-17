<template>
  <div>
    <h3>Admin Panel</h3>
    <v-btn 
      @click="loadEditSaleTypes"
      color="info"
    >
      Sales Types
    </v-btn>
    <v-btn
      color="info"
      to="/editTaxTypes/"
    >Tax Types</v-btn>
    <v-btn
      color="info"
      to="/editSaleItems/"
    >Sale Items</v-btn>
  </div>

</template>

<script>
export default{
  data: function(){
    return {
      user: this.$store.getUser
    }
  },
  methods:{
    loadEditSaleTypes: function(){
      this.$router.push( { name: 'editSaleTypes', params: { user:this.user } } );
    }
  }

}
</script>

<style>

</style>