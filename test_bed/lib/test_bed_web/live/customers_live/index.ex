defmodule TestBedWeb.CustomersLive.Index do
  use TestBedWeb, :live_view

  def render(assigns) do
    ~H"""
    <.live_component id="customers_table" read_options={[tenant: "bob"]} limit={10} offset={0} sort={{"id", :asc}} module={AshTable.Table} query={TestBed.Customers.Customer}>
      <:col :let={customer} label="Id"><%= customer.id %></:col>
      <:col :let={customer} label="Name" sort_key="name">
        <%= customer.name %>
      </:col>
    </.live_component>
    """
  end
end
