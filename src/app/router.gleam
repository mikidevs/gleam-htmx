import app/contact.{Contact}
import app/templates/contact_list
import app/templates/index
import app/web.{type Context}
import gleam/http.{Get, Post}
import gleam/list
import gleam/result
import wisp.{type Request, type Response}

const contacts = [
  Contact("John Doe", "jd@mail.com"), Contact("Alice Doe", "ad@mail.com"),
]

pub fn handle_request(req: Request, ctx: Context) -> Response {
  // apply middleware stack to this request/response
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> show_contacts(req)
    ["contacts"] -> add_contact(req)
    _ -> wisp.not_found()
  }
}

fn show_contacts(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  index.render_builder(contacts)
  |> wisp.html_response(200)
}

fn add_contact(req: Request) -> Response {
  use <- wisp.require_method(req, Post)
  use form_data <- wisp.require_form(req)

  // even through the order of the form values can be relied on to pattern match, it's probably better not to rely on that
  let result = {
    use name <- result.try(list.key_find(form_data.values, "name"))
    use email <- result.try(list.key_find(form_data.values, "email"))

    Contact(name, email)
    |> Ok
  }

  case result {
    Ok(contact) -> {
      let new_contacts = [contact, ..contacts]
      contact_list.render_builder(new_contacts)
      |> wisp.html_response(200)
    }
    Error(_) -> {
      wisp.bad_request()
    }
  }
}
