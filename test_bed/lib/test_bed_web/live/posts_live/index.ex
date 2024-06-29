defmodule TestBedWeb.PostsLive.Index do
  use TestBedWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>hi</h1>
    <.live_component id="posts_table" sort={{"id", :asc}} module={AshTable.Table} query={TestBed.Blog.Post}>
      <:col :let={post} label="Id" sort_key="id"><%= post.id %></:col>
      <:col :let={post} label="Title" sort_key="title">
        <%= post.title %>
      </:col>
    </.live_component>
    """
  end
end
