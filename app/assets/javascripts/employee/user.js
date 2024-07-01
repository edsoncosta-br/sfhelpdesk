// document.addEventListener("DOMContentLoaded", function () {
//   (() => {
//     'use strict'

//     // Fetch all the forms we want to apply custom Bootstrap validation styles to
//     const forms = document.querySelectorAll('.needs-validation')

//     // Loop over them and prevent submission
//     Array.from(forms).forEach(form => {
//       console.log("01")
//       form.addEventListener('submit', event => {
//         console.log("02")
//         if (!form.checkValidity()) {
//           console.log("03")
//           event.preventDefault()
//           event.stopPropagation()
//         }

//         form.classList.add('was-validated')
//       }, false)
//     })
//   })()
// });