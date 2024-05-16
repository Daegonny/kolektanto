defmodule KolektantoWeb.ItemController do
  @moduledoc false

  use KolektantoWeb, :controller

  action_fallback KolektantoWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, item} <- items().fetch(id) do
      render(conn, "show.json", item: item)
    end
  end

  defp items, do: Application.get_env(:kolektanto, :items)
end
