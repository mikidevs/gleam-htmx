import gleam/list
import nakai/attr
import nakai/html

/// Create a list of the type that you want to map to your rows
/// The create function takes the name, a Header, the list of values and then a mapper that maps the value to a Row
///
/// let organisations: List(Organisation) = [
///   Organisation("Standard Bank", "2006/10", Active, "24/07/2024"),
///   Organisation("Mr Price", "2006/12", Active, "22/07/2024"),
/// ]
///
/// let header = Header(["Name", "Registration Number", "Status", "Last Updated"])
/// let org_mapper = fn(org: Organisation) -> Row {
///   Row([
///     org.name,
///     org.registration_number,
///     org.status |> string.inspect,
///     org.last_updated,
///   ])
/// }
///
/// create("Organisations", header, organisations, org_mapper)
/// |> nakai.to_inline_string
/// |> io.println
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
) -> html.Node {
  let table =
    list.map(data, data_mapper)
    |> Table(title, header, _)

  html.table([], [
    html.thead([], [
      html.tr([], {
        use elem <- list.map(table.header.elements)
        html.th_text([attr.Attr("scope", "col")], elem)
      }),
    ]),
    html.tbody([], {
      use row <- list.map(table.rows)
      html.tr([], list.map(row.elements, fn(elem) { html.td_text([], elem) }))
    }),
  ])
}
