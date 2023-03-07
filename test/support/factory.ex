defmodule Kolektanto.Factory do
  use ExMachina.Ecto, repo: Kolektanto.Repo
  alias Faker.{Pokemon, Vehicle}
  alias Kolektanto.{Item, Tag}

  def item_factory do
    tags_quantity = Enum.random(1..10)

    %Item{
      name: Vehicle.model(),
      tags: Enum.map(1..tags_quantity, fn _ -> build(:tag) end)
    }
  end

  def tag_factory do
    %Tag{
      name: Pokemon.En.name()
    }
  end
end
