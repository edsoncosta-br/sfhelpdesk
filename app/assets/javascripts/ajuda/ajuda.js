//= require trix
//= require actiontext
//= require ./../fontawesome/all.js

document.addEventListener("DOMContentLoaded", function () {

  const trixContent = document.querySelectorAll('.trix-content')
  trixContent.forEach(function(trix) {
    trix.querySelectorAll('a').forEach(function(link) {
      if (link.host !== window.location.host) {
        link.target = "_blank"
      }
    })      
  })    
});