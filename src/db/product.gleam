import app/error.{type AppError}
import domain/product.{type Product, Product}
import gleam/dynamic
import gleam/result
import sqlight

pub fn read_all(db: sqlight.Connection) -> Result(List(Product), AppError) {
  let sql =
    "
    select name, category, price, status
    from product
    order by id asc
    "
  {
    use rows <- result.try(sqlight.query(
      sql,
      on: db,
      with: [],
      expecting: product_decoder(),
    ))
    Ok(rows)
  }
  |> result.map_error(fn(e) { error.DbError(e) })
}

fn product_decoder() -> dynamic.Decoder(Product) {
  dynamic.decode4(
    Product,
    dynamic.element(0, dynamic.string),
    dynamic.element(1, product.category_decoder),
    dynamic.element(2, product.currency_decoder),
    dynamic.element(3, product.status_decoder),
  )
}
