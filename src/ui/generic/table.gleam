import gleam/int
import gleam/list
import nakai/attr.{class}
import nakai/html

/// Create a list of the type that you want to map to your rows
/// The create function takes a Header, the list of values and then a mapper that maps the value to a Row
///
/// let customer: List(Customer) = [
///   Customer("Jane Doe", "24/07/1997"),
///   Customer("Mary Price", "22/07/2002"),
/// ]
///
/// let header = Header(["Name", "Date of Birth"])
/// let customer_mapper = fn(customer: Customer) -> Row {
///   Row([
///     customer.name,
///     customer.date_of_birth,
///   ])
/// }
///
/// table.create(header, customers, customer_mapper)
/// |> nakai.to_inline_string
/// |> io.println
pub type Data {
  Data(content: String)
  StyledData(content: String, style: String)
}

pub type Row {
  Row(elements: List(Data))
}

pub type Header {
  Header(elements: List(String))
}

pub type Table {
  Table(header: Header, rows: List(Row))
}

pub fn of(header: Header, data: List(a), data_mapper: fn(a) -> Row) -> html.Node {
  let table =
    list.map(data, data_mapper)
    |> Table(header, _)

  let body_content = case list.length(data) {
    0 -> [
      html.tr([], [
        html.td_text(
          [
            attr.Attr("colspan", list.length(header.elements) |> int.to_string),
            class("text-center p-8"),
          ],
          "No Data",
        ),
      ]),
    ]
    _ -> {
      use row <- list.map(table.rows)
      html.tr(
        [],
        list.map(row.elements, fn(data) {
          let style = case data {
            StyledData(_, style) -> style
            _ -> ""
          }
          html.td_text(
            [class("border border-slate-600 p-3.5 " <> style)],
            data.content,
          )
        }),
      )
    }
  }

  html.table([class("w-full border-collapse border border-slate-600")], [
    html.thead([], [
      html.tr([], {
        use elem <- list.map(table.header.elements)
        html.th_text(
          [class("border border-slate-600"), attr.Attr("scope", "col")],
          elem,
        )
      }),
    ]),
    html.tbody([], body_content),
  ])
}
