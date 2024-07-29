import app/ui/layout
import gleam/http
import nakai
import wisp.{type Request, type Response}

// `/`
pub fn home(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  layout.empty() |> nakai.to_string_builder |> wisp.html_response(200)
}
