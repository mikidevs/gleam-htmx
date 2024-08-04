import gleam/dynamic.{
  type DecodeError, type DecodeErrors, type Dynamic, DecodeError,
}
import gleam/float
import gleam/result.{try}

pub type Category {
  Electronics
  Audio
  OfficeSupplies
  ComputerAccessories
  Smartphones
}

pub type Currency {
  Currency(symbol: String, value: Float)
}

pub type Status {
  InStock
  LowStock
  SoldOut
}

pub type Product {
  Product(name: String, category: Category, price: Currency, status: Status)
}

pub fn encode_category(category: Category) -> String {
  case category {
    Electronics -> "Electronics"
    Audio -> "Audio"
    OfficeSupplies -> "Office Supplies"
    ComputerAccessories -> "Computer Accessories"
    Smartphones -> "Smartphones"
  }
}

pub fn encode_price(price: Currency) -> String {
  case price {
    Currency(_, value) -> value |> float.to_string
  }
}

pub fn encode_status(status: Status) -> String {
  case status {
    InStock -> "In Stock"
    LowStock -> "Low Stock"
    SoldOut -> "Sold Out"
  }
}

pub fn category_decoder(dyn: Dynamic) -> Result(Category, DecodeErrors) {
  use c_str <- result.try(dynamic.string(dyn))

  use category <- result.try(
    case c_str {
      "Electronics" -> Ok(Electronics)
      "Audio" -> Ok(Audio)
      "Office Supplies" -> Ok(OfficeSupplies)
      "Computer Accessories" -> Ok(ComputerAccessories)
      "Smartphones" -> Ok(Smartphones)
      _ -> Error(Nil)
    }
    |> result.map_error(fn(_) {
      [DecodeError(expected: "category", found: c_str, path: ["frequency"])]
    }),
  )
  Ok(category)
}

pub fn currency_decoder(dyn: Dynamic) -> Result(Currency, DecodeErrors) {
  use c_str <- try(dynamic.string(dyn))

  use currency <- try(
    case float.parse(c_str) {
      Ok(value) -> Ok(Currency("R", value))
      _ -> Error(Nil)
    }
    |> result.map_error(fn(_) {
      [DecodeError(expected: "currency", found: c_str, path: ["currency"])]
    }),
  )
  Ok(currency)
}

pub fn status_decoder(dyn: Dynamic) -> Result(Status, DecodeErrors) {
  use s_str <- try(dynamic.string(dyn))

  use status <- try(
    case s_str {
      "In Stock" -> Ok(InStock)
      "Low Stock" -> Ok(LowStock)
      "Sold Out" -> Ok(SoldOut)
      _ -> Error(Nil)
    }
    |> result.map_error(fn(_) {
      [DecodeError(expected: "status", found: s_str, path: ["status"])]
    }),
  )
  Ok(status)
}
