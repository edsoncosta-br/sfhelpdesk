//= require rails-ujs
//= require activestorage
//= require @popperjs/core/dist/umd/popper.js
//= require bootstrap/dist/js/bootstrap
//= require toastify-js/src/toastify.js
//= require inputmask/dist/inputmask.js
//= require ./flashMessages.js
//= require ./fontawesome/all.js
//= require ./scripts.js

document.addEventListener("DOMContentLoaded", function () {
  const btn_consultar_id = document.getElementById("btn_consultar_id");
  if (btn_consultar_id !== null) {  
    btn_consultar_id.click();
  }
});