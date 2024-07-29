import app/error.{type AppError}
import app/product.{type Product}
import app/views/index
import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/list
import gleam/result.{try}
import sqlight
import wisp.{type FormData, type Request, type Response}

// `/products`
pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_products(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

pub fn list_products(req: Request, ctx: Context) -> Response {
  // read headers
  let result = read_products(ctx.db)
  case result {
    Ok(products) -> products |> layout.with_content |> wisp.html_response
    Error(err) -> web.error_to_response(err)
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
