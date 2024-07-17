import app/web
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  // apply middleware stack to this request/response
  use _req <- web.middleware(req)

  let body = string_builder.from_string("<h1>Hello, Joe!</h1>")

  wisp.html_response(body, 200)
}
