defmodule Kolektanto.Tag do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tags" do
    field :name
    timestamps()
  end
end
