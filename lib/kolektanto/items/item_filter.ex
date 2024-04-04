defmodule Kolektanto.Items.ItemFilter do
  @moduledoc """
    Attributes for filtering items
  """

  defstruct name: nil, tags_must_have_one: [], tags_must_have_all: []
end
