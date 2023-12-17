defmodule Day12 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    for line <- lines do
      [field, groups] = String.split(line)
      groups = groups |> String.split(",") |> Enum.map(&String.to_integer/1)
      {field, groups}
    end
  end

  def count_ways(field, groups) do
    case {field, groups} do
      {_, []} ->
        if String.contains?(field, "#"), do: 0, else: 1
      {"", _} ->
        0
      {"." <> rest_field, _} ->
        count_ways(rest_field, groups)
      {"#" <> _, [group | rest_groups]} ->
        cond do
          String.length(field) < group + 1 ->
            0
          String.at(field, group) == "#" ->
            0
          String.contains?(String.slice(field, 0, group), ".") ->
            0
          true ->
            count_ways(String.slice(field, (group + 1)..(String.length(field) - 1)), rest_groups)
        end
      {"?" <> rest_field, _} ->
        count_ways(rest_field, groups) + count_ways("#" <> rest_field, groups)
    end
  end

  def problem1(input \\ "data/day12.txt", type \\ :file) do
    read_input(input, type)
    |> Enum.map(fn {field, groups} -> count_ways(field <> ".", groups) end)
    |> Enum.sum()
  end
end
