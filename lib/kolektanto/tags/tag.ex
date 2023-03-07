defmodule Kolektanto.Tag do
  use Ecto.Schema

  @type t() :: %__MODULE__{
          id: binary(),
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tags" do
    field :name
    timestamps()
  end
end
