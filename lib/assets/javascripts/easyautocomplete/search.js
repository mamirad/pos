 $input = $("[data-behavior='autocomplete']")
  var options = {
   getValue: function (element) {
    return element.id+'  |  '+element.name
    },
    url: function(phrase) {
      return "/items/auto_search.json?q=" + phrase;
    },
    categories: [
      {
        listLocation: "items",
        header: "<strong>item(s)</strong>",
      }
    ],
    list: {
      onChooseEvent: function() {
        var id = $input.getSelectedItemData().id
          var sale_id = document.getElementById("auto_search_item").attributes['data-sale-id'].value
          $.get('/sales/create_line_item?item_id='+id+'&quantity=1&sale_id='+sale_id+'.js', function(data){
          // $(".teacher_email").val(data.response);
           
        });
        console.log(sale_id)
        // $input.val("")
        // Turbolinks.visit(url)
      }
    }
  }








  $input.easyAutocomplete(options)


