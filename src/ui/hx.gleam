import gleam/http/request
import gleam/result
import nakai/attr.{type Attr}
import wisp

pub fn get(value: String) -> Attr {
  attr.Attr("hx-get", value)
}

pub fn target(value: String) -> Attr {
  attr.Attr("hx-target", value)
}

pub fn push_url(value: String) -> Attr {
  attr.Attr("hx-push-url", value)
}

pub fn trigger(value: String) -> Attr {
  attr.Attr("hx-trigger", value)
}

pub fn boost(value: Bool) -> Attr {
  case value {
    True -> attr.Attr("hx-boost", "true")
    False -> attr.Attr("hx-boost", "false")
  }
}

pub fn is_hx_request(req: wisp.Request) -> Bool {
  request.get_header(req, "hx-request") |> result.is_ok()
}
