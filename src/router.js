import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import Login from './views/Login.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/home/',
      name: 'homeView',
      component: Home
    },
    {
      path: '/adminPanel',
      name: 'adminPanel',
      component: () => import (/* webpackChunkName: "admin-panel" */ './views/AdminPanel.vue')
    },
    {
      path: '/createReservation/',
      name: 'createReservation',
      component: () => import(/* webpackChunkName: "create-reservation" */ './views/CreateReservation.vue')
    },
    {
      path: '/editSaleItems/',
      name: 'EditSaleItems',
      component: () => import(/* webpackChunkNanme: "edit-sale-items" */ './components/editSaleItems.vue')
    },
    {
      path: '/editSaleTypes/',
      name: 'editSaleTypes',
      component: () => import(/* webpackChunkName: "edit-sale-types" */ './components/editSaleTypes.vue')
    },
    {
      path: '/editTaxTypes/',
      name: 'editTaxTypes',
      component: () => import(/* webpackChunkName: "edit-tax-types" */ './components/editTaxTypes.vue')
    },
    {
      path: '/login/',
      name: 'login',
      component: Login
    },
    {
      path: '/logoff',
      name: 'logoff',
      component: () => import(/* webpackChunkName: "Logoff" */ './views/Logoff.vue')
    },
    {
      path: '/reopen-shift/:userId',
      name: 'reopen-shift',
      component: () => import( /*webpackChunkName: "reopen-shift" */ './views/ReopenShift.vue'),
      props: true
    },
    {
      path: '/reservations/:reservationId',
      name: 'reservations',
      component: () => import(/* webpackChunkname: "ReservationView" */ './views/ReservationView.vue'),
      props: true
    },
    {
      path: '/resTable',
      name: 'resTable',
      component: () => import(/* webpackChunkName: "ResTable1" */ './views/ResTable.vue')
    },
    {
      path: '/shift-report/:shiftId',
      name: 'shiftReport',
      component: () => import(/* webpackChunkName: "shift-report" */ './views/ShiftReport.vue'),
      props: true
    }
  ]
})
