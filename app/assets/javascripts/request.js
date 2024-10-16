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

  new SlimSelect({
    select: '#projectssearch_id',
    settings: {
      placeholderText: 'Selecione..',
      searchPlaceholder: 'Buscar',
      searchText: 'Não encontrado',
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

document.addEventListener("change", function () {
  var input = document.getElementById('request_new_files');
  var output = document.getElementById('fileList');
  var children = "";
  
  if (input !== null) {
    for (var i = 0; i < input.files.length; ++i) {
      children += '<li>' + input.files.item(i).name + ' - ' + returnFileSize(input.files.item(i).size) + '</li>';
    }
  }
  
  if (output !== null) {
    output.innerHTML = '<ul>'+children+'</ul>';
  }
});

function returnFileSize(number) {
  if (number < 1024) {
    return `${number} bytes`;
  } else if (number >= 1024 && number < 1048576) {
    return `${(number / 1024).toFixed(1)} KB`;
  } else if (number >= 1048576) {
    return `${(number / 1048576).toFixed(1)} MB`;
  }
};
