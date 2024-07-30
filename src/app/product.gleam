import app/error
import gleam/float
import gleam/result.{try}

const currency_symbol = "R"

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
  OutOfStock
}

pub type Product {
  Product(name: String, category: Category, price: Currency, status: Status)
}

pub type ProductData {
  ProductData(name: String, category: String, price: String, status: String)
}

pub fn serialise_product(product: Product) -> ProductData {
  let category = case product.category {
    Electronics -> "Electronics"
    Audio -> "Audio"
    OfficeSupplies -> "OfficeSupplies"
    ComputerAccessories -> "ComputerAccessories"
    Smartphones -> "Smartphones"
  }

  let price = case product.price {
    Currency(_, value) -> float.to_string(value)
  }

  let status = case product.status {
    InStock -> "InStock"
    LowStock -> "LowStock"
    OutOfStock -> "OutOfStock"
  }

  ProductData(product.name, category, price, status)
}

pub fn deserialise_product(
  product_data: ProductData,
) -> Result(Product, error.AppError) {
  let category_ = case product_data.category {
    "Electronics" -> Ok(Electronics)
    "Audio" -> Ok(Audio)
    "OfficeSupplies" -> Ok(OfficeSupplies)
    "ComputerAccessories" -> Ok(ComputerAccessories)
    "Smartphones" -> Ok(Smartphones)
    _ -> Error(error.InvalidSerialisation)
  }

  let price_ =
    case product_data.price {
      str -> {
        use value <- try(float.parse(str))
        Ok(Currency(currency_symbol, value))
      }
    }
    |> result.replace_error(error.InvalidSerialisation)

  let status_ = case product_data.status {
    "InStock" -> Ok(InStock)
    "LowStock" -> Ok(LowStock)
    "OutOfStock" -> Ok(OutOfStock)
    _ -> Error(error.InvalidSerialisation)
  }

  use category <- try(category_)
  use price <- try(price_)
  use status <- try(status_)
  Ok(Product(product_data.name, category, price, status))
}
