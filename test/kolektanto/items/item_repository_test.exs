defmodule Kolektanto.Items.ItemRepositoryTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true

  alias Kolektanto.Errors.FieldValidationError
  alias Kolektanto.Items.Item
  alias Kolektanto.Items.ItemRepository

  describe "create/2" do
    test "creates an item" do
      tags = insert_list(3, :tag)
      params = %{name: name = "item 1"}
      assert {:ok, %Item{} = item} = ItemRepository.create(params, tags)

      assert item.name == name
      item_tag_names = Enum.map(item.tags, & &1.name)
      tag_names = Enum.map(tags, & &1.name)
      assert Enum.all?(tag_names, &(&1 in item_tag_names))
    end

    test "returns errors when name is not given" do
      tags = insert_list(3, :tag)

      assert {:error, :field_validation,
              [
                %FieldValidationError{
                  field: :name,
                  messages: ["can't be blank"]
                }
              ]} = ItemRepository.create(%{}, tags)
    end
  end

  describe "fetch/1" do
    test "returns item with its tags given an id" do
      item = insert(:item)
      assert {:ok, inserted_item} = ItemRepository.fetch(item.id)

      assert item == inserted_item
    end

    test "returns error tuple when item is not found" do
      non_existing_id = Faker.UUID.v4()
      assert {:error, :not_found} = ItemRepository.fetch(non_existing_id)
    end
  end

  describe "list/1" do
    setup :setup_items_tags

    test "filters only items with one of the given tags",
         %{item_a: item_a, item_b: item_b, item_d: item_d} do
      opts = %{
        having_one_of_tags: ["red", "blue"]
      }

      assert %{entries: items} = ItemRepository.list(opts)

      assert Enum.count(items) == 3
      assert Enum.find(items, &(&1.name == item_a.name))
      assert Enum.find(items, &(&1.name == item_b.name))
      assert Enum.find(items, &(&1.name == item_d.name))
    end

    test "filters only items with all of the given tags",
         %{item_a: item_a, item_b: item_b, item_c: item_c} do
      opts = %{
        having_all_tags: ["summer", "day"]
      }

      assert %{entries: items} = ItemRepository.list(opts)
      assert Enum.count(items) == 3
      assert Enum.find(items, &(&1.name == item_a.name))
      assert Enum.find(items, &(&1.name == item_b.name))
      assert Enum.find(items, &(&1.name == item_c.name))
    end

    test "filters all items tagged as summer, day and (red or blue)",
         %{item_a: item_a, item_b: item_b} do
      opts = %{
        having_one_of_tags: ["red", "blue"],
        having_all_tags: ["summer", "day"]
      }

      assert %{entries: items} = ItemRepository.list(opts)

      assert Enum.count(items) == 2
      assert Enum.find(items, &(&1.name == item_a.name))
      assert Enum.find(items, &(&1.name == item_b.name))
    end

    test "items are sorted by inserted_at desc" do
      assert %{
               entries: [
                 %{name: "d"},
                 %{name: "c"},
                 %{name: "b"},
                 %{name: "a"}
               ]
             } = ItemRepository.list()
    end
  end

  defp setup_items_tags(%{}) do
    summer = insert(:tag, name: "summer")
    _fall = insert(:tag, name: "fall")
    _winter = insert(:tag, name: "winter")

    red = insert(:tag, name: "red")
    blue = insert(:tag, name: "blue")
    purple = insert(:tag, name: "purple")

    day = insert(:tag, name: "day")
    night = insert(:tag, name: "night")

    item_a = insert(:item, name: "a", tags: [summer, red, day])
    item_b = insert(:item, name: "b", tags: [summer, blue, day])
    item_c = insert(:item, name: "c", tags: [summer, purple, day])
    item_d = insert(:item, name: "d", tags: [summer, red, night])

    %{item_a: item_a, item_b: item_b, item_c: item_c, item_d: item_d}
  end
end
