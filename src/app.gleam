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

  let handle_request = fn(req) {
    use conn <- sqlight.with_connection(":memory:")
    let assert Ok(Nil) = database.migrate_schema(conn)
    let ctx = Context(conn: conn)
    router.handle_request(req, ctx)
  }

  let assert Ok(_) =
    wisp.mist_handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
