defmodule TestBed.BlogLive.IndexTest do
  use TestBedWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TestBed.Blog

  test "sort by title", %{conn: conn} do
    Blog.create_post!(%{title: "Posty"})
    Blog.create_post!(%{title: "Zazzle"})
    Blog.create_post!(%{title: "Bubble"})

    {:ok, view, _html} = live(conn, ~p"/posts")

    view
    |> element(~s/th button[phx-value-column="title"]/)
    |> render_click()

    assert has_element?(view, ~s/table tr:first-child/, "Bubble")
  end

  test "sort by author name", %{conn: conn} do
    author1 = Blog.create_author!(%{name: "Poo"})
    author2 = Blog.create_author!(%{name: "Yap"})
    author3 = Blog.create_author!(%{name: "Bob"})

    Blog.create_post!(%{author_id: author1.id, title: "Wut"})
    Blog.create_post!(%{author_id: author2.id, title: "Wutter"})
    Blog.create_post!(%{author_id: author3.id, title: "Wuttest"})

    {:ok, view, _html} = live(conn, ~p"/posts")

    view
    |> element(~s/th button[phx-value-column="author.name"]/)
    |> render_click()

    assert has_element?(view, ~s/table tr:first-child/, "Bob")
  end

  test "pagination", %{conn: conn} do
    for i <- 0..20 do
      Blog.create_post!(%{title: "Post #{i}"})
    end

    {:ok, view, html} = live(conn, ~p"/posts")

    assert html =~ "1 to 10"

    view
    |> element(~s/[phx-click="set_page"]/)
    |> render_click() =~ "11 to 20"
  end
end
