import gleam/list
import gleam/result
import nakai/attr
import nakai/html

/// Create a variable of type form and pass it to the render method to return a form node
/// let user = User("Mikaeel", "Salie", "miki@dev.com")
///
/// let with_data: Form =
///   Form([
///     TextControl("firstName", "First Name:", user.first_name),
///     TextControl("lastName", "Last Name:", user.last_name),
///     InvalidTextControl("email", "Email:", user.email, "Email is already used"),
///   ])
///
/// render_form(with_data) |> nakai.to_inline_string |> io.println
pub type Control {
  TextControl(id: String, label: String, value: String)
  InvalidTextControl(id: String, label: String, value: String, error: String)
}

pub type Form {
  Form(controls: List(Control))
}

pub fn create(form: Form) -> html.Node {
  form.controls
  |> list.map(fn(control) {
    let input_elems =
      html.Fragment([
        html.label_text(
          [attr.for(control.id), attr.value(control.value)],
          control.label,
        ),
        html.input([
          attr.type_("text"),
          attr.id(control.id),
          attr.name(control.id),
        ]),
      ])

    case control {
      TextControl(_, _, _) -> input_elems
      InvalidTextControl(_, _, _, error) ->
        html.Fragment([input_elems, html.div_text([], error)])
    }
  })
  |> list.reduce(fn(acc, fragment) {
    case acc, fragment {
      html.Fragment(acc_children), html.Fragment(children) ->
        html.Fragment(list.concat([acc_children, children]))
      _, _ -> html.Nothing
    }
  })
  |> result.unwrap(html.Nothing)
}
