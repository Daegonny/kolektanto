defmodule Kolektanto.ItemsTest do
  use Kolektanto.DataCase, async: true
  alias Kolektanto.{Item, Items}

  describe "create/1" do
    test "creates an item" do
      params = %{name: name = "item 1", tags: tags = ["large", "green", "expansive"]}
      assert {:ok, %Item{} = item} = Items.create(params)

      assert item.name == name
      item_tag_names = Enum.map(item.tags, & &1.name)
      assert Enum.all?(tags, &(&1 in item_tag_names))
    end

    test "tags are created only once" do
      tags = ["large", "green", "expansive"]
      params_1 = %{name: "item 1", tags: tags}
      params_2 = %{name: "item 2", tags: tags}

      assert {:ok, %Item{} = item_1} = Items.create(params_1)
      assert {:ok, %Item{} = item_2} = Items.create(params_2)

      tags_1 = MapSet.new(item_1.tags)
      tags_2 = MapSet.new(item_2.tags)

      assert MapSet.equal?(tags_1, tags_2)
    end

    test "returns errors when name is not given" do
      assert {:error, changeset} = Items.create(%{})

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
