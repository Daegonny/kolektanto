defmodule Kolektanto.Items do
  alias Kolektanto.Item
  alias Kolektanto.Repo
  alias Kolektanto.Tags

  def create(item) do
    tags = item[:tags] || item["tags"] || []

    %Item{}
    |> Item.changeset(item)
    |> Ecto.Changeset.put_assoc(:tags, Tags.upsert_all(tags))
    |> IO.inspect()
    |> Repo.insert()
    |> IO.inspect()
  end
end
