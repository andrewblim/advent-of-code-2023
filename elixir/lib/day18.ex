defmodule Day18 do
  def read_input(input, type \\ :file) do
    lines = Helpers.file_or_io(input, type) |> String.trim() |> String.split("\n")
    for line <- lines,
        [dir, dist, color] = String.split(line) do
      [_, hex] = Regex.run(~r/^\(#(\w+)\)$/, color)
      hex_int = String.to_integer(hex, 16)
      {dir, String.to_integer(dist), Integer.floor_div(hex_int, 16), rem(hex_int, 16)}
    end
  end

  def dig_corners(instructions, start) do
    for {dir, dist, _, _} <- instructions,
        reduce: {%{start => :wall}, start} do
      {grid, {r, c}} ->
        point = case dir do
          "U" -> {r - dist, c}
          "D" -> {r + dist, c}
          "L" -> {r, c - dist}
          "R" -> {r, c + dist}
        end
        {Map.put(grid, point, :wall), point}
    end
  end

  def dig_corners2(instructions, start) do
    for {_, _, dist, dir} <- instructions,
        reduce: {%{start => :wall}, start} do
      {grid, {r, c}} ->
        point = case dir do
          3 -> {r - dist, c}
          1 -> {r + dist, c}
          2 -> {r, c - dist}
          0 -> {r, c + dist}
        end
        {Map.put(grid, point, :wall), point}
    end
  end

  def count_fill(grid) do
    row_groups = Map.keys(grid) |> Enum.sort() |> Enum.group_by(fn {r, _} -> r end)
    start_prev_r = (Map.keys(row_groups) |> Enum.min()) - 1
    for {r, row_group} <- Enum.sort(row_groups),
        reduce: {0, start_prev_r, MapSet.new(), []} do
      {count, prev_r, prev_cols, prev_intervals} ->
        # Add fill seen since the last row
        count = count + (r - prev_r - 1) * interval_size(prev_intervals)

        # Compute new cols/intervals after this row
        cols = Enum.map(row_group, fn {_, c} -> c end) |> MapSet.new()
        cols = MapSet.difference(MapSet.union(cols, prev_cols), MapSet.intersection(cols, prev_cols))
        intervals = cols_to_intervals(cols)

        # Add fill from the current row, which is the size of the union of the intervals
        count = count + interval_size(interval_union(intervals, prev_intervals))

        {count, r, cols, intervals}
    end
    |> elem(0)
  end

  def cols_to_intervals(cols) do
    cols |> Enum.sort() |> Enum.chunk_every(2)
  end

  def interval_size(intervals) do
    intervals
    |> Enum.map(fn [c1, c2] -> c2 - c1 + 1 end)
    |> Enum.sum()
  end

  def interval_union(intervals1, intervals2) do
    for [c1, c2] <- Enum.sort(intervals1 ++ intervals2), reduce: [] do
      combined ->
        case combined do
          [] -> [[c1, c2]]
          [[_, prev_c2] | _] when prev_c2 < c1 ->
            [[c1, c2] | combined]
          [[prev_c1, prev_c2] | rest] when prev_c2 < c2 ->
            [[prev_c1, c2] | rest]
          _ ->
            combined
        end
    end
  end

  def print(grid, device \\ :stdio) do
    min_row = Map.keys(grid) |> Enum.min_by(fn {r, _} -> r end) |> elem(0)
    max_row = Map.keys(grid) |> Enum.max_by(fn {r, _} -> r end) |> elem(0)
    min_col = Map.keys(grid) |> Enum.min_by(fn {_, c} -> c end) |> elem(1)
    max_col = Map.keys(grid) |> Enum.max_by(fn {_, c} -> c end) |> elem(1)
    for r <- min_row..max_row do
      for c <- min_col..max_col do
        ch = if Map.has_key?(grid, {r, c}), do: "#", else: "."
        IO.write(device, ch)
      end
      IO.write(device, "\n")
    end
    grid
  end

  def problem1(input \\ "data/day18.txt", type \\ :file) do
    instructions = read_input(input, type)
    {grid, {0, 0}} = dig_corners(instructions, {0, 0})
    count_fill(grid)
  end

  def problem2(input \\ "data/day18.txt", type \\ :file) do
    instructions = read_input(input, type)
    {grid, {0, 0}} = dig_corners2(instructions, {0, 0})
    count_fill(grid)
  end
end
