import app/handlers/dashboard
import app/handlers/product
import app/web.{type Context}
import wisp.{type Request, type Response}

// A request travels through the stack from top to bottom until it reaches a request handler
// the response then travels back up through the stack
pub fn handle_request(req: Request, ctx: Context) -> Response {
  // Permit browsers to simulate methods other than GET and POST using the `_method` query parameter
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)

  // Return a 500 response if the request handler crashes
  use <- wisp.rescue_crashes

  // Rewrite HEAD requests to GET requests and return an empty body
  use req <- wisp.handle_head(req)

  use <- wisp.serve_static(req, under: "/static", from: ctx.static_directory)

  case wisp.path_segments(req) {
    [] -> dashboard.home(req)
    ["products"] -> product.all(req, ctx)
    _ -> wisp.not_found()
  }
}
