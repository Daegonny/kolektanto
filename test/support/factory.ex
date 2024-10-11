defmodule Kolektanto.Factory do
  @moduledoc """
  Factories for application entities
  """
  use ExMachina.Ecto, repo: Kolektanto.Repo
  alias Faker.{Pokemon, Vehicle}
  alias Kolektanto.Items.Item
  alias Kolektanto.Repo.Pages.Page
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

  def page_factory do
    %Page{
      entries: [],
      current_page: 1,
      page_size: 10,
      total_pages: 1
    }
  end
end
