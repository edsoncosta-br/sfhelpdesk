document.addEventListener("DOMContentLoaded", function () {
  var select = new SlimSelect({
    select: '#tag_ids',
    settings: {
      placeholderText: '',
      searchPlaceholder: 'Buscar',
      searchText: 'Não encontrado',
      hideSelected: true,
      maxSelected: 5,
      keepOrder: true
    },
    events: {
      afterChange: (newVal) => {
        // console.log(newVal)   
        let ids
        ids = ''
        
        // salva a posicao das tags na ordem selecionada pelo usuario
        let seasonList = document.getElementsByClassName("ss-value")
        for(let i = 0; i < seasonList.length; i++) {
          a =  seasonList[i].getAttribute('data-id')
          ids = ids + document.getElementById(a).value + ' '
        }
        // console.log( ids.trim() )
        document.getElementById('tag_ids_selected').value = ids.trim() 
      }
    }
  }) 
  
  if (document.getElementById('tag_ids_selected') != null) {
    select.setSelected(document.getElementById('tag_ids_selected').value.split(' '), false)
  }

  new SlimSelect({
    select: '#tagsearch_id',
    settings: {
      placeholderText: 'Selecione..',
      searchPlaceholder: 'Buscar',
      searchText: 'Não encontrado'
    }      
  })  

  const trixContent = document.querySelectorAll('.trix-content')
  trixContent.forEach(function(trix) {
    trix.querySelectorAll('a').forEach(function(link) {
      if (link.host !== window.location.host) {
        link.target = "_blank"
      }
    })      
  })    

  // Inicializa o Clipboard.js
  const clipboard = new ClipboardJS('.link');

  // Evento de sucesso
  clipboard.on('success', () => {
    Toastify({text: "Link copiado",
              className: "info",
              style: {background: "#009688",}
    }).showToast();   
  });

  // Evento de erro
  clipboard.on('error', () => {
    Toastify({text: "Copia falhou",
      className: "info",
      style: {background: "#f44336",}
    }).showToast();        
  });        

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
  const maxFileSize = 1000000 // 1MB
  if (e.file.size > maxFileSize) {
    e.preventDefault()
    alert("Tamanho máximo da imagem dever ser de 1MB!")
  }
})