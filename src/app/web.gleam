import app/error.{type AppError}
import gleam/list
import gleam/result
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

pub fn error_to_response(error: AppError) -> Response {
  case error {
    error.NotFound -> wisp.not_found()
    error.MethodNotAllowed -> wisp.method_not_allowed([])
    error.BadRequest -> wisp.bad_request()
    error.UnprocessableEntity | error.ContentRequired ->
      wisp.unprocessable_entity()
    error.InvalidSerialisationTarget -> wisp.internal_server_error()
  }
}
