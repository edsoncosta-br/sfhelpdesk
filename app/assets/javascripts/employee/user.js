function getValue(elementId) {
  let checkboxes = document.getElementsByClassName('form-check-input');
  let elementClicked = document.getElementById(elementId);

  for (var i = 0; i < checkboxes.length; i++) {
    if (checkboxes[i].id.substring(0, 7) === 'main_id') {
      if (elementClicked.checked) {
        if (elementClicked.id !== checkboxes[i].id) {
          checkboxes[i].checked = false
        }
      }
    }
  }
}

function setPrincipal(elementId) {
  let elementClicked = document.getElementById(elementId);
  
  if (elementClicked !== null) {
    
    principalElement = document.getElementById('main_id_' + elementClicked.id.substring(11, 13));

    if (!elementClicked.checked) {
      principalElement.checked = false;
      principalElement.disabled = true;
    } else {
      principalElement.disabled = false;
    }
  }

}

addEventListener("load", (event) => {
  let checkboxes = document.getElementsByClassName('form-check-input');  

  for (var i = 0; i < checkboxes.length; i++) {
    if (checkboxes[i].id.substring(0, 10) === 'project_id') {
      if (!checkboxes[i].checked) {
        setPrincipal(checkboxes[i].id);
      }
    }
  }  
});