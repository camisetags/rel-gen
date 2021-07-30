defmodule GenReport do
  alias GenReport.HoursCalculator
  alias GenReport.MonthsCalculator
  alias GenReport.YearCalculator
  alias GenReport.Parser
  alias GenReport.MapUtils

  def build(filename) when is_binary(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.map(&parse_lines_to_struct/1)
    |> def_report_struct()
  end

  def build(filename) when not is_binary(filename), do: {:error, "filename must me string"}
  def build, do: {:error, "Insira o nome de um arquivo"}

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build(&1))
    |> Enum.map(& &1)
    |> Enum.reduce(nil, fn {:ok, result}, acc ->
      accumulate_report(acc, result)
    end)
  end

  defp accumulate_report(nil, result), do: result
  defp accumulate_report(report1, report2), do: MapUtils.deep_merge(report1, report2)

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
