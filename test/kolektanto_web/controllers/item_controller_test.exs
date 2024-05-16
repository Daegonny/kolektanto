defmodule KolektantoWeb.ItemControllerTest do
  @moduledoc false
  use KolektantoWeb.ConnCase, async: true
  import Hammox

  describe "GET /items/:id" do
    test "returns 200 with item when it exists", %{conn: conn} do
      id = Faker.UUID.v4()
      name = Faker.Pokemon.name()
      tags = Enum.map(1..3, fn _ -> build(:tag) end)
      tag_names = Enum.map(tags, & &1.name)

      stub(ItemsMock, :fetch, fn _ ->
        {:ok, build(:item, id: id, name: name, tags: tags)}
      end)

      assert %{"data" => %{"id" => ^id, "name" => ^name, "tags" => ^tag_names}} =
               conn
               |> get(~p"/api/items/#{id}")
               |> json_response(200)
    end

    test "returns 404 when item does not exist", %{conn: conn} do
      id = Faker.UUID.v4()
      stub(ItemsMock, :fetch, fn _ -> {:error, :not_found} end)

      assert %{"errors" => [%{"message" => "Not Found"}]} =
               conn
               |> get(~p"/api/items/#{id}")
               |> json_response(404)
    end
  end
end
