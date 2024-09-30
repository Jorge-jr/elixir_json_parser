defmodule JsonParser do
  def parse(input) when hd(input) != :open_object and hd(input) != :open_list do
    {:error, "Bad syntax: missing open object or list"}
  end
  def parse(tokens) do
    case parse_value(tokens) do
      {result, []} -> {:ok, result}
      {:error, reason} -> {:error, reason}
      {_, remaining} -> {:error, detect_error(remaining)}
    end
  end

  defp detect_error(tokens) do
    case tokens do
      [{:error, reason} | _] -> reason
      _ -> "Unexpected tokens: #{inspect(tokens)}"
    end
  end

  defp parse_value([]) do
    {:error, "No input"}
  end

  defp parse_value([:open_object | rest]) do
    parse_object(rest, %{})
  end

  defp parse_value([:open_list | rest]) do
    parse_list(rest, [])
  end

  defp parse_value([{:string, value} | rest]) do
    {value, rest}
  end

  defp parse_value([{:number, {_, value}} | rest]) do
    {value, rest}
  end

  defp parse_value([{:number, value} | rest]) do
    {value, rest}
  end

  defp parse_value([{:boolean, value} | rest]) do
    {value, rest}
  end

  defp parse_value([{:null, value} | rest]) do
    {value, rest}
  end

  defp parse_value([unexpected | _]) do
    {:error, "Unexpected token: #{inspect(unexpected)}"}
  end

  defp parse_object([:close_object | rest], acc) do
    {acc, rest}
  end

  defp parse_object([{:string, key}, :colon | rest], acc) do
    case parse_value(rest) do
      {value, [:comma, :close_object | _]} ->
        {:error, "Bad syntax: trailing ','"}
      {value, [:comma | rest]} ->
        parse_object(rest, Map.put(acc, key, value))
      {value, [:close_object | rest]} ->
        {Map.put(acc, key, value), rest}
      {:error, reason} ->
        {:error, reason}
      {_, _} ->
        {:error, "Invalid object structure: expected ',' or '}' after value"}
      :error ->
        {:error, "Invalid value for key '#{key}': expected a valid JSON value after colon"}
    end
  end

  defp parse_object(tokens, _acc) do
    {:error, "Invalid object structure: expected string key followed by colon, got #{inspect(tokens)}"}
  end

  defp parse_list([:close_list | rest], acc) do
    {Enum.reverse(acc), rest}
  end

  defp parse_list(tokens, acc) do
    case parse_value(tokens) do
      {value, [:comma | rest]} ->
        parse_list(rest, [value | acc])
      {value, [:close_list | rest]} ->
        {Enum.reverse([value | acc]), rest}
      {:error, reason} ->
        {:error, reason}
      _ ->
        {:error, "Invalid list structure"}
    end
  end
end
