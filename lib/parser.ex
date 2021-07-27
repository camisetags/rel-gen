defmodule GenReport.Parser do
  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_lines/1)
  end

  defp parse_lines(line) do
    line
    |> String.trim()
    |> String.split(",")
  end
end
