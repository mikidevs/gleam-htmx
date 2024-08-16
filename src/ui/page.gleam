import gleam/int
import gleam/result

pub type Page {
  Page(number: Int, size: Int)
}

pub fn default_page() {
  Page(1, 10)
}

pub fn page_decoder(query_params: List(#(String, String))) -> Page {
  case query_params {
    [#("pageNumber", pn), #("pageSize", ps)] ->
      {
        use page_num <- result.try(int.parse(pn))
        use page_size <- result.try(int.parse(ps))
        Ok(Page(page_num, page_size))
      }
      |> result.unwrap(default_page())
    _ -> default_page()
  }
}
