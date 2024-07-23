import app/contact.{type Contact}
import gleam/list
import gleam/string_builder
import nakai
import nakai/attr
import nakai/html

pub fn render(contacts: List(Contact)) -> html.Node {
  html.ul(
    [attr.id("contacts")],
    list.map(contacts, fn(contact) {
      html.li([], [
        html.span([], [html.Text(contact.name <> ": " <> contact.email)]),
      ])
    }),
  )
}

pub fn render_builder(contacts: List(Contact)) -> string_builder.StringBuilder {
  render(contacts)
  |> nakai.to_inline_string
  |> string_builder.from_string
}
