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

  def count_ways(field, groups, memo \\ %{}) do
    case {field, groups} do
      {_, []} ->
        if String.contains?(field, "#"), do: 0, else: 1
      {"", _} ->
        0
      {"." <> rest_field, _} ->
        Map.fetch!(memo, {rest_field, groups})
      {"#" <> _, [group | rest_groups]} ->
        cond do
          String.length(field) < group + 1 ->
            0
          String.at(field, group) == "#" ->
            0
          String.contains?(String.slice(field, 0, group), ".") ->
            0
          true ->
            Map.fetch!(memo, {String.slice(field, (group + 1)..(String.length(field) - 1)), rest_groups})
        end
      {"?" <> rest_field, _} ->
        Map.fetch!(memo, {rest_field, groups}) + count_ways("#" <> rest_field, groups, memo)
    end
  end

  def count_ways_wrapper(field, groups) do
    memo =
      for n <- 0..String.length(field),
          subfield = String.slice(field, String.length(field) - n, n),
          into: %{} do
        {{subfield, []}, (if String.contains?(subfield, "#"), do: 0, else: 1)}
      end

    for n <- 0..String.length(field),
        subfield = String.slice(field, String.length(field) - n, n),
        i <- 1..length(groups),
        subgroups = Enum.slice(groups, (length(groups) - i)..length(groups)),
        reduce: memo do
      memo ->
        Map.put(memo, {subfield, subgroups}, count_ways(subfield, subgroups, memo))
    end
    |> Map.get({field, groups})
  end


  def expand_field(field, n) do
    (for _ <- 1..n, do: field) |> Enum.join("?")
  end

  def expand_groups(groups, n) do
    for _ <- 1..n, g <- groups, into: [], do: g
  end

  def problem1(input \\ "data/day12.txt", type \\ :file) do
    read_input(input, type)
    |> Enum.map(fn {field, groups} -> count_ways_wrapper(field <> ".", groups) end)
    |> Enum.sum()
  end

  def problem2(input \\ "data/day12.txt", type \\ :file) do
    read_input(input, type)
    |> Enum.map(fn {field, groups} ->
      count_ways_wrapper(expand_field(field, 5) <> ".", expand_groups(groups, 5))
    end)
    |> Enum.sum()
  end
end
