import app/product_handler
import app/web.{type Context}
import wisp.{type Request, type Response}

// A request travels through the stack from top to bottom until it reaches a request handler
// the response then travels back up through the stack
pub fn handle_request(req: Request, ctx: Context) -> Response {
  // Permit browsers to simulate methods other than GET and POST using the `_method` query parameter
  let req = wisp.method_override(req)

  // Log info about request and response
  use <- wisp.log_request(req)

  // Return a 500 response if the request handler crashes
  use <- wisp.rescue_crashes

  // Rewirte HEAD requests to GET requests and retuan an empty body
  use req <- wisp.handle_head(req)

  case wisp.path_segments(req) {
    ["contacts"] -> product_handler.all(req, ctx)
    _ -> wisp.not_found()
  }
}
