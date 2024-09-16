  defmodule JsonParser do

    def parse_object([[]]), do: {:error, "Not an object"}
    def parse_object([[:open_object, :close_object]]), do: %{}
    def parse_object(object_list) do
      parsed_entries =
        object_list
        |> Enum.map(&parse_entry/1)
        |> Enum.reduce_while(%{}, fn
          {:error, message}, _ -> {:halt, {:error, message}}
          {{:error, message}, _}, _ -> {:halt, {:error, message}}
          {_, {:error, message}}, _ -> {:halt, {:error, message}}
          {key, value}, acc -> {:cont, Map.put(acc, key, value)}
        end)

      case parsed_entries do
        {:error, _} = error -> error
        map_result -> map_result
      end
    end

    def parse_entry([:close_object]), do: {:error, "Bad syntax: trailling ','"}
    def parse_entry(entry) do
      case Enum.find_index(entry, &(&1 == :semicolon)) do
        nil -> {:error, "3"}
        semicolon_index ->
          key_list = Enum.slice(entry, 0, semicolon_index)
          value_list = Enum.slice(entry, semicolon_index + 1, length(entry))
          parse_key_value(key_list, value_list)
      end
    end

    defp parse_key_value(_, {:error, "Bad syntax"}), do: {:error, "Bad syntax"}
    defp parse_key_value({:error, "Bad syntax"}, _), do: {:error, "Bad syntax"}
    defp parse_key_value(key_list, value_list) do
      {parse_string(key_list), parse_value(value_list)}
    end

    defp parse_value(value), do: parse_value(value, get_type(value))
    defp parse_value([:open_object, :close_object], _), do: %{}
    defp parse_value(value, :object), do: parse_object([value])
    defp parse_value(_, {:error, "Bad syntax"}), do: {:error, "Bad syntax"}
    defp parse_value(value_list, :string), do: parse_string(value_list)
    defp parse_value(value_list, :list), do: parse_list(value_list)
    defp parse_value(_, :true), do: true
    defp parse_value(_, :false), do: false
    defp parse_value(_, :null), do: nil
    defp parse_value(value, :integer) do
      value
      |> List.delete(:close_object)
      |> Enum.filter(fn x -> x != ?\s end)
      |> List.to_integer()
    end

    defp get_type(value) do
      cond do
        is_valid_integer?(value) -> :integer
        hd(value) == :string -> :string
        hd(value) == :open_list -> :list
        hd(value) == :open_object -> :object
        value == ~c"true" -> :true
        value == ~c"false" -> :false
        value == ~c"null" -> :null
        true -> {:error, "Bad syntax"} # -> here!!!
      end
    end

    defp is_valid_integer?(int) do
      non_integer_chars = int
                          |> List.delete(:close_object)
                          |> Enum.filter(fn x -> x not in [?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9] end)
      non_integer_chars == []
    end

    defp parse_string([head|tail]) when head == :open_object, do: parse_string(tail)
    defp parse_string(string) when hd(string) != :string, do: {:error, "Missing opening \""}
    defp parse_string(string), do: parse_string(string, [])
    defp parse_string([:string], result), do: to_string(result)
    defp parse_string([:string | [:close_object | _]], result), do: to_string(result)
    defp parse_string([:string | tail], []), do: parse_string(tail, [])
    defp parse_string([head | tail], result), do: parse_string(tail, result ++ [head])

    defp parse_list(list), do: parse_list(list, [])
    defp parse_list([:open_list| tail], _) when hd(tail) == ?', do: {:error, "Bad syntax"}
    defp parse_list([:close_list|_], result), do: result

    defp parse_list([:open_list | tail], result) when result != [] do  # possibly nested list
      nested_list_end = tail
                        |> Enum.with_index()
                        |> Enum.find(fn {x,_} -> x == :close_list end)
                        |> elem(1)

      nested_list = Enum.slice(tail, 0 .. nested_list_end - 1)
      rest = Enum.slice(tail, (nested_list_end + 1) .. length(tail))
      parse_list(rest, result ++ nested_list)
    end

    defp parse_list([:open_list | tail], []), do: parse_list(tail, [])

    defp parse_list([:string | tail], result) do
      string_end = tail
                        |> Enum.with_index()
                        |> Enum.find(fn {x,_} -> x == :string end)
                        |> elem(1)

      string = tail
               |> Enum.slice(0 .. string_end - 1)
               |> to_string()

      rest = Enum.slice(tail, (string_end + 1) .. length(tail))
      parse_list(rest, result ++ [string])
    end
    defp parse_list([head | tail], result), do: parse_list(tail, result ++ [head])
  end
