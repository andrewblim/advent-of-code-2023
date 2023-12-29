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

  def step2(map, {n_rows, n_cols}, i, points, prev_points \\ MapSet.new(), total1 \\ 0, total2 \\ 0) do
    if rem(i, 1000) == 0, do: IO.inspect(MapSet.size(points))
    case i do
      0 ->
        total2 + MapSet.size(points)
      _ ->
        next_points =
          for {r, c, grid_r, grid_c} <- points,
              {adjacent_r, adjacent_c} <- [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}],
              effective_r = Integer.mod(adjacent_r, n_rows),
              effective_c = Integer.mod(adjacent_c, n_cols),
              Map.get(map, {effective_r, effective_c}) != "#",
              into: MapSet.new() do
            {offset_r, offset_c} = cond do
              adjacent_r < 0 -> {-1, 0}
              adjacent_r >= n_rows -> {1, 0}
              adjacent_c < 0 -> {0, -1}
              adjacent_c >= n_cols -> {0, 1}
              true -> {0, 0}
            end
            {effective_r, effective_c, grid_r + offset_r, grid_c + offset_c}
          end
          |> MapSet.difference(prev_points)
        step2(map, {n_rows, n_cols}, i - 1, next_points, points, total2 + MapSet.size(points), total1)
    end
  end

  def problem1(input \\ "data/day21.txt", type \\ :file, n \\ 64) do
    {map, _} = read_input(input, type)
    start = Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
    step(map, MapSet.new([start]), n) |> MapSet.size()
  end

  def problem2(input \\ "data/day21.txt", type \\ :file, n \\ 64) do
    {map, {n_rows, n_cols}} = read_input(input, type)
    {start_x, start_y} = Enum.find(map, fn {_, v} -> v == "S" end) |> elem(0)
    step2(map, {n_rows, n_cols}, n, MapSet.new([{start_x, start_y, 0, 0}]))
  end
end
