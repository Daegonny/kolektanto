defmodule Kolektanto.Items.Item do
  @moduledoc """
  Item entity
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kolektanto.Tags.Tag

  @type t() :: %__MODULE__{
          id: binary() | nil,
          name: String.t(),
          tags: list(Tag.t()) | Ecto.Association.NotLoaded.t(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "items" do
    field :name
    many_to_many :tags, Tag, join_through: "items_tags", on_replace: :delete
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name])
    |> validate_required([:name])
  end
end
