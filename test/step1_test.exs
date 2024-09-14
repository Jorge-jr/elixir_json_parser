defmodule JsonParserTest do
  use ExUnit.Case
  alias JsonParser


  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize_all()
    |> JsonParser.parse_object()
  end

  @tag :valid
  test "valid JSON object" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step1\\valid.json")
    assert result == %{}
  end

  @tag :invalid
  test "invalid JSON object" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step1\\invalid.json")
    assert result == {:error, "Not an object"}
  end
end
