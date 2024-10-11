defmodule KolektantoWeb.ItemControllerTest do
  @moduledoc false
  use KolektantoWeb.ConnCase, async: true
  import Hammox
  import OpenApiSpex.TestAssertions

  describe "(show) GET /items/:id" do
    test "returns 200 with item when it exists", %{conn: conn} do
      id = Ecto.UUID.generate()

      stub(ItemsMock, :fetch, fn _ ->
        {:ok, build(:item, id: id)}
      end)

      conn
      |> get(~p"/api/items/#{id}")
      |> json_response(200)
      |> assert_schema("ItemResponse", KolektantoWeb.ApiSpec.spec())
    end

    test "returns 404 when item does not exist", %{conn: conn} do
      id = Faker.UUID.v4()
      stub(ItemsMock, :fetch, fn _ -> {:error, :not_found} end)

      conn
      |> get(~p"/api/items/#{id}")
      |> json_response(404)
      |> assert_schema("NotFoundResponse", KolektantoWeb.ApiSpec.spec())
    end
  end

  describe "(index) GET /items" do
    test "returns 200 with paginated and filtered items", %{conn: conn} do
      stub(ItemsMock, :list, fn opts ->
        assert %{
                 page: 1,
                 page_size: 10,
                 name: "name",
                 having_one_of_tags: ["red", "blue"],
                 having_all_tags: ["summer", "spring"]
               } = opts

        build(:page, entries: [build(:item, id: Ecto.UUID.generate())])
      end)

      conn
      |> get(
        ~p"/api/items?page=1&page_size=10&name=name&having_one_of_tags[]=red&" <>
          "having_one_of_tags[]=blue&having_all_tags[]=summer&having_all_tags[]=spring"
      )
      |> json_response(200)
      |> assert_schema("ItemsResponse", KolektantoWeb.ApiSpec.spec())
    end

    test "returns 422 when query contains invalid field name", %{conn: conn} do
      assert %{
               "errors" => [
                 %{
                   "message" => "Unexpected field: non_existing",
                   "source" => %{"pointer" => "/non_existing"},
                   "title" => "Invalid value"
                 }
               ]
             } =
               conn
               |> get(~p"/api/items?non_existing=true")
               |> json_response(422)
    end

    test "returns 422 when query contains invalid field value", %{conn: conn} do
      assert %{
               "errors" => [
                 %{
                   "message" => "Invalid integer. Got: string",
                   "source" => %{"pointer" => "/page"},
                   "title" => "Invalid value"
                 }
               ]
             } =
               conn
               |> get(~p"/api/items?page=true")
               |> json_response(422)
    end
  end
end
