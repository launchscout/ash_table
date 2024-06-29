# AshTable

This is a sortable, paginated table component for Ash resources or queries

## Status

- [X] Sort by attribute
- [X] Sort by relation (using function passed to column)
- [X] Pagination

## Usage

Here's an example taken from the test_bed:

```elixir
defmodule TestBedWeb.PostsLive.Index do
  use TestBedWeb, :live_view

  def render(assigns) do
    ~H"""
    <.live_component id="posts_table" limit={10} offset={0} sort={{"id", :asc}} module={AshTable.Table} query={TestBed.Blog.Post}>
      <:col :let={post} label="Id" sort_key="id"><%= post.id %></:col>
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
```

In this case the `TestBed.Blog.Post` resource has a title, content, and belongs to Author which has a name. The table is paginated, and sortable by Title and Author name. 

Note use of the `apply_sort` being passed into the `:col`. This is needed for sorting by related properties due to how Ash works, or til I better understand it and find a simpler way :) The `sort_key` assign is still required so that the correct column is identified when the sort event fires.

## Running the test_bed example project

```
cd test_bed
mix deps.get
mix ash.setup
mix phx.server
```

## Future

Currently there is very little styling. The goal would be to allow a good default, but great flexiblity. Harcoding a dependency on Tailwind or other css frameworks is not desirable, but allowing the user to decide to use one would be great.
