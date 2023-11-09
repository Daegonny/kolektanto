defmodule Kolektanto.Tags.Behaviour do
  @moduledoc """
  Behaviours for Tags
  """
  alias Kolektanto.Tags.Tag

  @doc """
  Given a list of tag names persist them
  without duplicity
  """
  @callback save_all(list(String.t())) :: list(Tag.t())
end
