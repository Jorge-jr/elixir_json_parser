defmodule JsonParser.CLI do
  alias JsonParser

  def main(args) do
    IO.puts "in"
    case args do
      [json_string] ->
        IO.puts("JSON string received")
        case process_json(json_string) do
          :good_job ->
            IO.puts "Valid JSON"
            System.halt(0)  # Exit with code 0 for success

          :bad_stuff ->
            IO.puts "Invalid JSON"
            System.halt(1)  # Exit with code 1 for error

          _ ->
            IO.puts "Unexpected result"
            System.halt(1)
        end

      _ ->
        IO.puts "Usage: json_parser <json_string>"
        System.halt(1)
    end
  end

  defp process_json(json_string) do
    IO.puts("Processing JSON string")
    json_string
    |> String.to_charlist()
    |> JsonLexer.tokenize()
    |> JsonParser.parse()
    |> case do
      :good_job ->
        IO.puts("JSON is valid")
        :good_job

      :bad_stuff ->
        IO.puts("JSON is invalid")
        :bad_stuff

      _ ->
        IO.puts("Unexpected result")
        :bad_stuff
    end
  end
end
