defmodule Kolektanto.ItemsTest do
  use Kolektanto.DataCase, async: true
  alias Kolektanto.{Item, Items}
  alias Kolektanto.Repo

  describe "items/1" do
    test "creates an item" do
      params = %{name: name = "item 1", tags: tags = ["large", "green", "expansive"]}
      assert {:ok, %Item{} = item} = Items.create(params)
      item_with_tags = Repo.preload(item, :tags)

      assert item_with_tags.name == name
      item_tag_names = Enum.map(item_with_tags.tags, & &1.name)
      assert Enum.all?(tags, &(&1 in item_tag_names))
    end

    test "tags are created only once" do
      tags = ["large", "green", "expansive"]
      params_1 = %{name: "item 1", tags: tags}
      params_2 = %{name: "item 2", tags: tags}

      assert {:ok, %Item{} = item_1} = Items.create(params_1)
      item_1_with_tags = Repo.preload(item_1, :tags)

      assert {:ok, %Item{} = item_2} = Items.create(params_2)
      item_2_with_tags = Repo.preload(item_2, :tags)

      item_1_tags = MapSet.new(item_1.tags)
      item_2_tags = MapSet.new(item_2.tags)

      assert MapSet.equal?(item_1_tags, item_2_tags)
    end

    test "returns errors when name is not given" do
      assert {:error, changeset} = Items.create(%{})

      refute changeset.valid?
      assert [name: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end
end
