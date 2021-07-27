defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_lines/1)
  end

  defp parse_lines(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> convert_if_is_integer()
  end

  defp convert_if_is_integer([name, hours, day, month, year]) do
    {hours, _} = Integer.parse(hours)
    {day, _} = Integer.parse(day)
    {year, _} = Integer.parse(year)
    name = String.downcase(name)
    [name, hours, day, @months[month], year]
  end
end
