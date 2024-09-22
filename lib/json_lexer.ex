defmodule JsonLexer do
  def tokenize(input) do
    input
    |> String.to_charlist()
    |> do_tokenize([])
    |> Enum.reverse()
  end


  defp do_tokenize([], acc), do: acc

  defp do_tokenize([?{ | rest], acc), do: do_tokenize(rest, [:open_object | acc])
  defp do_tokenize([?} | rest], acc), do: do_tokenize(rest, [:close_object | acc])
  defp do_tokenize([?[ | rest], acc), do: do_tokenize(rest, [:open_list | acc])
  defp do_tokenize([?] | rest], acc), do: do_tokenize(rest, [:close_list | acc])
  defp do_tokenize([?: | rest], acc), do: do_tokenize(rest, [:colon | acc])
  defp do_tokenize([?, | rest], acc), do: do_tokenize(rest, [:comma | acc])
  defp do_tokenize([?" | rest], acc) do
    {string, remaining} = tokenize_string(rest)
    do_tokenize(remaining, [{:string, string} | acc])
  end

  defp do_tokenize([char | rest], acc) when char in [?\s, ?\n, ?\r, ?\t] do
    do_tokenize(rest, acc)
  end

  defp do_tokenize(chars, acc) do
    cond do
      match?([?t, ?r, ?u, ?e | _], chars) ->
        do_tokenize(Enum.drop(chars, 4), [{:boolean, true} | acc])
      match?([?f, ?a, ?l, ?s, ?e | _], chars) ->
        do_tokenize(Enum.drop(chars, 5), [{:boolean, false} | acc])
      match?([?n, ?u, ?l, ?l | _], chars) ->
        do_tokenize(Enum.drop(chars, 4), [{:null, nil} | acc])
      match?([?' | _], chars) ->
        [?']
      true ->
        {number, rest} = tokenize_number(chars)
        do_tokenize(rest, [{:number, number} | acc])
    end
  end

  defp tokenize_string(chars, acc \\ [])
  defp tokenize_string([?" | rest], acc), do: {to_string(Enum.reverse(acc)), rest}
  defp tokenize_string([?\\ | [?", ?\\ | rest]], acc), do: tokenize_string(rest, [?", ?\\ | acc])
  defp tokenize_string([char | rest], acc), do: tokenize_string(rest, [char | acc])

  defp tokenize_number(chars, acc \\ [])

  defp tokenize_number([char | rest], acc) when char in ~c'0123456789.-+eE' do
    tokenize_number(rest, [char | acc])
  end

  defp tokenize_number(rest, acc) do
    number_string = List.to_string(Enum.reverse(acc))
    if acc == [] do
      {rest, []}
    else
      {number, ""} = case String.contains?(number_string, [".", "e", "E"]) do
        true -> Float.parse(number_string)
        false -> Integer.parse(number_string)
      end
      token = case number do
        int when is_integer(int) -> {:integer, int}
        float when is_float(float) -> {:float, float}
      end
      {token, rest}

    end
  end

end
