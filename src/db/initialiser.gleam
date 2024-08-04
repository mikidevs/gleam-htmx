import gleam/result
import sqlight

pub type Connection =
  sqlight.Connection

pub fn migrate_schema(db: sqlight.Connection) -> Result(Nil, Nil) {
  let sql =
    "
    create table if not exists product (
      id integer primary key autoincrement not null,
      name text,
      category text,
      price real,
      status text
    );

    insert into product (name, category, price, status) values
    ('Laptop', 'Electronics', 25000.00, 'In Stock'),
    ('Headphones', 'Audio', 900.00, 'Low Stock'),
    ('Tablet', 'Electronics', 5000.00, 'Low Stock'),
    ('Gaming Console', 'Electronics', 4000.00, 'Sold Out'),
    ('Printer', 'Office Supplies', 1000.00, 'In Stock'),
    ('Mouse', 'Computer Accessories', 200.00, 'In Stock'),
    ('Keyboard', 'Computer Accessories', 250.00, 'In Stock'),
    ('Speakers', 'Audio', 1500.00, 'Sold Out'),
    ('External Hard Drive', 'Electronics', 300.00, 'Low Stock'),
    ('Notebook', 'Office Supplies', 750.00, 'In Stock'),
    ('USB Hub', 'Computer Accessories', 150.00, 'In Stock'),
    ('Monitor', 'Electronics', 800.00, 'Low Stock'),
    ('Charging Station', 'Electronics', 120.00, 'In Stock'),
    ('Printer Paper', 'Office Supplies', 20.00, 'In Stock'),
    ('Mouse Pad', 'Computer Accessories', 15.00, 'In Stock'),
    ('Webcam', 'Computer Accessories', 75.00, 'Low Stock'),
    ('iPhone', 'Smartphones', 50000.00, 'Sold Out'),
    ('Smartwatch', 'Smartphones', 450.00, 'In Stock');
    "
  sqlight.exec(sql, on: db) |> result.nil_error
}
