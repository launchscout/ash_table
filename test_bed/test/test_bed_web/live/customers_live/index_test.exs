defmodule TestBed.CustomersLive.IndexTest do
  use TestBedWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TestBed.Customers

  test "read options specifying tenant", %{conn: conn} do
    Customers.create_customer!(%{name: "Bobs Tires", tenant: "bob"})
    Customers.create_customer!(%{name: "Freds Tires", tenant: "fred"})

    {:ok, _view, html} = live(conn, ~p"/customers")

    assert html =~ "Bobs Tires"
    refute html =~ "Freds Tires"
  end
end
