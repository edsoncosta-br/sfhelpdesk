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
});