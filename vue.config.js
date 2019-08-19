module.exports = {
  // we need this for templating, why doesn't the documentation
  // mention this?
  // runtimeCompiler: true,
  // proxy the api calls for production
  // comment this out for build
  devServer: {
    proxy: 'http://127.0.0.1:80'
  },
  // app won't run on Edge without this
  transpileDependencies: ['vuetify'],
  // DO NOT USE baseUrl UNTIL YOU ARE BUILDING!!
  //publicPath: '/rms/dist/'
}
