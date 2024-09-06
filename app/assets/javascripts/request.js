document.addEventListener("DOMContentLoaded", function () {
  var select = new SlimSelect({
    select: '#tag_ids',
    settings: {
      placeholderText: '',
      searchPlaceholder: 'Buscar',
      searchText: 'Não encontrado',
      hideSelected: true,
      maxSelected: 5
    }
  }) 
  
  if (document.getElementById('tag_ids_selected') != null) {
    select.setSelected(document.getElementById('tag_ids_selected').value.split(' '), false)
  }

  new SlimSelect({
    select: '#customer_id',
    settings: {
      placeholderText: 'Selecione..',
      searchPlaceholder: 'Buscar',
      searchText: 'Não encontrado',
    }
  }) 
  
  if (document.getElementById('tag_ids_selected') != null) {
    select.setSelected(document.getElementById('tag_ids_selected').value.split(' '), false)
  }

});

const allowedImageTypes = ["image/png", "image/jpg", "image/jpeg"]

document.addEventListener("trix-file-accept", e => {
  if (allowedImageTypes.includes(e.file.type)) {
    console.log("attach");
  } else {
    e.preventDefault();
    alert("Permitidas somentes images nos formatos PNG e JPG");
  }
})