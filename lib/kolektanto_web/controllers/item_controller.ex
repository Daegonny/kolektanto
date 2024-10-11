defmodule KolektantoWeb.ItemController do
  @moduledoc false

  use KolektantoWeb, :controller

  alias OpenApiSpex.Operation
  alias KolektantoWeb.Schemas

  action_fallback KolektantoWeb.FallbackController

  @spec open_api_operation(any) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
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
        200 => Operation.response("Item", "application/json", Schemas.ItemResponse)
      }
    }
  end

  def show(conn, %{"id" => id}) do
    with {:ok, item} <- items().fetch(id) do
      render(conn, "show.json", item: item)
    end
  end

  defp items, do: Application.get_env(:kolektanto, :items)
end
