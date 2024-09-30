defmodule JsonParserTestSuite do
  use ExUnit.Case
  alias JsonParser

  @test_dir "test/test_suite/test"

  setup do
    files = File.ls!(@test_dir)
    {:ok, files: files}
  end

  test "fail28.json should return an error" do
    result = parse_json_file("test/test_suite/test/fail28.json")
    assert {:error, "Unterminated string"} = result
  end

  test "fail1.json should return an error" do
    result = parse_json_file("test/test_suite/test/fail1.json")
    assert {:error, "Bad syntax: missing open object or list"} = result
  end

  test "fail17.json should return an error" do
    result = parse_json_file("test/test_suite/test/fail17.json")
    assert {:error, "Illegal backslash escape: \\017"} = result
  end

  test "pass1.json should return an error" do
    result = parse_json_file("test/test_suite/test/pass1.json")
    assert {:ok, _} = result
  end

  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize()
    |> JsonParser.parse()
  end
end
