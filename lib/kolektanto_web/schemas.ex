defmodule KolektantoWeb.Schemas do
  @moduledoc false

  alias OpenApiSpex.Schema

  defmodule Error do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Error",
      description: "Error",
      type: :object,
      properties: %{
        message: %Schema{type: :string, description: "error message description"}
      },
      example: %{
        "message" => "Not Found"
      }
    })
  end

  defmodule NotFoundResponse do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "NotFoundResponse",
      description: "Resource not found",
      type: :object,
      properties: %{
        errors: %Schema{type: :array, description: "errors", items: Error}
      },
      example: %{
        "errors" => [Schema.example(Error.schema())]
      }
    })
  end

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
        tags: %Schema{type: :array, description: "Item tags", items: %Schema{type: :string}}
      },
      required: [:id, :name, :tags],
      example: %{
        "id" => "db970d8a-8364-42ed-9de4-232e7cac549a",
        "name" => "Yellow T-shirt",
        "tags" => ["yellow", "summer", "day"]
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
        "data" => Schema.example(Item.schema())
      }
    })
  end

  defmodule ItemsPaginated do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemsPaginated",
      description: "Response schema for a paginated items list",
      type: :object,
      properties: %{
        entries: %Schema{type: :array, description: "Items", items: Item},
        current_page: %Schema{type: :integer, description: "Current page"},
        page_size: %Schema{type: :integer, description: "# Items per page"},
        total_pages: %Schema{type: :integer, description: "Total # of pages"}
      },
      example: %{
        "entries" => [
          Schema.example(Item.schema())
        ],
        "current_page" => 1,
        "page_size" => 10,
        "total_pages" => 1
      }
    })
  end

  defmodule ItemsResponse do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ItemsResponse",
      description: "Response schema for items list",
      type: :object,
      properties: %{
        data: ItemsPaginated
      },
      example: %{
        "data" => Schema.example(ItemsPaginated.schema())
      }
    })
  end
end
