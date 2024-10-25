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

  const trixContent = document.querySelectorAll('.trix-content')
  trixContent.forEach(function(trix) {
    trix.querySelectorAll('a').forEach(function(link) {
      if (link.host !== window.location.host) {
        link.target = "_blank"
      }
    })      
  })    

});

const allowedImageTypes = ["image/png", "image/jpg", "image/jpeg"]

document.addEventListener("trix-file-accept", e => {
  if (!allowedImageTypes.includes(e.file.type)) {
    e.preventDefault();
    alert("Permitidas somentes images nos formatos PNG e JPG");
  }
})

document.addEventListener("trix-file-accept", e => {
  // const maxFileSize = 1024 * 1024 // 1MB 
  const maxFileSize = 2000000 // 2MB
  if (e.file.size > maxFileSize) {
    e.preventDefault()
    alert("Tamanho máximo da imagem dever ser de 2MB!")
  }
})