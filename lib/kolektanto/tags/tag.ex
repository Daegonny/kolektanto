defmodule Kolektanto.Tags.Tag do
  @moduledoc """
  Tag entity
  """
  use Ecto.Schema

  @type t() :: %__MODULE__{
          id: binary() | nil,
          name: String.t(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tags" do
    field :name
    timestamps()
  end
end
