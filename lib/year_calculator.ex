defmodule GenReport.YearCalculator do
  alias GenReport.Common

  def calc_total_years(struct_list) do
    names = Common.get_all_names(struct_list)
    years = get_all_years(struct_list)

    struct_list
    |> group_names(names)
    |> group_months(names, years)
  end

  defp group_months(names_struct, names, years) do
    names
    |> Enum.reduce(names_struct, fn name, acc ->
      person_token_name = Common.tokenize_name(name)
      grouped_months = arrange_years(years, names_struct, person_token_name)
      %{acc | person_token_name => grouped_months}
    end)
  end

  def arrange_years(years, names_struct, person_token_name) do
    years
    |> Enum.reduce(%{}, fn year, acc ->
      month_list = filter_month(names_struct, person_token_name, year)
      Map.put(acc, tokenize_year(year), month_list)
    end)
  end

  defp get_all_years(struct_list) do
    struct_list
    |> Enum.map(fn person -> person.year end)
    |> Enum.uniq()
  end

  defp filter_month(names_struct, person_token_name, year) do
    names_struct[person_token_name]
    |> Enum.filter(fn person -> person.year == year end)
    |> Enum.map(fn person -> parse_int(person.hours) end)
    |> Enum.sum()
  end

  defp parse_int(hour) do
    try do
      hour
      |> Integer.parse()
      |> get_int_part()
    rescue
      FunctionClauseError -> hour
    end
  end

  defp get_int_part({num, _}), do: num

  defp tokenize_year(year) do
    try do
      {num, _} = year |> Integer.parse()
      num
    rescue
      FunctionClauseError -> year
    end
  end

  defp group_names(struct_list, names) do
    Enum.reduce(names, %{}, fn name, acc ->
      Map.put(
        acc,
        Common.tokenize_name(name),
        filter_names(name, struct_list)
      )
    end)
  end

  defp filter_names(name, struct_list) do
    struct_list
    |> Enum.filter(fn person -> person.name == name end)
  end
end
