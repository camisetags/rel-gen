defmodule GenReport.Common do
  def get_all_names(struct_list) do
    struct_list
    |> Enum.map(fn person -> person.name end)
    |> Enum.uniq()
  end

  def tokenize_name(name) do
    name
    |> String.downcase()
  end
end
