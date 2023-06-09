defmodule Kolektanto.Error.FieldValidationError do
  @moduledoc """
  Holds a field validation error and its messages
  """
  defstruct [:field, :messages]

  @type t :: %__MODULE__{
          field: atom(),
          messages: list(String.t())
        }

  @doc """
  Build a list of FieldValidationError from %Ecto.Chanset{}
  """
  @spec build_from(Ecto.Changeset.t()) :: list(__MODULE__.t())
  def build_from(changeset) do
    errors = changeset.errors

    errors
    |> Enum.group_by(
      fn {field, _error} ->
        field
      end,
      fn {_field, error} ->
        error
      end
    )
    |> Enum.map(&build/1)
  end

  defp build({field, errors}) do
    %__MODULE__{field: field, messages: Enum.map(errors, &translate_error/1)}
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
