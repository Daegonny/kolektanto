defmodule KolektantoWeb.FallbackController do
  @moduledoc false
  use KolektantoWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(KolektantoWeb.ErrorView)
    |> render(:"404")
  end
end
