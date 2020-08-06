defmodule Mix.Tasks.UpdateEntities do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSV

  @shortdoc "Update html entities source file from CSV export"
  def run([]) do
    IO.puts("usage: mix update_entities path/to/wiki.csv")
    System.halt(1)
  end

  def run([path]) do
    case File.read(path) do
      {:error, _} ->
        IO.puts("could not read file at: #{path}")
        System.halt(1)

      {:ok, contents} ->
        CSV.parse_string(contents)
        |> Enum.map(fn [names | rest] -> [String.replace(names, ",[a]", "[a],") | rest] end)
        |> Enum.flat_map(fn [names | rest] ->
          names
          |> String.split(", ")
          |> Enum.map(&[&1 | rest])
        end)
        |> Enum.map(fn [name, _char, codepoint, standard, _dtd, _iso_subset, _description] ->
          if String.ends_with?(name, "[a]") do
            %{
              name: String.replace(name, "[a]", ""),
              codepoint: codepoint,
              standard: standard,
              optional_semicolon: true
            }
          else
            %{
              name: name,
              codepoint: codepoint,
              standard: standard,
              optional_semicolon: false
            }
          end
        end)
        |> Enum.take(5)
        |> IO.inspect()
    end
  end
end
