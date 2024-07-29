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
