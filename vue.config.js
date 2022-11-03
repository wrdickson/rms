module.exports = {

  // proxy the api calls for production
  // comment this out for build
  devServer: {
    proxy: {
      '/': {
        target: 'http://localhost:80',
        // see https://github.com/vuejs/vue-cli/issues/2662
        // firefox keeps throwing an error :
        // The connection to ws://192.168.1.98:8080/sockjs-node/020/oi45qllu/websocket was interrupted while the page was loading.
        // this seems to fix it, but i suppose it would make problems if the the proxy were using sockets ????
        ws: false,
      }
    }
  },
  // app won't run on Edge without this
  transpileDependencies: ['vuetify'],
  // DO NOT USE baseUrl UNTIL YOU ARE BUILDING!!
  //publicPath: '/rms/dist/'
}
