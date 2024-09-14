defmodule JsonLexer do
  def tokenize_all(string) do
    string
    |> String.split(",")
    |> Enum.map(fn x -> tokenize(x) end)
  end

  def tokenize(input) do
    ~r/\s+(?=([^"]*"[^"]*")*[^"]*$)/
    |>Regex.replace(input, "")  # regex to remove all the spaces, except with those between quotes
    |> to_charlist()
    |> do_tokenize()
  end

  defp do_tokenize([]), do: []
  defp do_tokenize([head | tail]) when head in '\t\n\r', do: do_tokenize(tail)
  defp do_tokenize([head | tail]) when head == ?{ do
    [:open_object | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]) when head == ?} do
    [:close_object | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]) when head == ?" do
    [:string | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]) when head == ?[ do
    [:open_list | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]) when head == ?] do
    [:close_list | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]) when head == ?: do
    [:semicolon | do_tokenize(tail)]
  end

  defp do_tokenize([head | tail]), do: [head | do_tokenize(tail)]
end
