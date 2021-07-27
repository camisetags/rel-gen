defmodule GenReport.MonthsCalculator do
  alias GenReport.Common

  @months %{
    "1" => :janeiro,
    "2" => :fevereiro,
    "3" => :março,
    "4" => :abril,
    "5" => :maio,
    "6" => :junho,
    "7" => :julho,
    "8" => :agosto,
    "9" => :setembro,
    "10" => :outubro,
    "11" => :novembro,
    "12" => :dezembro
  }

  def calc_total_months(struct_list) do
    names = Common.get_all_names(struct_list)

    struct_list
    |> parse_months_to_extense()
    |> group_names(names)
    |> group_months(names)
  end

  defp parse_months_to_extense(struct_list) do
    struct_list
    |> Enum.map(fn person ->
      Map.put(person, :month, @months[person.month])
    end)
  end

  defp group_months(names_struct, names) do
    names
    |> Enum.reduce(names_struct, fn name, acc ->
      token_name = Common.tokenize_name(name)
      grouped_months = arrange_months(names_struct, token_name)
      %{acc | token_name => grouped_months}
    end)
  end

  def arrange_months(names_struct, token_name) do
    Enum.map(@months, fn {_, value} -> value end)
    |> Enum.reduce(%{}, fn month, acc ->
      month_list = filter_month(names_struct, token_name, month)
      Map.put(acc, month, month_list)
    end)
  end

  defp filter_month(names_struct, token_name, month) do
    names_struct[token_name]
    |> Enum.filter(fn person -> person.month == month end)
    |> Enum.map(fn person -> parse_int(person.hours) end)
    |> Enum.sum()
  end

  defp parse_int(hour) do
    hour
    |> Integer.parse()
    |> get_int_part()
  end

  defp get_int_part({num, _}), do: num

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
    Enum.filter(struct_list, fn person ->
      person.name == name
    end)
  end
end
