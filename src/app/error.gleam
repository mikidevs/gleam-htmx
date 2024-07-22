import sqlight

pub type AppError {
  NotFound
  MethodNotAllowed
  ContactNotFound
  BadRequest
  UnprocessableEntity
  ContentRequired
  SqlightError(sqlight.Error)
}
