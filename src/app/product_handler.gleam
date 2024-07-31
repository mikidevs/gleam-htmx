import app/error.{type AppError}
import app/formatters
import app/product.{type Product}
import app/ui/generic/table
import app/ui/layout
import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/io
import gleam/list
import gleam/option
import gleam/result.{try}
import gleam/string
import nakai
import sqlight
import wisp.{type Request, type Response}

// `/products`
pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_products(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

pub fn list_products(req: Request, ctx: Context) -> Response {
  use header <- web.read_header(req, "hx-request")
  let products = read_products(ctx.db)

  let table =
    table.of(
      table.Header(["Name", "Category", "Price", "Status"]),
      products,
      fn(p) {
        let product_data = product.serialise_product(p)
        table.Row([
          product_data.name,
          product_data.category,
          "R"
            <> product_data.price
          |> formatters.format_float(2, option.Some(" ")),
          product_data.status,
        ])
      },
    )
  case header {
    // Table
    Ok(_) ->
      table
      |> nakai.to_inline_string_builder
      |> wisp.html_response(200)
    Error(_) ->
      table
      |> layout.with_content
      |> nakai.to_string_builder
      |> wisp.html_response(200)
  }
}

// Data Access

fn product_data_decoder() -> dynamic.Decoder(product.ProductData) {
  dynamic.decode4(
    product.ProductData,
    dynamic.element(0, dynamic.string),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.float),
    dynamic.element(3, dynamic.string),
  )
}

// Always crash when failing to read from db: this is intended since these errors 
// are not recoverable
fn read_products(db: sqlight.Connection) -> List(Product) {
  let sql =
    "
    select name, category, price, status
    from product
    order by id asc
    "
  let assert Ok(rows) =
    sqlight.query(sql, on: db, with: [], expecting: product_data_decoder())
  let pr_map = list.map(rows, product.deserialise_product)
  let assert Ok(products) = result.all(pr_map)
  products
}
