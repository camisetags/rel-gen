defmodule GenReport do
  alias GenReport.HoursCalculator
  alias GenReport.MonthsCalculator
  alias GenReport.YearCalculator
  alias GenReport.Parser

  def build(filename) when is_binary(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.map(&parse_lines_to_struct/1)
    |> def_report_struct()
  end

  def build(filename) when not is_binary(filename), do: {:error, "filename must me string"}
  def build, do: {:error, "Insira o nome de um arquivo"}

  defp parse_lines_to_struct([nome, horas, dia, mes, ano]) do
    %{
      name: nome,
      hours: horas,
      day: dia,
      month: mes,
      year: ano
    }
  end

  defp def_report_struct(struct_list) do
    %{
      "all_hours" => HoursCalculator.calc_total_hours(struct_list),
      "hours_per_month" => MonthsCalculator.calc_total_months(struct_list),
      "hours_per_year" => YearCalculator.calc_total_years(struct_list)
    }
  end
end
