import sqlight

pub type AppError {
  NotFound
  MethodNotAllowed
  BadRequest(message: String)
  UnprocessableEntity
  ContentRequired
  SqlightError(sqlight.Error)
}
