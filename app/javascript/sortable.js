import Sortable from 'sortablejs';

window.onload = function() {
  const el = document.getElementById('sortable');
  if (el === null) {
    return;
  }

  const sortable = Sortable.create(el, {
    handle: '.sort-handle',
    onUpdate: function(e) {
      const url = el.dataset.sortUrl;

      $.ajax({
        url: url,
        data: { oldIndex: e.oldIndex, newIndex: e.newIndex },
        type: 'post',
        headers: {
          'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
        }
      })
    }
  });
}
