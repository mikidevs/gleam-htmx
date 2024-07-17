import wisp

// A request travels through the stack from top to bottom until it reaches a request handler
// the response then travels back up through the stack

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  // Permit browsers to simulate methods other than GET and POST using the `_method` query parameter
  let req = wisp.method_override(req)

  // Log info about request and response
  use <- wisp.log_request(req)

  // Return a 500 response if the request handler crashes
  use <- wisp.rescue_crashes

  // Rewirte HEAD requests to GET requests and retuan an empty body
  use req <- wisp.handle_head(req)

  handle_request(req)
}
