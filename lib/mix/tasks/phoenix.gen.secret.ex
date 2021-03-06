defmodule Mix.Tasks.Phoenix.Gen.Secret do
  use Mix.Task

  @shortdoc "Generates a secret"

  @moduledoc """
  Generates a secret and print it to the terminal.

      mix phoenix.gen.secret [length]

  By default, mix phoenix.gen.secret generates a key 64 characters long.

  The minimum value for `length` is 32.
  """
  def run([]),    do: run(["64"])
  def run([int]), do: int |> parse! |> random_string |> Mix.shell.info
  def run([_|_]), do: invalid_args!

  defp parse!(int) do
    case Integer.parse(int) do
      {int, ""} -> int
      _ -> invalid_args!
    end
  end

  defp random_string(length) when length > 31 do
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end
  defp random_string(_), do: Mix.raise "The secret should be at least 32 characters long"

  defp invalid_args! do
    Mix.raise "mix phoenix.gen.secret expects a length as integer or no argument at all"
  end
end
