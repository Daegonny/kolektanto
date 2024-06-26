defmodule Kolektanto.ItemsTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true
  import Hammox

  alias Kolektanto.Errors.FieldValidationError

  alias Kolektanto.Items.Item
  alias Kolektanto.Items
  alias Kolektanto.Repo.Pages.Page

  describe "fetch/1" do
    test "returns item when it exists" do
      %Item{id: id} = insert(:item)
      assert {:ok, %Item{id: ^id}} = Items.fetch(id)
    end

    test "returns error not found when item does not exist" do
      id = Faker.UUID.v4()
      assert {:error, :not_found} = Items.fetch(id)
    end
  end

  describe "list/1" do
    test "returns a page structure containing a list of possibly filtered items" do
      %Item{id: id} = insert(:item, name: "item_a")
      insert(:item, name: "item_b")

      assert %Page{
               entries: [%Item{id: ^id, name: "item_a"}],
               current_page: 1,
               page_size: 10,
               total_pages: 1
             } = Items.list(%{name: "item_a"})
    end
  end

  describe "save/2" do
    test "saves an item without tags" do
      name = "item 1"
      attrs = %{"name" => name}

      stub(TagsMock, :save_all, fn _ -> {:ok, []} end)

      assert {:ok, %Item{name: ^name, tags: []}} = Items.save(attrs)
    end

    test "saves an item with tags" do
      tag_names = ["red", "big"]
      tags = Enum.map(tag_names, &build(:tag, name: &1))

      stub(TagsMock, :save_all, fn ^tag_names -> {:ok, tags} end)

      name = "item 1"
      attrs = %{"name" => name}

      assert {:ok, %Item{name: ^name, tags: tags}} = Items.save(attrs, tag_names)

      returned_tag_names = Enum.map(tags, & &1.name) |> MapSet.new()
      tag_names_set = tag_names |> MapSet.new()
      assert MapSet.equal?(tag_names_set, returned_tag_names)
    end

    test "returns error when name is not given" do
      stub(TagsMock, :save_all, fn _ -> {:ok, []} end)

      assert {:error, :field_validation,
              [
                %FieldValidationError{
                  field: :name,
                  messages: ["can't be blank"]
                }
              ]} = Items.save(%{}, [])
    end
  end
end
