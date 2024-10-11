defmodule KolektantoWeb.ItemController do
  @moduledoc false

  use KolektantoWeb, :controller

  alias OpenApiSpex.Operation
  alias OpenApiSpex.Schema
  alias KolektantoWeb.Schemas

  plug OpenApiSpex.Plug.CastAndValidate

  action_fallback KolektantoWeb.FallbackController

  @spec open_api_operation(any) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation() do
    %Operation{
      tags: ["items"],
      summary: "List items",
      description: "filtered and paginated",
      operationId: "ItemController.Index",
      parameters: [
        Operation.parameter(:name, :query, :string, "Filter items containing this name"),
        Operation.parameter(:page, :query, :integer, "Select page to return"),
        Operation.parameter(:page_size, :query, :integer, "Set number of items per page"),
        Operation.parameter(
          :having_one_of_tags,
          :query,
          %Schema{type: :array, items: %Schema{type: :string}},
          "Filter items containing at least one of the given tags",
          style: :form,
          explode: true
        ),
        Operation.parameter(
          :having_all_tags,
          :query,
          %Schema{type: :array, items: %Schema{type: :string}},
          "Filter items containing all of the given tags",
          style: :form,
          explode: true
        )
      ],
      responses: %{
        200 => Operation.response("Items", "application/json", Schemas.ItemsResponse),
        422 => OpenApiSpex.JsonErrorResponse.response()
      }
    }
  end

  def index(conn, opts) do
    items_paginated = items().list(opts)
    render(conn, "index.json", items_paginated: items_paginated)
  end

  @spec show_operation() :: Operation.t()
  def show_operation() do
    %Operation{
      tags: ["items"],
      summary: "Show item",
      description: "Show an item by ID",
      operationId: "ItemController.show",
      parameters: [
        Operation.parameter(:id, :path, :string, "Item ID",
          example: "4c374ba9-d7ef-4c4d-8d5c-73308c5d748b"
        )
      ],
      responses: %{
        200 => Operation.response("Item", "application/json", Schemas.ItemResponse),
        404 => Operation.response("NotFound", "application/json", Schemas.NotFoundResponse)
      }
    }
  end

  def show(conn, %{id: id}) do
    with {:ok, item} <- items().fetch(id) do
      render(conn, "show.json", item: item)
    end
  end

  defp items, do: Application.get_env(:kolektanto, :items)
end
