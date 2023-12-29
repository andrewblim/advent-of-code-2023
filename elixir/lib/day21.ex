defmodule Day21 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    map =
      for {line, row} <- Enum.with_index(lines),
          {ch, col} <- Enum.with_index(String.graphemes(line)),
          ch != ".",
          into: %{} do
        {{row, col}, ch}
      end
    {map, {length(lines), String.length(hd(lines))}}
  end

  def step(map, positions, i) do
    case i do
      0 -> positions
      _ ->
        next_positions =
          for {r, c} <- positions,
              neighbor <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
              Map.get(map, neighbor) != "#",
              into: MapSet.new() do
            neighbor
          end
        step(map, next_positions, i - 1)
    end
  end

  # keep positions as a map from {r, c} => sets of {grid_r, grid_c}

  def step2(map, {n_rows, n_cols}, positions, i) do
    case i do
      0 ->
        positions
      _ ->
        next_positions =
          for {{r, c}, grid_positions} <- positions,
              {adjacent_r, adjacent_c} <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
              effective_r = Integer.mod(adjacent_r, n_rows),
              effective_c = Integer.mod(adjacent_c, n_cols),
              Map.get(map, {effective_r, effective_c}) != "#",
              reduce: %{} do
            acc ->
              {offset_r, offset_c} = cond do
                adjacent_r < 0 -> {-1, 0}
                adjacent_r >= n_rows -> {1, 0}
                adjacent_c < 0 -> {0, -1}
                adjacent_c >= n_cols -> {0, 1}
                true -> {0, 0}
              end
              updated_grid_positions = if {offset_r, offset_c} == {0, 0} do
                grid_positions
              else
                for {grid_r, grid_c} <- grid_positions, into: MapSet.new() do
                  {grid_r + offset_r, grid_c + offset_c}
                end
              end
              Map.update(
                acc,
                {effective_r, effective_c},
                updated_grid_positions,
                fn v -> MapSet.union(updated_grid_positions, v) end
              )
          end

        step2(map, {n_rows, n_cols}, next_positions, i - 1)
    end
  end

  def problem1(input \\ "data/day21.txt", type \\ :file, n \\ 64) do
    {map, _} = read_input(input, type)
    start = Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
    step(map, MapSet.new([start]), n) |> MapSet.size()
  end

  def problem2(input \\ "data/day21.txt", type \\ :file, n \\ 64) do
    {map, {n_rows, n_cols}} = read_input(input, type)
    start = Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
    step2(map, {n_rows, n_cols}, %{start => MapSet.new([{0, 0}])}, n)
    |> Map.values()
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end
end
