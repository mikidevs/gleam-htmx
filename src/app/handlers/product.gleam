import app/error.{type AppError}
import app/web.{type Context}
import db/product as product_db
import domain/product.{type Product}
import gleam/http.{Get, Post}
import gleam/io
import gleam/list
import gleam/option
import gleam/result.{try}
import gleam/string
import nakai
import sqlight
import ui/generic/table
import ui/layout
import util/formatters
import wisp.{type Request, type Response}

// `/products`
pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_products(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn list_products(req: Request, ctx: Context) -> Response {
  // let products = product_db.read_all(ctx.db)
  //
  // use header <- web.get_header(req, "hx-request")
  // case header {
  //   // Table
  //   Ok(_) ->
  //
  //     |> nakai.to_inline_string_builder
  //     |> wisp.html_response(200)
  //   Error(_) ->
  //     
  //     |> nakai.to_string_builder
  //     |> wisp.html_response(200)
  // }
  wisp.ok()
}
