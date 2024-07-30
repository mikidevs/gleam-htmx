import app/database
import app/router
import app/web.{Context}
import gleam/erlang/process
import mist
import sqlight
import wisp

pub fn main() {
  wisp.configure_logger()

  // Generating a secret key
  let secret_key_base = wisp.random_string(64)

  use conn <- sqlight.with_connection(":memory:")
  let assert Ok(Nil) = database.migrate_schema(conn)

  let handle_request = fn(req) {
    let ctx = Context(db: conn, static_directory: static_directory())
    router.handle_request(req, ctx)
  }

  let assert Ok(_) =
    handle_request
    |> wisp.mist_handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn static_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("app")
  priv_directory <> "/static"
}
