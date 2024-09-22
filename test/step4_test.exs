defmodule JsonParserstep4Test do
  use ExUnit.Case
  alias JsonParser

  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize()
    |> JsonParser.parse()
  end

  @tag :invalid
  test "invalid JSON object" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step4\\invalid.json")
    assert result ==  {:error, "Unexpected token: 39"}
  end

  @tag :valid
  test "valid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step4\\valid.json")
    assert result == {:ok, %{"key" => "value", "key-l" => [], "key-n" => 101, "key-o" => %{}}}
  end

  @tag :valid
  test "valid JSON object 2" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step4\\valid2.json")
    assert result == {:ok, %{"key-o" => %{"inner key" => "inner value"}, "key-l" => ["list value"], "key" => "value", "key-n" => 101}}
  end
end
