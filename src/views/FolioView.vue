<template>
  <div>
    <DismissableAppBar
      @app-bar-dismiss="dismiss"
    >
    </DismissableAppBar>
    
        <p>some content</p>
      
  </div>
</template>

<script>
import DismissableAppBar from './../components/dismissableAppBar.vue'
export default {
  name: 'FolioView',
  components: {
    DismissableAppBar
  },
  created(){
    console.log("folioId @ fv", this.folioId);
  },
  data: function(){
    return {

    }
  },
  methods: {
    dismiss(){
      this.$emit("folio-view-dismiss")
    }
  },
  props: {
    folioId: String
  }
}
</script>
