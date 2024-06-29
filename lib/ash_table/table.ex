defmodule AshTable.Table do
  use Phoenix.LiveComponent

  alias AshTable.TableHelpers

  @moduledoc """
    Generic sortable table component

    Expects the following parameters as assigns:

    * `id` - necessary, as this is a stateful LiveView component
    * `query` - An Ash Query or Resource module
    * `sort` (optional) - a `t:sort/0` specifying the initial sort direction
    * `col` columns
      * attribute - the field this column displays, used to sort
      * apply_sort - optional arity 2 function which takes query, direction as args
    * `caption` (optional)

  """

  @assigns [
    :id,
    :sort,
    :query,
    :col,
  ]

  @type sort :: {atom | nil, :asc | :desc}

  @impl true
  def mount(socket) do
    socket
    |> assign(
      sort: {nil, :asc}
    )
    |> then(&{:ok, &1})
  end

  @impl true
  def update(assigns, socket) do
    socket
    |> assign(Map.take(assigns, @assigns))
    |> assign(:query, assigns.query)
    |> load_rows()
    |> then(&{:ok, &1})
  end

  defp load_rows(%{assigns: %{query: query, sort: sort, col: columns}} = socket) do
    rows = query |> apply_sort(sort, columns) |> Ash.read!()
    assign(socket, :rows, rows)
  end

  defp apply_sort(query, {sort_key, direction}, columns) do
    col = columns |> Enum.find(&(&1[:sort_key] == sort_key))
    case col do
      %{sort_fn: sort_fn} when is_function(sort_fn) -> sort_fn.(query, direction)
      _ -> Ash.Query.sort(query, {String.to_existing_atom(sort_key), direction})
    end
  end

  @impl true
  def handle_event(
        "sort",
        %{"column" => column, "direction" => direction} = _params,
        socket
      ) do
    direction = String.to_existing_atom(direction)
    sort = {column, direction}

    socket
    |> assign(sort: sort)
    |> load_rows()
    |> then(&{:noreply, &1})
  end

  def sort_class(column_key, {sort_key, direction}) do
    if String.to_existing_atom(column_key) == sort_key do
      Atom.to_string(direction)
    else
      "none"
    end
  end

  def sort_direction(column_key, sort) when is_binary(column_key) do
    column_key
    |> String.to_existing_atom()
    |> sort_direction(sort)
  end

  def sort_direction(column_key, {column_key, direction}), do: toggle_direction(direction)
  def sort_direction(_, _), do: :asc

  def toggle_direction(:asc), do: :desc
  def toggle_direction(:desc), do: :asc

  def sort_normalized_keys(keys) do
    fn obj ->
      keys |> Enum.map(&(obj[&1] || "")) |> Enum.map(&String.downcase/1) |> List.to_tuple()
    end
  end

  def noreply(term) do
    {:noreply, term}
  end

  def ok(term) do
    {:ok, term}
  end
end
