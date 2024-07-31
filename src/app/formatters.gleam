import gleam/int
import gleam/option.{type Option}
import gleam/string
import gleam/string_builder.{type StringBuilder}

fn split_thousands(data: Int, separator: String, accum: StringBuilder) {
  let divided = data / 1000
  case divided == 0 {
    True ->
      accum
      |> string_builder.prepend(int.to_string(data))
      |> string_builder.to_string
    False -> {
      let assert Ok(remainder) = int.remainder(data, 1000)
      split_thousands(
        data / 1000,
        separator,
        accum
          |> string_builder.prepend(
            remainder |> int.to_string |> string.pad_left(3, "0"),
          )
          |> string_builder.prepend(separator),
      )
    }
  }
}

type Opt {
  Decimals(Int)
}

@external(erlang, "erlang", "float_to_binary")
fn float_to_binary(float: Float, options: List(Opt)) -> String

pub fn format_float(
  data: Float,
  decimal_places: Int,
  thousands_separator: Option(String),
) {
  let assert Ok(#(before_decimal, after_decimal)) =
    data
    |> float_to_binary([Decimals(decimal_places)])
    |> string.split_once(".")

  let assert Ok(before_int) = int.parse(before_decimal)
  thousands_separator
  |> option.map(fn(x) {
    let val =
      split_thousands(int.absolute_value(before_int), x, string_builder.new())
    case before_int < 0 {
      True -> "-" <> val
      False -> val
    }
  })
  |> option.unwrap(before_decimal)
  <> case decimal_places == 0 {
    True -> ""
    False -> "." <> string.pad_right(after_decimal, decimal_places, "0")
  }
}
