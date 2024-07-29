import gleam/list
import gleam/result

pub type AppError {
  NotFound
  MethodNotAllowed
  BadRequest
  UnprocessableEntity
  ContentRequired
  InvalidSerialisation
}

pub fn key_find(list: List(#(k, v)), key: k) -> Result(v, AppError) {
  list
  |> list.key_find(key)
  |> result.replace_error(UnprocessableEntity)
}
