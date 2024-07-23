import gleam/string_builder
import nakai
import nakai/attr.{Attr}
import nakai/html

pub fn render() -> html.Node {
  html.form(
    [
      Attr("hx-swap", "outerHTML"),
      Attr("hx-target", "#contacts"),
      Attr("hx-post", "/contacts"),
    ],
    [
      html.label_text([attr.for("name")], "Name:"),
      html.input([attr.id("name"), attr.type_("text"), attr.name("name")]),
      html.br([]),
      html.label_text([attr.for("email")], "Email:"),
      html.input([attr.id("email"), attr.type_("text"), attr.name("email")]),
      html.br([]),
      html.button_text([attr.type_("submit")], "Create Contact"),
    ],
  )
}

pub fn render_builder() -> string_builder.StringBuilder {
  render()
  |> nakai.to_inline_string
  |> string_builder.from_string
}
