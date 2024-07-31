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
  SoldOut
}

pub type Product {
  Product(name: String, category: Category, price: Currency, status: Status)
}

pub type ProductData {
  ProductData(name: String, category: String, price: Float, status: String)
}

pub fn serialise_product(product: Product) -> ProductData {
  let category = case product.category {
    Electronics -> "Electronics"
    Audio -> "Audio"
    OfficeSupplies -> "Office Supplies"
    ComputerAccessories -> "Computer Accessories"
    Smartphones -> "Smartphones"
  }

  let price = case product.price {
    Currency(_, value) -> value
  }

  let status = case product.status {
    InStock -> "In Stock"
    LowStock -> "Low Stock"
    SoldOut -> "Sold Out"
  }

  ProductData(product.name, category, price, status)
}

pub fn deserialise_product(
  product_data: ProductData,
) -> Result(Product, error.AppError) {
  let category_ = case product_data.category {
    "Electronics" -> Ok(Electronics)
    "Audio" -> Ok(Audio)
    "Office Supplies" -> Ok(OfficeSupplies)
    "Computer Accessories" -> Ok(ComputerAccessories)
    "Smartphones" -> Ok(Smartphones)
    _ -> Error(error.InvalidSerialisation)
  }

  let price_ =
    case product_data.price {
      value -> {
        Ok(Currency(currency_symbol, value))
      }
    }
    |> result.replace_error(error.InvalidSerialisation)

  let status_ = case product_data.status {
    "In Stock" -> Ok(InStock)
    "Low Stock" -> Ok(LowStock)
    "Sold Out" -> Ok(SoldOut)
    _ -> Error(error.InvalidSerialisation)
  }

  use category <- try(category_)
  use price <- try(price_)
  use status <- try(status_)
  Ok(Product(product_data.name, category, price, status))
}
