pub type FormData {
  Values(name: String, email: String)
  Errors(name: String, email: String)
}

pub fn is_error(form_data: FormData) -> Bool {
  case form_data {
    Errors(_, _) -> True
    _ -> False
  }
}
