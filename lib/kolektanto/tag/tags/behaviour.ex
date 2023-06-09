defmodule Kolektanto.Tag.Tags.Behaviour do
  @moduledoc """
  Behaviour for tags creation
  """
  alias Kolektanto.Tag

  @doc """
  Given a list of tag names persist them
  without duplicity
  """
  @callback upsert_all(list(String.t())) :: list(Tag.t())
end
