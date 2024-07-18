import gleam/dynamic
import sqlight

pub type Contact {
  Contact(name: String, email: String)
}

pub fn contact_row_decoder() -> dynamic.Decoder(Contact) {
  dynamic.decode2(
    Contact,
    dynamic.element(0, dynamic.string),
    dynamic.element(1, dynamic.string),
  )
}

pub fn has_email(email: String, conn: sqlight.Connection) -> Bool {
  let sql =
    "
    select email
    from contacts
    where contacts.email = ?1
    "

  let assert Ok(rows) =
    sqlight.query(
      sql,
      on: conn,
      with: [sqlight.text(email)],
      expecting: contact_row_decoder(),
    )

  case rows {
    [] -> False
    _ -> True
  }
}
