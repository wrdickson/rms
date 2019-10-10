<template>
  <v-toolbar
    color="green darken-4"
   >
   <v-btn fab outlined color="primary">
     <v-icon large @click="dismiss">mdi-arrow-left-bold</v-icon>
   </v-btn>
  </v-toolbar>
  
</template>

<script>
export default {
  methods: {
    dismiss(){
      this.$emit('app-bar-dismiss')
    }
  },
  name: 'DismissableAppBar'
}
</script>