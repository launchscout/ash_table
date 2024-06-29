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
    :offset,
    :limit
  ]

  @type sort :: {atom | nil, :asc | :desc}

  @impl true
  def mount(socket) do
    socket
    |> assign(sort: {nil, :asc})
    |> then(&{:ok, &1})
  end

  @impl true
  def update(assigns, socket) do
    socket
    |> assign(Map.take(assigns, @assigns))
    |> assign(:query, assigns.query)
    |> fetch_data()
    |> then(&{:ok, &1})
  end

  defp fetch_data(
         %{assigns: %{query: query, sort: sort, col: columns, limit: limit, offset: offset}} =
           socket
       ) do
    results =
      query |> apply_sort(sort, columns) |> Ash.read!(page: [limit: limit, offset: offset])

    assign(socket, :results, results)
  end

  defp rows_from(%Ash.Page.Offset{results: results}), do: results

  defp apply_sort(query, {sort_key, direction}, columns) do
    col = columns |> Enum.find(&(&1[:sort_key] == sort_key))

    case col do
      %{apply_sort: apply_sort} when is_function(apply_sort) -> apply_sort.(query, direction)
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
    |> fetch_data()
    |> then(&{:noreply, &1})
  end

  def handle_event("set_page", %{"offset" => offset}, socket) do
    socket
    |> assign(offset: String.to_integer(offset))
    |> fetch_data()
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
