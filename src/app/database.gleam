import sqlight

pub type Connection =
  sqlight.Connection

pub fn migrate_schema(db: sqlight.Connection) -> Result(Nil, sqlight.Error) {
  sqlight.exec(
    "
    create table if not exists customers(
      name text,
      email text
    );

    insert into customers (name, email) values
    ('John Doe', 'jd@mail.com'),
    ('Alice Doe', 'ad@mail.com');
    ",
    db,
  )
}
