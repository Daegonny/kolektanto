defmodule Kolektanto.TagsTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true
  alias Kolektanto.Tags

  describe "save_all/1" do
    test "persists tags without duplicity and returns them" do
      names = ["red", "red", "blue", "big", "blue", "small"]
      unique_names = Enum.uniq(names)
      tags = Tags.save_all(names)

      assert Enum.count(tags) == Enum.count(unique_names)

      unique_names_set = MapSet.new(unique_names)
      tag_names_set = tags |> Enum.map(& &1.name) |> MapSet.new()

      assert MapSet.equal?(unique_names_set, tag_names_set)
    end

    test "tags are created only once" do
      tag_names = ["large", "green", "expansive"]

      tags_1 = Tags.save_all(tag_names) |> MapSet.new()
      tags_2 = Tags.save_all(tag_names) |> MapSet.new()

      assert MapSet.equal?(tags_1, tags_2)
    end

    test "returns empty list when a list of names is not received" do
      assert [] = Tags.save_all("red")
    end
  end
end
