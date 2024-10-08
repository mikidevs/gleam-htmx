import app/error.{type AppError}
import gleam/http/request
import gleam/list
import gleam/result
import sqlight
import wisp.{type Request, type Response}

pub type Context {
  Context(db: sqlight.Connection, static_directory: String)
}

pub fn key_find(list: List(#(k, v)), key: k) -> Result(v, AppError) {
  list
  |> list.key_find(key)
  |> result.replace_error(error.UnprocessableEntity)
}

pub fn get_all_headers(
  req: Request,
  next: fn(List(#(String, String))) -> Response,
) -> Response {
  case req {
    request.Request(_, headers, _, _, _, _, _, _) -> headers
  }
  |> next
}
