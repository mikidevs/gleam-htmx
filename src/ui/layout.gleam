import nakai/attr.{class}
import nakai/html.{type Node, a_text}
import ui/hx

fn head() -> Node {
  html.Head([
    html.Script(
      [
        attr.src("https://unpkg.com/htmx.org@2.0.1"),
        attr.integrity(
          "sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/",
        ),
        attr.crossorigin(),
      ],
      "",
    ),
    html.Script([attr.src("https://cdn.tailwindcss.com")], ""),
    html.link([attr.rel("stylesheet"), attr.href("/static/styles.css")]),
    html.title("HTMX Testing in Gleam"),
  ])
}

fn nav() -> Node {
  let link_style = "cursor-pointer px-6 py-3 hover:bg-slate-700"

  html.nav([class("w-72 min-h-screen bg-slate-800 border-r border-slate-600")], [
    html.div([class("p-6")], [
      html.h1_text(
        [class("pb-6 text-2xl w-full text-center")],
        "HTMX is Awesome",
      ),
      html.hr([]),
    ]),
    html.div([hx.boost(True), class("flex flex-col")], [
      a_text([attr.href("/"), hx.target("body"), class(link_style)], "Home"),
      a_text(
        [attr.href("/products"), hx.target("#content"), class(link_style)],
        "Product List",
      ),
      a_text(
        [attr.href("#"), hx.target("#content"), class(link_style)],
        "Add Product",
      ),
      a_text(
        [attr.href("#"), hx.target("#content"), class(link_style)],
        "Sales Management",
      ),
    ]),
  ])
}

pub fn add_toast(content: Node) -> Node {
  html.div(
    [attr.id("toast-container"), attr.Attr("hx-swap-oob", "beforeend")],
    // TODO: add toast types
    [
      html.div(
        [class("bg-slate-800 border border-slate-600 rounded-lg shadow p-4")],
        [content],
      ),
    ],
  )
}

pub fn with_content(content: Node) -> Node {
  html.Html([attr.lang("en-US")], [
    head(),
    html.Body([class("flex")], [
      html.div(
        [
          attr.id("toast-container"),
          class(
            "fixed top-5 right-5 items-center text-gray-500 flex flex-col gap-4",
          ),
        ],
        [],
      ),
      nav(),
      html.main([attr.id("content"), class("grow bg-slate-900 p-8")], [content]),
    ]),
  ])
}
