import app/web.{type Context}
import db/product as product_db
import gleam/http.{Get, Post}
import gleam/io
import nakai
import nakai/attr
import nakai/html
import ui/hx
import ui/layout
import ui/page
import ui/pages/product as product_page
import wisp.{type Request, type Response}

// `/products`
pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_products(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn list_products(req: Request, ctx: Context) -> Response {
  let page = wisp.get_query(req) |> page.page_decoder

  case hx.is_hx_request(req) {
    True -> {
      let products = product_db.read_page(ctx.db, page)
      case products {
        Ok(products) ->
          html.Fragment([
            html.h1_text([attr.class("text-xl bold mb-6")], "Products"),
            product_page.table(products),
          ])
          |> to_ok
        Error(_) ->
          html.Fragment([
            product_page.table([]),
            layout.add_toast(html.span_text(
              [],
              "There was a problem retrieving products",
            )),
          ])
          // Make this return the correct http code
          |> to_ok
      }
    }
    False -> {
      product_page.full_page()
      |> to_ok
    }
  }
}

fn to_ok(content) -> Response {
  content |> nakai.to_inline_string_builder |> wisp.html_response(200)
}
