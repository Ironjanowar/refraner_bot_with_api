defmodule RefranerBot.MessageFormatter do
  alias RefranerBot.Model.Refran

  def format_refran(%Refran{} = refran) do
    refran_data =
      refran
      |> Map.from_struct()
      |> Enum.filter(fn
        {:refran, _} -> false
        {_, nil} -> false
        _ -> true
      end)
      |> Enum.map(fn {k, v} -> " - *#{format_key(k)}:* #{v}" end)
      |> Enum.join("\n")

    formatted_refran = """
    📜 _#{refran.refran}_ 📜
    #{refran_data}
    """

    {:ok, formatted_refran}
  end

  def format_refran(_) do
    {:error, "Can't format that..."}
  end

  def format_refran(%Refran{} = refran, :summary), do: {:ok, "📜 _#{refran.refran}_ 📜"}
  def format_refran(%Refran{} = refran, :full), do: format_refran(refran)

  def format_refran(_, _), do: {:error, "Can't format that..."}

  # Private
  defp from_atom(key) when is_atom(key), do: Atom.to_string(key)
  defp from_atom(key), do: key

  defp format_key(key) do
    key
    |> from_atom()
    |> String.capitalize()
    |> String.split("_")
    |> Enum.join(" ")
  end
end
