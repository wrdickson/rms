import axios from 'axios'

let api = {
  addNewSaleType: ( user, newSaleType ) => {
    let promise  = axios({
      data: {
        user: user,
        newSaleType: newSaleType
      },
      method: 'post',
      url: '/api/sale-types/'
    });
    return promise;
  },
  addReservation: (user, reservation)=> {
    let promise  = axios({
      data: {
        user: user,
        reservation: reservation
      },
      method: 'post',
      url: '/api/reservations/'
    });
    return promise;
  },
  addReservationNote: ( user, reservationId, note ) => {
    let promise = axios({
      data: {
        user: user,
        note: note
      },
      method: 'post',
      url: '/api/reservationNotes/' + reservationId
    });
    return promise;
  },
  addSalesItem: ( user, saleItem ) => {
    let promise = axios({
      data: {
        user: user,
        sales_item: saleItem
      },
      method: 'post',
      url: '/api/sales-items/'
    });
    return promise;
  }, 
  addTaxType: (user, taxType ) => {
    let promise  = axios({
      data: {
        user: user,
        tax_type: taxType
      },
      method: 'post',
      url: '/api/tax-types/'
    });
    return promise;
  },
  checkAvailability: (resId, user, isNewReservation, start, end, spaceId, people, beds)=>{
    let promise  = axios({
      data: {
        res_id: resId,
        user: user,
        is_new_res: isNewReservation,
        start: start,
        end: end,
        space_id: spaceId,
        people: people,
        beds: beds
      },
      method: 'post',
      url: '/api/checkAvailability/'
    });
    return promise;
  },
  checkAvailabilityByDates: ( start, end, resId ) => {
    if(!resId){
      resId = null;
    }
    let promise  = axios({
      method: 'get',
      url: '/api/checkAvailabilityByDates/' + start + '/' + end 
    });
    return promise;    
  },
  checkinReservation: ( user, resId ) => {
    let promise  = axios({
      data: {
        user: user,
        resId: resId
      },
      method: 'put',
      url: '/api/reservation/checkin/' + resId
    });
    return promise;
  },
  checkoutReservation: (user, resId ) =>{
    let promise  = axios({
      data: {
        user: user,
        resId: resId
      },
      method: 'put',
      url: '/api/reservation/checkout/' + resId
    });
    return promise;  

  },
  closeShift: (user, shift) => {
    let promise  = axios({
      data: {
        user: user,
        shift: shift
      },
      method: 'put',
      url: '/api/shifts/close/' + shift.id
    });
    return promise
  },
  createCustomer: ( user, customer ) => {
    let promise  = axios({
      data: {
        user: user,
        customer: customer
      },
      method: 'post',
      url: '/api/customers/'
    });
    return promise;    
  },
  getFolio: ( user, folioId ) => {
    let request = axios({
      data: {
        user: user
      },
      method: 'post',
      url: '/api/folios/' + folioId,
    });
     return request
  }, 
  getInitialData: () => {
   
  },
  getPaymentTypes: () => {
    let request = axios({
      method: 'get',
      url: '/api/payment-types/',
      });
     return request  
  },
  getReservation: (id)=>{
    let request = axios({
      method: 'get',
      url: '/api/reservations/' + id,
      });
     return request    
  },
  getReservations: ()=>{
    let request = axios({
      method: 'get',
      url: '/api/reservations/'
      });
     return request
  },
  getSalesGroups: () => {
    let request = axios({
      method: 'get',
      url: '/api/sales-groups/'
      });
     return request
  },
  getSalesItems: ()=>{
    let request = axios({
      method: 'get',
      url: '/api/sales-items/'
      });
     return request
  },
  getSaleTypes: ()=>{
    let request = axios({
      method: 'get',
      url: '/api/sale-types/'
      });
     return request
  },
  getSpaces: ()=>{
    return axios({
      method: 'get',
      url: '/api/spaces/'
    });
  },
  getSpaceData: ()=>{
    return axios.all([ axios.get('/api/spaces/'), axios.get('api/types/') ])
      .then(axios.spread(function (spaces, types) {
        return {
           spaces: spaces,
           types: types
        }
      }));
  },
  getSelectGroups: ()=>{
    return axios({
      method: 'get',
      url: '/api/selectGroups/',
    });    
  },
  getShiftData: ( user, shiftId ) => {
    const request = axios({
      method: 'post',
      data: {
        user: user
      },
      url: '/api/shift-data/' + shiftId
    });
    return request;
  },
  getSpaceTypes: ()=>{
    return axios({
      method: 'get',
      url: '/api/types/',
    });
  },
  getTaxTypes: ()=>{
    return axios({
      method: 'get',
      url: '/api/tax-types/',
    });
  },
  getUserShift: ( userId ) =>{
    return axios({
      method: 'get',
      url: '/api/userShift/' + userId,
    });
  },
  login: (username, password) => {
    console.log("firing login @ api");
    const request = axios({
      method: 'post',
      data: {
        username: username,
        password: password
      },
      url: '/api/login/'
    });
    return request;    
  },
  logoff: (userId, key) => {
    let request = axios({
      url: '/api/logoff/',
      data:{
        userId: userId,
        key: key
      },
      method: 'post'
    });
    return request;
  },
  openShift: ( user, startDate )=>{
    const request = axios({
      method: 'post',
      data: {
        user: user,
        startDate: startDate        
      },
      url: '/api/openShift/'
    });
    return request;
  },
  postPayment: (user, paymentObj) => {
    const request = axios({
      method: 'post',
      data: {
        user: user,
        payment_obj: paymentObj       
      },
      url: '/api/payment/'
    });
    return request;    
  },
  postSale: ( user, folio, saleObj ) =>{
    const request = axios({
      method: 'post',
      data: {
        user: user,
        sale_obj: saleObj        
      },
      url: '/api/sale/' + folio
    });
    return request;
  },
  reopenShift( user, shiftId ){
    const request = axios({
      method: 'post',
      data: {
        user: user,
        shift_id: shiftId
      },
      url: '/api/shift-reopen/'
    });
    return request;
  },
  reopenShiftOptions: ( user ) => {
    const request = axios({
      method: 'post',
      data: {
        user: user
      },
      url: '/api/shift-reopen-options/'
    });
    return request;
  },
  searchCustomers: (lastName, firstName ) => {
    const request = axios({
      method: 'post',
      data: {
        lastName: lastName,
        firstName: firstName
      },
      url: '/api/customerSearch/'
    });
    return request;
  },
  updateCustomer: ( args ) => {
    let request = axios({
      url: '/api/customers/' + args.id,
      data: args,
      method: 'post'
    });
    return request;
  },
  updateReservation: ( user, reservation ) => {
    let request = axios({
      url: '/api/reservations/' + reservation.id,
      data: {
        user: user,
        reservation: reservation
      },
      method: 'put'
    });
    return request;
  },
  updateSalesItem: ( user, salesItem ) => {
    let request = axios({
      url: '/api/sales-items/' + salesItem.id,
      data: {
        user: user,
        sales_item: salesItem
      },
      method: 'put'
    });
    return request;
  },
  updateSaleType: ( user, saleType ) => {
    let request = axios({
      url: '/api/sale-types/' + saleType.id,
      data: {
        user: user,
        saleType: saleType
      },
      method: 'put'
    });
    return request;
  },
  updateTaxType: (user, taxType ) => {
    let request = axios({
      url: '/api/tax-types/' + taxType.id,
      data: {
        user: user,
        tax_type: taxType
      },
      method: 'put'
    });
    return request;
  }
};
export default api;


