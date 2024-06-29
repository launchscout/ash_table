defmodule TestBed.EngagementsLive.IndexTest do
  use TestBedWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TestBed.Blog

  test "sort by title", %{conn: conn} do
    Blog.create_post!(%{title: "Posty"})
    Blog.create_post!(%{title: "Zazzle"})
    Blog.create_post!(%{title: "Bubble"})

    {:ok, view, html} = live(conn, ~p"/posts")

    view
    |> element(~s/th button[phx-value-column="title"]/)
    |> render_click()

    assert has_element?(view, ~s/table tr:first-child/, "Bubble")
  end

  # test "sort by client name", %{conn: conn} do
  #   client1 = Engagements.create_client!(%{name: "Poo"})
  #   client2 = Engagements.create_client!(%{name: "Yap"})
  #   client3 = Engagements.create_client!(%{name: "Bob"})

  #   Engagements.create_engagement!(%{client_id: client1.id, name: "Wut"})
  #   Engagements.create_engagement!(%{client_id: client2.id, name: "Wutter"})
  #   Engagements.create_engagement!(%{client_id: client3.id, name: "Wuttest"})

  #   {:ok, view, html} = live(conn, ~p"/engagements")

  #   view
  #   |> element(~s/th button[phx-value-column="client.name"]/)
  #   |> render_click()

  #   assert has_element?(view, ~s/table tr:first-child/, "Bob")
  # end

end
