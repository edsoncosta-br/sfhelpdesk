document.addEventListener("DOMContentLoaded", function () {
  const link_avatar = document.getElementById("link-avatar");  

  if (link_avatar !== null) {
    link_avatar.addEventListener("click", (event) => {
      document.getElementById('file-avatar').click();
    });
  }

  const file_avatar = document.getElementById("file-avatar");  
  
  if (file_avatar !== null) {
    file_avatar.addEventListener("change", (event) => {
      if (file_avatar.files && file_avatar.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function (e) {
          document.getElementById('img-avatar-user').setAttribute('src', e.target.result);
        }
        
        reader.readAsDataURL(file_avatar.files[0]);
        
        // parametro de indicacao para o controler de que a foto foi excluida
        document.getElementById('avatar_deleted').setAttribute('value', "");
      }
    });
  }

  const link_avatar_delete = document.getElementById("link-avatar-delete");

  if (link_avatar_delete !== null) {
    link_avatar_delete.addEventListener("click", (event) => {
      document.getElementById('img-avatar-user').setAttribute('src', "/assets/emptyuser.png");
      
      // parametro de indicacao para o controler de que a foto foi excluida
      document.getElementById('avatar_deleted').setAttribute('value', "/assets/emptyuser.png");
    });
  }

});

document.addEventListener("DOMContentLoaded", function () {
  const btn_consultar_received_id = document.getElementById("btn_consultar_id");
  if (btn_consultar_received_id !== null) {  
    btn_consultar_received_id.click();
  }
});