import gleam/pair
import gleam/string
import gleam/string_builder
import nakai
import nakai/attr.{Attr}
import nakai/html

pub fn render(form_values: #(String, String), errors: String) -> html.Node {
  let attr_value = case form_values {
    #(name, email) -> #(attr.value(name), attr.value(email))
  }

  let error_value = case string.is_empty(errors) {
    False -> html.div_text([attr.style("color: red")], errors)
    _ -> html.Nothing
  }

  html.form([Attr("hx-swap", "outerHTML"), Attr("hx-post", "/contacts")], [
    html.label_text([attr.for("name")], "Name:"),
    html.input([
      attr.id("name"),
      attr.type_("text"),
      attr.name("name"),
      pair.first(attr_value),
    ]),
    html.br([]),
    html.label_text([attr.for("email")], "Email:"),
    html.input([
      attr.id("email"),
      attr.type_("text"),
      attr.name("email"),
      pair.second(attr_value),
    ]),
    error_value,
    html.br([]),
    html.button_text([attr.type_("submit")], "Create Contact"),
  ])
}

pub fn render_builder(
  form_values: #(String, String),
  errors: String,
) -> string_builder.StringBuilder {
  render(form_values, errors)
  |> nakai.to_inline_string
  |> string_builder.from_string
}
