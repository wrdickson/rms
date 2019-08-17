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
  transpileDependencies: ['vuetify']

  // DO NOT USE baseUrl UNTIL YOU ARE BUILDING!!

  // Remember to RESTART the DEV SERVER after setting this, but
  // BEFORE running build
  // THEN set it back to blank for local work
  // AND restarting the dev server again
  //  get it?

  // okay, i build this with baseUrl: b, and it seems to work
  // when i run dist from the apache server????/
  // baseUrl: '/vue-v/' //to deploy to b at mytrail.org/vue-v/

  // ??use this when building to serve from localhost with apache

  // build says "baseUrl is deprecated, use 'publicPath' instead
  // baseUrl: '/vue-v/dist/'

}
