import domain/product.{type Product}
import gleam/option
import nakai/html
import ui/generic/table.{Data}
import ui/hx
import ui/layout
import util/formatters

pub fn full_page() {
  layout.with_content(html.div_text(
    [hx.get("/products"), hx.target("#content"), hx.trigger("load")],
    "Loading...",
  ))
}

pub fn table(products: List(Product)) {
  table.of(
    table.Header(["Name", "Category", "Price", "Status"]),
    products,
    fn(p: Product) {
      table.Row([
        Data(p.name),
        Data(product.encode_category(p.category)),
        table.StyledData(
          "R"
            <> product.encode_price(p.price)
          |> formatters.format_float_str(2, option.Some(" ")),
          "text-right",
        ),
        Data(product.encode_status(p.status)),
      ])
    },
  )
}
