$(function(){
  function appendOption(category) {
    let html = `<option value='${category.id}' data-category='${category.id}'>${category.name}</option>`;
    return html;
  }

  function appendChidrenBox(insertHTML) {
    let childrenSelectHtml = '';
    childrenSelectHtml = `
      <div id='children-wrapper'>
        <select id='children-category' class='listing-select-wrapper__added' name='[children_id]'>
          <option value='---' data-category='---'>---</option>
          ${insertHTML}
        </select>
        <i class='fas fa-chevron-down'></i>
      </div>
    `;
    $('.post-cate').append(childrenSelectHtml);
  }

  function appendGrandchidrenBox(insertHTML) {
    let grandchildrenSelectHtml = '';
    grandchildrenSelectHtml = `
      <div id='grandchildren-wrapper'>
        <select id='grandchildren-category' class='listing-select-wrapper__added' name='[grandchildren_id]'>
          <option value='---' data-category='---'>---</option>
          ${insertHTML}
        </select>
        <i class='fas fa-chevron-down'></i>
      </div>
    `;
    $('.post-cate').append(grandchildrenSelectHtml);
  }

  $('#parent_category').on('change', function() {
    let parentId = document.getElementById('parent_category').value;
    if (parentId != '---') {
      $.ajax({
        url: '/posts/get_category_children',
        type: 'GET',
        data: {
          parent_name: parentId,
        },
        dataType: 'json',
      })
        .done(function(children) {
          $('#children-wrapper').remove();
          $('#grandchildren-wrapper').remove();
          let insertHTML = '';
          children.forEach(function(children) {
            insertHTML += appendOption(children);
          });
          appendChidrenBox(insertHTML);
        })
        .fail(function() {
          alert('ジャンル取得に失敗しました');
        });
    } else {
      $('#children-wrapper').remove();
      $('#grandchildren-wrapper').remove();
    }
  });

  $('.post-cate').on('change', '#children-category', function() {
    let childrenId = $('#children-category option:selected').data('category');
    if (childrenId != '---') {
      $.ajax({
        url: '/posts/get_category_grandchildren',
        type: 'GET',
        data: {
          children_id: childrenId,
        },
        dataType: 'json',
      })
        .done(function(grandchildren) {
          if (grandchildren.length != 0) {
            $('#grandchildren-wrapper').remove();
            let insertHTML = '';
            grandchildren.forEach(function(grandchildren) {
              insertHTML += appendOption(grandchildren);
            });
            appendGrandchidrenBox(insertHTML);
          }
        })
        .fail(function() {
          alert('ジャンル取得に失敗しました');
        });
    } else {
      $('#grandchildren-wrapper').remove();
    }
  });

  $('#post-text-area').scroll(function() {
    let scroll = $(this).scrollTop();
    $('.post-text-preview').scrollTop(scroll);
  });
});




