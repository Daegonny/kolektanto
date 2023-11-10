defmodule Kolektanto.Repo do
  use Ecto.Repo,
    otp_app: :kolektanto,
    adapter: Ecto.Adapters.Postgres

  alias Kolektanto.Errors.FieldValidationError

  def normalize_result({:error, %Ecto.Changeset{} = changeset}),
    do: {:error, :field_validation, FieldValidationError.build_from(changeset)}

  def normalize_result(nil), do: {:error, :not_found}

  def normalize_result({:ok, result}), do: {:ok, result}

  def normalize_result(result), do: {:ok, result}
end
