import gleam/option.{type Option}

pub type Contact {
  Contact(id: Option(Int), name: String, email: String)
}
