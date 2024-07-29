import gleam/float
import gleam/option.{type Option}

pub type Category {
  Accessories
  Clothing
  Electronics
  Fitness
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
  ProductData(
    id: Option(Int),
    name: String,
    category: String,
    price: String,
    status: String,
  )
}

pub fn serialise_product(product: Product) -> ProductData {
  let category = case product.category {
    Accessories -> "Accessories"
    Clothing -> "Clothing"
    Electronics -> "Electronics"
    Fitness -> "Fitness"
  }

  let price = case product.price {
    Currency(symbol, value) -> symbol <> float.to_string(value)
  }

  let status = case product.status {
    InStock -> "InStock"
    LowStock -> "LowStock"
    OutOfStock -> "OutOfStock"
  }

  ProductData(option.None, product.name, category, price, status)
}

pub fn deserialise_product(product_data: ProductData) -> Product {
  todo
}
