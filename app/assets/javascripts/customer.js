document.addEventListener("DOMContentLoaded", function () {

  var typeperson = document.getElementById("idtypeperson");
  if (typeperson != null) {
    typeperson.addEventListener("change", (event) => {
      setMaskPerson(true);
    });
  }

  function setMaskPerson(clearcpfcnpj){
    if (typeperson != null) {
      var cpfcnpj = document.getElementById("id_cpfcnpj_number");
      
      if (cpfcnpj != null) {
        if (typeperson.value == 'Jurídica') {
          Inputmask({ "mask": "99.999.999/9999-99", 
          "placeholder": " "}).mask(cpfcnpj);        
        } else {
          Inputmask({ "mask": "999.999.999-99", 
          "placeholder": " "}).mask(cpfcnpj);        
        }
        if (clearcpfcnpj) {
          cpfcnpj.value = '';
        }        
      }
    }    
  }

  setMaskPerson(false);

  var selector = document.getElementById("id_code");
  if (selector != null) {
    Inputmask({ "mask": "99999", 
                "placeholder": " "}).mask(selector);
  }

  var selector = document.getElementById("id_phone");
  if (selector != null) {
    Inputmask({ "mask": "(99) 9999[9]-9999", 
                "placeholder": " "}).mask(selector);
  }

  var selector = document.getElementById("id_cellphone");
  if (selector != null) {
    Inputmask({ "mask": "(99) 999[9]-9999", 
                "placeholder": " "}).mask(selector);
  }  

  var selector = document.getElementById("id_zip_code");
  if (selector != null) {
    Inputmask({ "mask": "99999-999", 
                "placeholder": " "}).mask(selector);
  }

});

