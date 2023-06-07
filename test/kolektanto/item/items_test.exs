defmodule Kolektanto.Item.ItemsTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true
  alias Kolektanto.Item
  alias Kolektanto.Item.Items

  describe "create/1" do
    test "creates an item" do
      params = %{name: name = "item 1"}
      assert {:ok, %Item{} = item} = Items.create(params)

      assert item.name == name
    end

    test "returns errors when name is not given" do
      assert {:error, changeset} = Items.create(%{})

      refute changeset.valid?
      assert [name: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end

  describe "create/2" do
    test "creates an item" do
      tags = insert_list(3, :tag)
      params = %{name: name = "item 1"}
      assert {:ok, %Item{} = item} = Items.create(params, tags)

      assert item.name == name
      item_tag_names = Enum.map(item.tags, & &1.name)
      tag_names = Enum.map(tags, & &1.name)
      assert Enum.all?(tag_names, &(&1 in item_tag_names))
    end

    test "returns errors when name is not given" do
      tags = insert_list(3, :tag)
      assert {:error, changeset} = Items.create(%{}, tags)

      refute changeset.valid?
      assert [name: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end

  describe "get/1" do
    test "returns item with its tags given an id" do
      item = insert(:item)
      assert {:ok, inserted_item} = Items.get(item.id)

      assert item == inserted_item
    end

    test "returns error tuple when item is not found" do
      non_existing_id = Faker.UUID.v4()
      assert {:error, :not_found} = Items.get(non_existing_id)
    end
  end
end
