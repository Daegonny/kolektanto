defmodule Kolektanto.Repo.Migrations.CreateItemsTagsTable do
  use Ecto.Migration

  def change do
    create table(:items_tags, primary_key: false) do
      add :item_id, references(:items, type: :binary_id)
      add :tag_id, references(:tags, type: :binary_id)
    end

    create index(:items_tags, [:item_id])
    create index(:items_tags, [:tag_id])
    create unique_index(:items_tags, [:item_id, :tag_id])
  end
end
