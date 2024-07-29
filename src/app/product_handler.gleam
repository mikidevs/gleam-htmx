import app/error.{type AppError}
import app/product.{type Product}
import app/views/index
import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
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

fn product_decoder() -> dynamic.Decoder(Product) {
  dynamic.decode5(
    product.Product,
    dynamic.element(0, dynamic.optional(dynamic.int)),
    dynamic.element(1, dynamic.dynamic.int),
    dynamic.element(2, dynamic.dynamic.int),
    dynamic.element(3, dynamic.dynamic.int),
    dynamic.element(4, dynamic.dynamic.int),
  )
}

fn read_products(db: sqlight.Connection) -> Result(List(Product), AppError) {
  todo
}
