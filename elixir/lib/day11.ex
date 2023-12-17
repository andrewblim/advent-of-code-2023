defmodule Day11 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    for {line, row} <- Enum.with_index(lines),
        {ch, col} <- Enum.with_index(String.graphemes(line)),
        ch == "#",
        into: MapSet.new() do
      {row, col}
    end
  end

  def distance({r1, c1}, {r2, c2}) do
    abs(r2 - r1) + abs(c2 - c1)
  end

  def expand(universe, factor) do
    min_row = universe |> Enum.map(fn x -> elem(x, 0) end) |> Enum.min()
    max_row = universe |> Enum.map(fn x -> elem(x, 0) end) |> Enum.max()
    min_col = universe |> Enum.map(fn x -> elem(x, 1) end) |> Enum.min()
    max_col = universe |> Enum.map(fn x -> elem(x, 1) end) |> Enum.max()
    {row_shifts, _} =
      for i <- min_row..max_row, reduce: {%{}, 0} do
        {shifts, bump} ->
          if not Enum.any?(universe, fn {row, _} -> i == row end) do
            {shifts, bump + factor - 1}
          else
            {Map.put(shifts, i, bump), bump}
          end
      end
    {col_shifts, _} =
      for j <- min_col..max_col, reduce: {%{}, 0} do
        {shifts, bump} ->
          if not Enum.any?(universe, fn {_, col} -> j == col end) do
            {shifts, bump + factor - 1}
          else
            {Map.put(shifts, j, bump), bump}
          end
      end
    for {row, col} <- universe, into: MapSet.new() do
      {row + Map.get(row_shifts, row), col + Map.get(col_shifts, col)}
    end
  end

  def sum_distances(universe) do
    for x <- universe, y <- universe, x < y, reduce: 0 do
      acc -> acc + distance(x, y)
    end
  end

  def problem1(input \\ "data/day11.txt", type \\ :file) do
    read_input(input, type)
    |> expand(2)
    |> sum_distances()
  end

  def problem2(input \\ "data/day11.txt", type \\ :file, factor \\ 1000000) do
    read_input(input, type)
    |> expand(factor)
    |> sum_distances()
  end
end
