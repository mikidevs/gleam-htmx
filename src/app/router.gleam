import app/contact_handler
import app/web.{type Context}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  // apply middleware stack to this request/response
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["contacts"] -> contact_handler.all(req, ctx)
    _ -> wisp.not_found()
  }
}
//   case contact_result {
//     Ok(contact) -> {
//       wisp.ok()
//       |> wisp.string_body(
//         html.Fragment([
//           create_contact_form.render(#("", ""), ""),
//           html.div(
//             [attr.id("contacts"), attr.Attr("hx-swap-oob", "afterbegin")],
//             [
//               html.li([], [
//                 html.span([], [html.Text(contact.name <> ": " <> contact.email)]),
//               ]),
//             ],
//           ),
//         ])
//         |> nakai.to_inline_string,
//       )
//     }
//     Error(error.DuplicateEmail) -> {
//       result.unwrap(form_data, #("", ""))
//       |> io.debug
//       |> create_contact_form.render_builder("Email already exists")
//       |> wisp.html_response(422)
//     }
//     _ -> wisp.internal_server_error()
//   }
// }
