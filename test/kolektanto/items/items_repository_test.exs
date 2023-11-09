defmodule Kolektanto.Items.ItemsRepositoryTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true

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
      assert {:error, changeset} = ItemRepository.create(%{}, tags)

      refute changeset.valid?
      assert [name: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end

  describe "get/1" do
    test "returns item with its tags given an id" do
      item = insert(:item)
      assert {:ok, inserted_item} = ItemRepository.get(item.id)

      assert item == inserted_item
    end

    test "returns error tuple when item is not found" do
      non_existing_id = Faker.UUID.v4()
      assert {:error, :not_found} = ItemRepository.get(non_existing_id)
    end
  end

  # describe "filter_with_any_tags/1" do
  #   setup :setup_items_tags

  #   test "filters only items with any of the given tags", %{
  #     item_a_b: item_a_b,
  #     item_a: item_a,
  #     item_b_c: item_b_c
  #   } do
  #     {:ok, items} = Items.filter_with_any_tags(["a", "c"])

  #     assert Enum.count(items) == 3

  #     result_item_a_b = Enum.find(items, fn item -> item.id == item_a_b.id end)
  #     result_item_a = Enum.find(items, fn item -> item.id == item_a.id end)
  #     result_item_b_c = Enum.find(items, fn item -> item.id == item_b_c.id end)

  #     refute is_nil(result_item_a_b)
  #     refute is_nil(result_item_a)
  #     refute is_nil(result_item_b_c)

  #     assert Enum.count(result_item_a_b.tags) == 2
  #     assert Enum.count(result_item_a.tags) == 1
  #     assert Enum.count(result_item_b_c.tags) == 2
  #   end
  # end

  # describe "filter_with_all_tags/1" do
  #   setup :setup_items_tags

  #   test "filters only items with all of the given tags", %{
  #     item_a_b: item_a_b
  #   } do
  #     {:ok, items} = Items.filter_with_all_tags(["a", "b"])

  #     assert Enum.count(items) == 1
  #     result_item_a_b = Enum.find(items, fn item -> item.id == item_a_b.id end)
  #     refute is_nil(result_item_a_b)
  #     assert Enum.count(result_item_a_b.tags) == 2
  #   end
  # end

  # defp setup_items_tags(%{}) do
  #   tag_a = insert(:tag, name: "a")
  #   tag_b = insert(:tag, name: "b")
  #   tag_c = insert(:tag, name: "c")

  #   item_a_b = insert(:item, tags: [tag_a, tag_b])
  #   item_a = insert(:item, tags: [tag_a])
  #   item_b_c = insert(:item, tags: [tag_b, tag_c])
  #   insert(:item)

  #   %{
  #     tag_a: tag_a,
  #     tag_b: tag_b,
  #     tag_c: tag_c,
  #     item_a_b: item_a_b,
  #     item_a: item_a,
  #     item_b_c: item_b_c
  #   }
  # end
end
