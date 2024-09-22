defmodule JsonParserStep5Test do
  use ExUnit.Case
  alias JsonParser

  defp parse_json_file(filename) do
    filename
    |> File.read!()
    |> JsonLexer.tokenize()
    |> JsonParser.parse()
  end

  @tag :valid
  test "nested objects" do
    result = parse_json_file("test/tests/step5/nested_objects.json")
    expected = {:ok,
      %{
        "name" => "John Doe",
        "age" => 30.0,
        "address" => %{
          "street" => "123 Main St",
          "city" => "Anytown",
          "country" => "USA"
        },
        "contacts" => %{
          "email" => "john@example.com",
          "phone" => %{
            "home" => "555-1234",
            "work" => "555-5678"
          }
        }
      }
    }
    assert result == expected
  end

  @tag :valid
  test "nested arrays" do
    result = parse_json_file("test/tests/step5/nested_arrays.json")
    expected = {:ok,
      %{
        "fibonacci" => [0, 1, 1, 2, 3, 5, 8, 13],
        "matrix" => [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ],
        "mixed" => [1, "two", true, [false, nil], %{"key" => "value"}]
      }
    }
    assert result == expected
  end

  @tag :valid
  test "complex nested structure" do
    result = parse_json_file("test/tests/step5/complex_nested.json")
    expected = {:ok,
      %{
        "store" => %{
          "book" => [
            %{
              "category" => "reference",
              "author" => "Nigel Rees",
              "title" => "Sayings of the Century",
              "price" => 8.95
            },
            %{
              "category" => "fiction",
              "author" => "Evelyn Waugh",
              "title" => "Sword of Honour",
              "price" => 12.99
            }
          ],
          "bicycle" => %{
            "color" => "red",
            "price" => 19.95
          }
        },
        "expensive" => 10
      }
    }
    assert result == expected
  end

  @tag :invalid
  test "invalid nested structure" do
    result = parse_json_file("test/tests/step5/invalid_nested.json")
    assert result == {:error, "Invalid object structure: expected ',' or '}' after value"}
  end

end
