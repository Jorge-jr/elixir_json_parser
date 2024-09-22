defmodule JsonParserStep2Test do
  use ExUnit.Case
  alias JsonParser

  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize()
    |> JsonParser.parse()
  end

  @tag :valid
  test "valid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\valid.json")
    assert result == {:ok, %{"key"=> "value"}}
  end

  @tag :valid
  test "valid JSON object 2" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\valid2.json")
    assert result == {:ok, %{"key" => "value", "key2" => "value"}}
  end

  @tag :invalid
  test "invalid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\invalid.json")
    assert result == {:error, "Bad syntax: trailing ','"}
  end

  @tag :invalid
  test "invalid JSON object 2" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\invalid2.json")
    assert result == {:error, "Invalid object structure: expected string key followed by colon, got [number: ~c\"key2: \\\"value\\\"\\n}\"]"}
  end
end
