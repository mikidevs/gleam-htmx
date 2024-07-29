import app/error.{type AppError}
import sqlight
import wisp.{type Response}

pub type Context {
  Context(db: sqlight.Connection)
}

pub fn try_(result: Result(t, AppError), next: fn(t) -> Response) -> Response {
  case result {
    Ok(t) -> next(t)
    Error(error) -> error_to_response(error)
  }
}

// TODO: Return Error Pages based on App Errors
pub fn error_to_response(error: AppError) -> Response {
  case error {
    error.NotFound -> wisp.not_found()
    error.MethodNotAllowed -> wisp.method_not_allowed([])
    error.BadRequest -> wisp.bad_request()
    error.UnprocessableEntity | error.ContentRequired ->
      wisp.unprocessable_entity()
    error.InvalidSerialisation -> wisp.internal_server_error()
    error.SqlightError -> wisp.internal_server_error()
  }
}
