import app/contact.{type Contact}
import app/error
import app/views/index
import app/web.{type Context}
import gleam/dynamic
import gleam/http.{Get, Post}
import gleam/result.{try}
import sqlight
import wisp.{type FormData, type Request, type Response}

// handler for `/contact`
pub fn all(req: Request, ctx: Context) -> Response {
  case req.method {
    Get -> list_contacts(ctx)
    Post -> create_contact(req, ctx)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

pub fn list_contacts(ctx: Context) -> Response {
  let result = read_contacts(ctx.db)
  case result {
    Ok(contacts) -> contacts |> index.render() |> wisp.html_response(200)
    Error(Nil) -> wisp.internal_server_error()
    // map all errors to 500
  }
}

pub fn create_contact(req: Request, ctx: Context) -> Response {
  use form_data <- wisp.require_form(req)

  let contact_r = {
    use contact <- try(decode_contact(form_data))
    Ok(contact)
  }

  // There is probably a better way to this using try and try_recover
  let result = {
    case contact_r {
      Ok(contact) -> {
        case email_exists(contact.email, ctx) {
          Error(_) -> contact_r |> result.replace_error(error.DuplicateEmail)
          _ -> Ok(contact)
        }
      }
      _ -> Error(error.UnprocessableEntity)
    }
  }

  case result {
    Ok(contact) -> wisp.ok()
    Error(error.UnprocessableEntity) -> wisp.unprocessable_entity()
    Error(error.DuplicateEmail) -> wisp.unprocessable_entity()
    _ -> wisp.internal_server_error()
  }
}

// Form Handling

fn decode_contact(form_data: FormData) -> Result(Contact, Nil) {
  try(form_data |> dynamic.from |> contact_decoder(), fn(contact) {
    Ok(contact)
  })
  |> result.nil_error
}

// Data Access

fn contact_decoder() -> dynamic.Decoder(Contact) {
  dynamic.decode3(
    contact.Contact,
    dynamic.element(0, dynamic.optional(dynamic.int)),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
  )
}

pub fn read_contacts(db: sqlight.Connection) -> Result(List(Contact), Nil) {
  let sql =
    "
    select id, name, email
    from contacts
    order by id asc
    "
  //TODO:map the errors to app error and return appropriate response to browser
  {
    use rows <- try(sqlight.query(
      sql,
      on: db,
      with: [],
      expecting: contact_decoder(),
    ))
    Ok(rows)
  }
  |> result.nil_error
}

pub fn email_exists(email: String, ctx: Context) -> Result(Nil, error.AppError) {
  let sql =
    "
    select email
    from contacts
    where contacts.email = ?1;
    "

  let assert Ok(rows) =
    sqlight.query(
      sql,
      on: ctx.db,
      with: [sqlight.text(email)],
      expecting: dynamic.element(0, dynamic.string),
    )

  case rows {
    [] -> Ok(Nil)
    _ -> Error(error.DuplicateEmail)
  }
}
//
// // Returns id of contact
// pub fn create_contact(
//   name: String,
//   email: String,
//   db: sqlight.Connection,
// ) -> Result(Int, Nil) {
//   let sql =
//     "
//     insert into contacts
//       (name, email)
//     values
//       (?1, ?2)
//     returning id;
//     "
//
//   use rows <- try(sqlight.query(
//       sql,
//       on: db,
//       with: [sqlight.text(name), sqlight.text(email)],
//       expecting: dynamic.element(0, dynamic.int),
//     )
//   )
//   case rows {
//     [id] -> Ok(id)
//     _ -> Error(Nil)
//   }
// }
