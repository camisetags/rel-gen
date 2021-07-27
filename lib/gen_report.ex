defmodule GenReport do

  def build(filename) when is_binary(filename) do
    File.stream!(filename)
    |> Enum.map(&parse_lines/1)
    |> calc_total_by_key(:hours)
    |> IO.inspect()
  end

  def build(filename) when not is_binary(filename), do: {:error, "filename must me string"}

  defp parse_lines(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> parse_lines_to_struct()
  end

  defp get_all_names(struct_list) do
    struct_list
    |> Enum.map(fn person -> person.name end)
    |> Enum.uniq()
  end

  defp calc_total_by_key(struct_list, key) do
    name_list = get_all_names(struct_list)
    person_content = extract_person_content(name_list)

    name_list
    |> Enum.reduce(person_content, fn name, acc ->
      person_name = name |> String.downcase() |> String.to_atom()
      Map.put(acc, person_name, sum_by_name_and_key(struct_list, name, key))
    end)
  end

  defp sum_by_name_and_key(list, name, key) do
    list
    |> Enum.filter(fn person -> person.name == name end)
    |> Enum.map(fn person ->
      {num, _} = person[key] |> Integer.parse()
      num
    end)
    |> Enum.sum()
  end

  defp extract_person_content(names) do
    names
    |> Enum.reduce(%{}, fn person, acc ->
      name = person |> String.downcase() |> String.to_atom()
      Map.put(acc, name, [])
    end)
  end

  defp parse_lines_to_struct([nome, horas, dia, mes, ano]) do
    %{
      name: nome,
      hours: horas,
      day: dia,
      month: mes,
      year: ano
    }
  end

  defp def_report_struct() do
    %{
      all_hours: %{},
      hours_per_month: %{},
      hours_per_year: %{},
    }
  end
end
