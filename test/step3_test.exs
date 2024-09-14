defmodule JsonParserstep3Test do
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
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step3\\valid.json")
    assert result == %{"key2" => false, "key1" => true, "key3" => nil, "key4" => "value", "key5" => 101}
  end


  @tag :invalid
  test "invalid JSON object 1" do
    result = parse_json_file("C:\\Users\\JSRIB\\Estudo\\Elixir\\Json parser\\json_parser\\test\\tests\\step3\\invalid.json")
    assert result == {:error, "Bad syntax"}
  end
end
