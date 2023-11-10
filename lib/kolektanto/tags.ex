defmodule Kolektanto.Tags do
  @moduledoc """
  Implements behaviours for Items
  """

  alias Kolektanto.Tags.Tag
  alias Kolektanto.Tags.TagRepository

  @behaviour Kolektanto.Tags.Behaviour

  @impl true
  @spec save_all(list(String.t())) :: {:ok, list(Tag.t())}
  def save_all(names), do: {:ok, TagRepository.upsert_all(names)}
end
