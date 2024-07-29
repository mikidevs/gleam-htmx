import nakai/attr.{type Attr}

pub fn get(value: String) -> Attr {
  attr.Attr("hx-get", value)
}

pub fn target(value: String) -> Attr {
  attr.Attr("hx-target", value)
}

pub fn push_url(value: String) -> Attr {
  attr.Attr("hx-push-url", value)
}

pub fn boost(value: Bool) -> Attr {
  case value {
    True -> attr.Attr("hx-boost", "true")
    False -> attr.Attr("hx-boost", "false")
  }
}
