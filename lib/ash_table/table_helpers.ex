defmodule AshTable.TableHelpers do
  @moduledoc false
  use Phoenix.Component

  def column_header(assigns) do
    ~H"""
    <th
      scope="col"
      role="columnheader"
      aria-sort={sort_class(@column, @sort)}
      width={if @column[:min], do: "1px"}
      class={if @column[:header_class], do: @column[:header_class]}
    >
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  def sort_button(assigns) do
    ~H"""
    <button
      phx-click="sort"
      phx-target={@target}
      phx-value-column={@column.sort_key}
      phx-value-direction={sort_direction(@column, @sort)}
      class={sort_class(@column, @sort)}
    >
      <%= @column.label %>
    </button>
    """
  end

  defp sort_direction(column, sort) do
    with %{sort_key: column_key} when is_binary(column_key) <- column,
         {^column_key, direction} <- sort do
      toggle_direction(direction)
    else
      _ -> :asc
    end
  end

  defp toggle_direction(:asc), do: :desc
  defp toggle_direction(:desc), do: :asc

  defp sort_class(column, sort) do
    with %{sort_key: column_key} when is_binary(column_key) <- column,
         {^column_key, direction} <- sort do
      Atom.to_string(direction)
    else
      _ -> "none"
    end
  end
end
