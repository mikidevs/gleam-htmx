import gleam/list
import nakai/attr
import nakai/html

pub type Row {
  Row(elements: List(String))
}

pub type Header {
  Header(elements: List(String))
}

pub type Table {
  Table(title: String, header: Header, rows: List(Row))
}

pub fn create(
  title: String,
  header: Header,
  data: List(a),
  data_mapper: fn(a) -> Row,
) -> Table {
  list.map(data, data_mapper)
  |> Table(title, header, _)
}

pub fn render(table: Table) -> html.Node {
  html.table([], [
    html.thead([], [
      html.tr(
        [],
        list.map(table.header.elements, fn(elem) {
          html.th_text([attr.Attr("scope", "col")], elem)
        }),
      ),
    ]),
    html.tbody([], {
      use row <- list.map(table.rows)
      html.tr([], list.map(row.elements, fn(elem) { html.td_text([], elem) }))
    }),
  ])
}
