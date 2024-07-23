import sqlight

pub type AppError {
  NotFound
  MethodNotAllowed
  ContactNotFound
  BadRequest(message: String)
  UnprocessableEntity
  ContentRequired
  SqlightError(sqlight.Error)
}
