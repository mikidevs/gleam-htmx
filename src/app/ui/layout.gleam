import app/ui/hx
import nakai/attr.{class}
import nakai/html.{type Node, a_text}

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

pub fn empty() -> Node {
  with_content(
    html.main([attr.id("content"), class("grow bg-slate-900 p-8")], []),
  )
}

pub fn with_content(content: Node) -> Node {
  html.Html([attr.lang("en-US")], [
    head(),
    html.Body([class("flex")], [
      nav(),
      html.main([attr.id("content"), class("grow bg-slate-900 p-8")], [content]),
    ]),
  ])
}
