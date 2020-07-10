$(document).ready(function () {
    $("tbody tr").on("click", function () {
        //loop through all td elements in the row
        $(this).find("td").each(function (i) {
            //toggle between adding/removing the 'active' class
            $(this).toggleClass('active');
        });
    });

    $('#my_datatable tfoot th').each(function () {

      var title = $(this).text();

        $(this).html('<input style="width:'+(title.length+50)+'px !important;" type="text" class="datatable_col_search" placeholder="' + title + '" />');

    });

    // DataTable
    var table = $('#my_datatable').DataTable({

      "scrollX": true,
       "pageLength": 5,

    dom: 'Blfrtip',
        buttons: [
            {
                extend: 'print',
                 
                 customize: function ( win ) {
                    $(win.document.body)
                        .css( 'font-size', '10pt' )
                        .prepend(
                            '<img src="http://datatables.net/media/images/logo-fade.png" style="position:absolute; top:0; left:0;" />'
                        );
                },

                exportOptions: {
                    columns: ':visible'
                }
            },
            'colvis'
        ],
        columnDefs: [ {
            // targets: -1,
            // visible: false
        } ]

       
        // dom: 'Blfrtip'
        // B= b-utton print
        // l= l-ength number of row to show
        // f= f-iltering search
        // r =button search per columns
        // t= t-able
        // p= p-agination
        // tip = buttom pagination
    });
    table.columns().every(function () {
        var that = this;

        $('input', this.footer()).on('keyup change', function () {
            if (that.search() !== this.value) {
                that
                    .search(this.value)
                    .draw();
            }
        });
    });
});