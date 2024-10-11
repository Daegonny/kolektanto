defmodule KolektantoWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule Item do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Item",
      description: "An Item of the app",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Item ID"},
        name: %Schema{type: :string, description: "Item name"},
        tags: %Schema{type: :array, description: "Item tags", items: %Schema{type: :string}},
        inserted_at: %Schema{type: :string, description: "Creation timestamp", format: :datetime},
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :datetime}
      },
      required: [:id, :name, :name, :tags, :inserted_at, :updated_at],
      example: %{
        "id" => "db970d8a-8364-42ed-9de4-232e7cac549a",
        "name" => "Yellow T-shirt",
        "tags" => ["yellow", "summer", "day"],
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule ItemResponse do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemResponse",
      description: "Response schema for single item",
      type: :object,
      properties: %{
        data: Item
      },
      example: %{
        "data" => %{
          "id" => "db970d8a-8364-42ed-9de4-232e7cac549a",
          "name" => "Yellow T-shirt",
          "tags" => ["yellow", "summer", "day"],
          "inserted_at" => "2017-09-12T12:34:55Z",
          "updated_at" => "2017-09-13T10:11:12Z"
        }
      }
    })
  end
end
