import app/error.{type AppError}
import app/product.{type Product}
import app/ui/layout
import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/http/request
import gleam/io
import gleam/list
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

fn read_all_headers(
  req: Request,
  next: fn(List(#(String, String))) -> Response,
) -> Response {
  case req {
    request.Request(_, headers, _, _, _, _, _, _) -> headers
  }
  |> next
}

fn read_header(
  req: Request,
  header: String,
  next: fn(Result(String, AppError)) -> Response,
) -> Response {
  use headers <- read_all_headers(req)
  web.key_find(headers, header)
  |> next
}

pub fn list_products(req: Request, ctx: Context) -> Response {
  use header <- read_header(req, "hx-request")

  case header {
    // Table
    Ok(_) -> wisp.ok()
    Error(_) ->
      layout.empty() |> nakai.to_string_builder |> wisp.html_response(200)
  }
}

// Data Access

fn product_data_decoder() -> dynamic.Decoder(product.ProductData) {
  dynamic.decode4(
    product.ProductData,
    dynamic.element(0, dynamic.string),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
    dynamic.element(3, dynamic.string),
  )
}

fn read_products(db: sqlight.Connection) -> Result(List(Product), AppError) {
  let sql =
    "
    select name, category, price, status
    from product
    order by id asc
    "
  try(
    sqlight.query(sql, on: db, with: [], expecting: product_data_decoder())
      |> result.replace_error(error.SqlightError),
    fn(rows) { list.map(rows, product.deserialise_product) |> result.all },
  )
}
