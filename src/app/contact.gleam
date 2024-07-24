import app/error
import gleam/dynamic
import gleam/result
import sqlight

pub type Contact {
  Contact(id: Int, name: String, email: String)
}

pub fn contact_row_decoder() -> dynamic.Decoder(Contact) {
  dynamic.decode3(
    Contact,
    dynamic.element(0, dynamic.int),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
  )
}

// Returns id of contact
pub fn insert_contact(
  name: String,
  email: String,
  db: sqlight.Connection,
) -> Result(Int, error.AppError) {
  let sql =
    "
    insert into contacts
      (name, email)
    values
      (?1, ?2)
    returning id;
    "

  use rows <- result.then(
    sqlight.query(
      sql,
      on: db,
      with: [sqlight.text(name), sqlight.text(email)],
      expecting: dynamic.element(0, dynamic.int),
    )
    |> result.map_error(fn(error) { error.BadRequest }),
  )

  let assert [id] = rows
  Ok(id)
}

pub fn list_contacts(db: sqlight.Connection) -> List(Contact) {
  let sql =
    "
    select id, name, email
    from contacts
    order by id asc
    "

  let assert Ok(rows) =
    sqlight.query(sql, on: db, with: [], expecting: contact_row_decoder())

  rows
}

pub fn has_email(
  email: String,
  conn: sqlight.Connection,
) -> Result(Nil, error.AppError) {
  let sql =
    "
    select email
    from contacts
    where contacts.email = ?1;
    "

  let assert Ok(rows) =
    sqlight.query(
      sql,
      on: conn,
      with: [sqlight.text(email)],
      expecting: dynamic.element(0, dynamic.string),
    )

  case rows {
    [] -> Ok(Nil)
    _ -> Error(error.DuplicateEmail)
  }
}
