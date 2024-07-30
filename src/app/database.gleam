import app/error
import gleam/result
import simplifile
import sqlight

pub type Connection =
  sqlight.Connection

pub fn migrate_schema(db: sqlight.Connection) -> Result(Nil, error.AppError) {
  let sql_ = simplifile.read(from: "./migration.sql")
  case sql_ {
    Ok(sql) ->
      sqlight.exec(sql, on: db) |> result.replace_error(error.SqlightError)
    Error(_) -> Error(error.FileError)
  }
}
