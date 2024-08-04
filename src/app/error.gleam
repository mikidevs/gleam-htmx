import sqlight

pub type AppError {
  DbError(error: sqlight.Error)
  NotFound
  UnprocessableEntity
  InternalServerError
}
