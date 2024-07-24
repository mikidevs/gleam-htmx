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
// fn list_contacts(req: Request, ctx: Context) -> Response {
//   use <- wisp.require_method(req, Get)
//   let contacts = contact.list_contacts(ctx.db)
//   index.render_builder(contacts)
//   |> wisp.html_response(200)
// }
//
// fn add_contact(req: Request, ctx: Context) -> Response {
//   use <- wisp.require_method(req, Post)
//   use form_data <- wisp.require_form(req)
//
//   let form_data = {
//     use name <- result.try(web.key_find(form_data.values, "name"))
//     use email <- result.try(web.key_find(form_data.values, "email"))
//     Ok(#(name, email))
//   }
//
//   let insert =
//     result.try(form_data, fn(pair) {
//       case pair {
//         #(name, email) -> {
//           use _ <- result.try(contact.has_email(email, ctx.db))
//           contact.insert_contact(name, email, ctx.db)
//         }
//       }
//     })
//
//   let contact_result =
//     result.map(insert, fn(id) {
//       let form_values = result.unwrap(form_data, #("", ""))
//       contact.Contact(id, pair.first(form_values), pair.second(form_values))
//     })
//
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
