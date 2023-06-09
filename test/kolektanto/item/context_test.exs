defmodule Kolektanto.Item.ContextTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Mox

  alias Kolektanto.Error.FieldValidationError
  import Kolektanto.Factory
  alias Kolektanto.Item
  alias Kolektanto.Item.Context

  describe "get/1" do
    test "returns item when it exists" do
      id = Faker.UUID.v4()
      stub(ItemsMock, :get, fn _ -> {:ok, build(:item, id: id)} end)
      assert {:ok, %Item{id: ^id}} = Context.get(id)
    end

    test "returns error not found when item does not exist" do
      id = Faker.UUID.v4()
      stub(ItemsMock, :get, fn _ -> {:error, :not_found} end)
      assert {:error, :not_found} = Context.get(id)
    end
  end

  describe "create/2" do
    test "creates item without tags" do
      name = "item 1"
      params = %{"name" => name}

      stub(TagsMock, :upsert_all, fn _ -> [] end)

      stub(ItemsMock, :create, fn ^params, _ ->
        {:ok, build(:item, name: name, tags: [])}
      end)

      assert {:ok, %Item{name: ^name, tags: []}} = Context.create(params)
    end

    test "creates item with tags" do
      tag_names = ["red", "big"]
      tags = Enum.map(tag_names, &build(:tag, name: &1))

      stub(TagsMock, :upsert_all, fn ^tag_names -> tags end)

      name = "item 1"
      params = %{"name" => name}

      stub(ItemsMock, :create, fn ^params, ^tags ->
        {:ok, build(:item, name: name, tags: tags)}
      end)

      assert {:ok, %Item{name: ^name, tags: tags}} = Context.create(params, tag_names)
      returned_tag_names = Enum.map(tags, & &1.name) |> MapSet.new()
      tag_names_set = tag_names |> MapSet.new()
      assert MapSet.equal?(tag_names_set, returned_tag_names)
    end

    test "returns error when name is not given" do
      stub(TagsMock, :upsert_all, fn _ -> [] end)

      stub(ItemsMock, :create, fn _, _ ->
        changeset = Ecto.Changeset.add_error(%Ecto.Changeset{}, :name, "can't be blank")
        {:error, changeset}
      end)

      assert {:error, :field_validation,
              [
                %FieldValidationError{
                  field: :name,
                  messages: ["can't be blank"]
                }
              ]} = Context.create(%{}, [])
    end
  end
end
