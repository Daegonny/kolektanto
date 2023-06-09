defmodule KolektantoWeb.ItemController do
  @moduledoc false

  use KolektantoWeb, :controller

  action_fallback KolektantoWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, item} <- context().get(id) do
      render(conn, "show.json", item: item)
    end
  end

  defp context, do: Application.get_env(:kolektanto, :item_context)
end
