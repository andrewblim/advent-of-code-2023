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

  def bfs(map, {n_rows, n_cols}, i, points, visited \\ MapSet.new()) do
    if rem(i, 100) == 0, do: IO.inspect({MapSet.size(points), MapSet.size(visited)})
    next_visited = MapSet.union(points, visited)
    cond do
      i == 0 or MapSet.size(points) == 0 ->
        next_visited
      true ->
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
          |> MapSet.difference(next_visited)
        bfs(map, {n_rows, n_cols}, i - 1, next_points, next_visited)
    end
  end

  def count_valid_points(points, {n_rows, n_cols}, {start_r, start_c, start_grid_r, start_grid_c}, n) do
    raw_start_r = start_r + start_grid_r * n_rows
    raw_start_c = start_c + start_grid_c * n_cols
    n_type = Integer.mod(n, 2)
    for {r, c, grid_r, grid_c} <- points,
        raw_r = r + grid_r * n_rows,
        raw_c = c + grid_c * n_cols,
        n_type == Integer.mod(raw_r - raw_start_r + raw_c - raw_start_c, 2),
        reduce: 0 do
      acc -> acc + 1
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
    start = {start_x, start_y, 0, 0}

    bfs(map, {n_rows, n_cols}, n, MapSet.new([start]))
    |> count_valid_points({n_rows, n_cols}, start, n)
  end
end
