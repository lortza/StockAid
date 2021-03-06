$(document).on "page:change", ->
  $(".data-table").each ->
    table = $(@)

    return if $.fn.dataTable.isDataTable(table)


    fnFooterCallback = (row, data, start, end, display) ->
      numColumnIndex = table.find("th.num-value").index()
      monetaryColumnIndex = table.find("th.monetary-value").index()

      # Utility function to convert "1234567.00" to "1,234,567.00"
      numberWithCommas = (x) ->
        x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      # Utility function to convert string dollar amount to a number
      intVal = (i) ->
        if typeof i == 'string' then i.replace(/[\$,]/g, '') * 1 else if typeof i == 'number' then i else 0

      # Calculate the totals for the current page
      numTotal = @api().column(numColumnIndex, page: 'current').data().reduce(((a, b) ->
        intVal(a) + intVal(b)
      ), 0)
      pageTotal = @api().column(monetaryColumnIndex, page: 'current').data().reduce(((a, b) ->
        intVal(a) + intVal(b)
      ), 0).toFixed(2)

      # Render the totals on the footer
      $(@api().column(numColumnIndex).footer()).html numTotal
      $(@api().column(monetaryColumnIndex).footer()).html '$'+ numberWithCommas(pageTotal)

    options =
      responsive: true
      order: [[0, "desc"]]
      pageLength: 25
      fnFooterCallback: fnFooterCallback

    ascColumn = table.find("th.sort-asc").index()
    descColumn = table.find("th.sort-desc").index()

    if (ascColumn >= 0)
      options["order"] = [[ ascColumn, "asc" ]]

    if (descColumn >= 0)
      options["order"] = [[ descColumn, "desc" ]]

    if table.hasClass("no-paging")
      options["paging"] = false

    table.dataTable(options)

    if table.hasClass("autofocus-search")
        $("div.dataTables_filter input").focus()
