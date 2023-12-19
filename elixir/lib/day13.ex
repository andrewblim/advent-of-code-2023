defmodule Day13 do
  def read_input(input, type \\ :file) do
    grids =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n\n")

    for grid <- grids do
      lines = String.split(grid, "\n")
      n_rows = length(lines)
      n_cols = String.length(hd(lines))
      entries =
        for {line, row} <- Enum.with_index(String.split(grid, "\n")),
            {ch, col} <- Enum.with_index(String.graphemes(line)),
            ch == "#",
            into: MapSet.new() do
          {row, col}
        end
      {n_rows, n_cols, entries}
    end
  end

  def find_horiz_symmetries(grid, n_rows) do
    for i <- 1..(n_rows - 1)//1, reduce: [] do
      acc ->
        {subgrid1, subgrid2} = grid
        |> Enum.map(fn {r, c} -> {r - i, c} end)
        |> Enum.split_with(fn {r, _} -> r < 0 end)
        subgrid1 = subgrid1
        |> Enum.map(fn {r, c} -> {abs(r) - 1, c} end)
        |> Enum.filter(fn {r, _} -> r < min(i, n_rows - i) end)
        |> MapSet.new()
        subgrid2 = subgrid2
        |> Enum.filter(fn {r, _} -> r < min(i, n_rows - i) end)
        |> MapSet.new()

        if MapSet.equal?(subgrid1, subgrid2), do: [i | acc], else: acc
    end
  end

  def find_vert_symmetries(grid, n_cols) do
    reflected = for {r, c} <- grid, into: MapSet.new(), do: {c, r}
    find_horiz_symmetries(reflected, n_cols)
  end

  def find_horiz_symmetries_smudge(grid, n_rows) do
    for i <- 1..(n_rows - 1)//1, reduce: [] do
      acc ->
        {subgrid1, subgrid2} = grid
        |> Enum.map(fn {r, c} -> {r - i, c} end)
        |> Enum.split_with(fn {r, _} -> r < 0 end)
        subgrid1 = subgrid1
        |> Enum.map(fn {r, c} -> {abs(r) - 1, c} end)
        |> Enum.filter(fn {r, _} -> r < min(i, n_rows - i) end)
        |> MapSet.new()
        subgrid2 = subgrid2
        |> Enum.filter(fn {r, _} -> r < min(i, n_rows - i) end)
        |> MapSet.new()

        diff1 = MapSet.difference(subgrid1, subgrid2)
        diff2 = MapSet.difference(subgrid2, subgrid1)
        cond do
          MapSet.size(diff1) == 1 and MapSet.size(diff2) == 0 -> [i | acc]
          MapSet.size(diff2) == 1 and MapSet.size(diff1) == 0 -> [i | acc]
          true -> acc
        end
    end
  end

  def find_vert_symmetries_smudge(grid, n_cols) do
    reflected = for {r, c} <- grid, into: MapSet.new(), do: {c, r}
    find_horiz_symmetries_smudge(reflected, n_cols)
  end

  def problem1(input \\ "data/day13.txt", type \\ :file) do
    for {n_rows, n_cols, grid} <- read_input(input, type) do
      horiz = find_horiz_symmetries(grid, n_rows)
      horiz_score = horiz |> Enum.map(fn x -> x * 100 end) |> Enum.sum()
      vert = find_vert_symmetries(grid, n_cols)
      vert_score = vert |> Enum.sum()
      horiz_score + vert_score
    end
    |> Enum.sum()
  end

  def problem2(input \\ "data/day13.txt", type \\ :file) do
    for {n_rows, n_cols, grid} <- read_input(input, type) do
      horiz = find_horiz_symmetries_smudge(grid, n_rows)
      horiz_score = horiz |> Enum.map(fn x -> x * 100 end) |> Enum.sum()
      vert = find_vert_symmetries_smudge(grid, n_cols)
      vert_score = vert |> Enum.sum()
      horiz_score + vert_score
    end
    |> Enum.sum()
  end
end
