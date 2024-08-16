import app/error.{type AppError}
import domain/product.{type Product, Product}
import gleam/dynamic
import gleam/result
import sqlight
import ui/page.{type Page}

pub fn read_page(
  db: sqlight.Connection,
  page: Page,
) -> Result(#(List(Product), Int), AppError) {
  let page_sql =
    "
    select name, category, price, status
    from product
    limit ? offset ?
    order by name asc
    "
  let page_ =
    {
      let page_size = page.size
      let offset = page.number * page.size
      use page <- result.try(sqlight.query(
        page_sql,
        on: db,
        with: [sqlight.int(page_size), sqlight.int(offset)],
        expecting: product_decoder(),
      ))
      Ok(page)
    }
    |> result.map_error(fn(e) { error.DbError(e) })

  let count_sql =
    "
    select count(*)
    from product
    "
  let count_ =
    {
      use count <- result.try(sqlight.query(
        count_sql,
        on: db,
        with: [],
        expecting: dynamic.int,
      ))
      let assert [value] = count
      Ok(value)
    }
    |> result.map_error(fn(e) { error.DbError(e) })

  use page <- result.try(page_)
  use count <- result.try(count_)
  Ok(#(page, count))
}

pub fn read_all(db: sqlight.Connection) -> Result(List(Product), AppError) {
  let sql =
    "
    select name, category, price, status
    from product
    order by name asc
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
