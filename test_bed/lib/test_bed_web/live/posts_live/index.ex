defmodule TestBedWeb.PostsLive.Index do
  use TestBedWeb, :live_view

  def render(assigns) do
    ~H"""
    <.live_component id="posts_table" limit={10} offset={0} sort={{"id", :asc}} module={AshTable.Table} query={TestBed.Blog.Post}>
      <:col :let={post} label="Id"><%= post.id %></:col>
      <:col :let={post} label="Title" sort_key="title">
        <%= post.title %>
      </:col>
      <:col :let={post} label="Author" apply_sort={&sort_by_author/2} sort_key="author.name">
        <%= if post.author, do: post.author.name %>
      </:col>
    </.live_component>
    """
  end

  require Ash.Sort

  defp sort_by_author(query, direction) do
    Ash.Query.sort(query, {Ash.Sort.expr_sort(author.name), direction})
  end

end
