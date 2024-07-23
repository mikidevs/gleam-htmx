import app/contact.{Contact}
import app/templates/contact_list
import app/templates/create_contact
import app/templates/index
import app/web.{type Context}
import gleam/http.{Get, Post}
import gleam/result
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  // apply middleware stack to this request/response
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> list_contacts(req, ctx)
    ["contacts"] -> add_contact(req, ctx)
    _ -> wisp.not_found()
  }
}

fn list_contacts(req: Request, ctx: Context) -> Response {
  use <- wisp.require_method(req, Get)
  let contacts = contact.list_contacts(ctx.db)
  index.render_builder(contacts)
  |> wisp.html_response(200)
}

fn add_contact(req: Request, ctx: Context) -> Response {
  use <- wisp.require_method(req, Post)
  use form_data <- wisp.require_form(req)

  let result = {
    use name <- result.try(web.key_find(form_data.values, "name"))
    use email <- result.try(web.key_find(form_data.values, "email"))
    use _ <- result.try(contact.has_email(email, ctx.db))
    use id <- result.try(contact.insert_contact(name, email, ctx.db))

    Ok(Contact(id, name, email))
  }

  case result {
    Ok(contact) -> {
      let contacts = contact.list_contacts(ctx.db)
      contact_list.render_builder(contacts)
      |> wisp.html_response(200)
    }
    Error(_) -> {
      contact_list.render_builder()
      |> wisp.bad_request()
    }
  }
}
