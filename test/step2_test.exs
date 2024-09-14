defmodule JsonParserStep2Test do
  use ExUnit.Case
  alias JsonParser

  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize_all()
    |> JsonParser.parse_object()
  end

  @tag :valid
  test "valid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\valid.json")
    assert result == %{"key"=> "value"}
  end

  @tag :valid
  test "valid JSON object 2" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\valid2.json")
    assert result == %{"key" => "value", "key2" => "value"}
  end

  @tag :invalid
  test "invalid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\invalid.json")
    assert result == {:error, "Bad syntax: trailling ','"}
  end

  @tag :invalid
  test "invalid JSON object 2" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step2\\invalid2.json")
    assert result == {:error, "Missing opening \""}
  end
end
