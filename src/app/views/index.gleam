import app/contact.{type Contact}
import app/views/contact_list
import app/views/create_contact_form
import gleam/string_builder
import nakai
import nakai/attr
import nakai/html

pub fn render(contacts: List(Contact)) -> string_builder.StringBuilder {
  html.Html([attr.lang("en-US")], [
    html.Head([
      html.Script(
        [
          attr.src("https://unpkg.com/htmx.org@2.0.1"),
          attr.integrity(
            "sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/",
          ),
          attr.crossorigin(),
        ],
        "",
      ),
      html.Script(
        [],
        "
        // allow 422 and rerender with errors
        document.addEventListener(\"DOMContentLoaded\", (event) => {
          document.body.addEventListener('htmx:beforeSwap', function(evt) {
            if (evt.detail.xhr.status === 422) {
              evt.detail.shouldSwap = true;
              evt.detail.isError = false;
            }
          });
        });
        ",
      ),
      html.title("HTMX Testing in Gleam"),
    ]),
    html.Body([], [
      create_contact_form.render(#("", ""), ""),
      contact_list.render(contacts),
    ]),
  ])
  |> nakai.to_inline_string_builder
}
