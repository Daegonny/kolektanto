defmodule Kolektanto.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kolektanto.Tag

  @type t() :: %__MODULE__{
          id: binary(),
          name: String.t(),
          tags: list(Tag.t()),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "items" do
    field :name
    many_to_many :tags, Tag, join_through: "items_tags", on_replace: :delete
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name])
    |> validate_required([:name])
  end
end
