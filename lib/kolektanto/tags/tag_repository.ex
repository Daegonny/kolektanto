defmodule Kolektanto.Tags.TagRepository do
  @moduledoc """
  Data access operations for Tag
  """

  alias Kolektanto.Repo
  alias Kolektanto.Tags.Tag

  import Ecto.Query

  @spec upsert_all(list(String.t())) :: {:ok, list(Tag.t())}
  def upsert_all([]), do: {:ok, []}

  def upsert_all(names) when is_list(names) do
    placeholders = get_placeholders()

    Repo.insert_all(
      Tag,
      map_tags(names),
      placeholders: placeholders,
      on_conflict: :nothing
    )

    Repo.all(from t in Tag, where: t.name in ^names)
    |> Repo.normalize_result()
  end

  def upsert_all(_), do: {:ok, []}

  defp map_tags(names) do
    Enum.map(
      names,
      &%{
        name: &1,
        inserted_at: {:placeholder, :timestamp},
        updated_at: {:placeholder, :timestamp}
      }
    )
  end

  defp get_placeholders() do
    %{timestamp: DateTime.utc_now()}
  end
end
