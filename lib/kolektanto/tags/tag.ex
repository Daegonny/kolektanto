defmodule Kolektanto.Tags.Tag do
  @moduledoc """
  Tag entity
  """
  use Ecto.Schema

  @type t() :: %__MODULE__{
          id: binary() | nil,
          name: String.t(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tags" do
    field :name
    timestamps(type: :utc_datetime_usec)
  end
end
