document.addEventListener("DOMContentLoaded", function () {
  new SlimSelect({
    select: '#multiple_tag',
    settings: {
      placeholderText: '',
      searchPlaceholder: 'Buscar',
      keepOrder: true,
      maxSelected: 5
    }
  }) 
});