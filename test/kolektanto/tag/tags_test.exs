defmodule Kolektanto.Tag.TagsTest do
  @moduledoc false
  use Kolektanto.DataCase, async: true
  alias Kolektanto.Tag.Tags

  describe "uspert_all/1" do
    test "persists tags without duplicity and returns them" do
      names = ["red", "red", "blue", "big", "blue", "small"]
      unique_names = Enum.uniq(names)
      tags = Tags.upsert_all(names)

      assert Enum.count(tags) == Enum.count(unique_names)

      unique_names_set = MapSet.new(unique_names)
      tag_names_set = tags |> Enum.map(& &1.name) |> MapSet.new()

      assert MapSet.equal?(unique_names_set, tag_names_set)
    end

    test "returns empty list when a list of names is not received" do
      assert [] = Tags.upsert_all("red")
    end
  end
end
