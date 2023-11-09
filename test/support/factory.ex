defmodule Kolektanto.Factory do
  @moduledoc """
  Factories for application entities
  """
  use ExMachina.Ecto, repo: Kolektanto.Repo
  alias Faker.{Pokemon, Vehicle}
  alias Kolektanto.Items.Item
  alias Kolektanto.Tags.Tag

  def item_factory do
    %Item{
      name: Vehicle.model(),
      tags: Enum.map(1..2, fn _ -> build(:tag) end)
    }
  end

  def tag_factory do
    %Tag{
      name: Pokemon.En.name()
    }
  end
end
