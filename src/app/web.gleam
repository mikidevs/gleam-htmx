import app/error.{type AppError}
import gleam/list
import gleam/result
import sqlight
import wisp.{type Response}

pub type Context {
  Context(db: sqlight.Connection)
}

// A request travels through the stack from top to bottom until it reaches a request handler
// the response then travels back up through the stack
pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> Response,
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

pub fn key_find(list: List(#(k, v)), key: k) -> Result(v, AppError) {
  list
  |> list.key_find(key)
  |> result.replace_error(error.UnprocessableEntity)
}

pub fn try_(result: Result(t, AppError), next: fn(t) -> Response) -> Response {
  case result {
    Ok(t) -> next(t)
    Error(error) -> error_to_response(error)
  }
}

pub fn error_to_response(error: AppError) -> Response {
  case error {
    error.NotFound -> wisp.not_found()
    error.MethodNotAllowed -> wisp.method_not_allowed([])
    error.BadRequest(_) -> wisp.bad_request()
    error.UnprocessableEntity | error.ContentRequired ->
      wisp.unprocessable_entity()
    error.SqlightError(_) -> wisp.internal_server_error()
  }
}
