import gleam/http
import nakai
import nakai/html
import ui/layout
import wisp.{type Request, type Response}

// `/`
pub fn home(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  html.div_text([], "")
  |> layout.with_content
  |> nakai.to_string_builder
  |> wisp.html_response(200)
}
