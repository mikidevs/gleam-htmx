import app/error.{type AppError}
import gleam/http/request
import gleam/list
import gleam/result
import sqlight
import wisp.{type Request, type Response}

pub type Context {
  Context(db: sqlight.Connection, static_directory: String)
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
  }
}

pub fn key_find(list: List(#(k, v)), key: k) -> Result(v, AppError) {
  list
  |> list.key_find(key)
  |> result.replace_error(error.UnprocessableEntity)
}

pub fn read_all_headers(
  req: Request,
  next: fn(List(#(String, String))) -> Response,
) -> Response {
  case req {
    request.Request(_, headers, _, _, _, _, _, _) -> headers
  }
  |> next
}

pub fn read_header(
  req: Request,
  header: String,
  next: fn(Result(String, AppError)) -> Response,
) -> Response {
  use headers <- read_all_headers(req)
  key_find(headers, header)
  |> next
}
