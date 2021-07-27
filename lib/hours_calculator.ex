defmodule GenReport.HoursCalculator do
  alias GenReport.Common

  def calc_total_hours(struct_list) do
    name_list = Common.get_all_names(struct_list)
    person_content = extract_person_content(name_list)

    name_list
    |> Enum.reduce(person_content, fn name, acc ->
      Map.put(
        acc,
        Common.tokenize_name(name),
        sum_by_name_and_key(struct_list, name, :hours)
      )
    end)
  end

  defp extract_person_content(names) do
    names
    |> Enum.reduce(%{}, fn person, acc ->
      name = person |> String.downcase() |> String.to_atom()
      Map.put(acc, name, [])
    end)
  end

  defp sum_by_name_and_key(list, name, key) do
    list
    |> Enum.filter(fn person -> person.name == name end)
    |> Enum.map(fn person -> parse_key_to_int(person, key) end)
    |> Enum.sum()
  end

  defp parse_key_to_int(person, key) do
    {num, _} = person[key] |> Integer.parse()
    num
  end
end
