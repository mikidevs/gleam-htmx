import gleam/list
import gleam/result
import nakai/attr
import nakai/html

pub type Control {
  TextControl(id: String, label: String, value: String)
  InvalidTextControl(id: String, label: String, value: String, error: String)
}

pub type Form {
  Form(controls: List(Control))
}

pub type User {
  User(first_name: String, last_name: String, email: String)
}

pub fn render_form(form: Form) -> html.Node {
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
