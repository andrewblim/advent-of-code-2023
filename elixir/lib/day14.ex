defmodule Day14 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    grid =
      for {line, row} <- Enum.with_index(lines),
          {ch, col} <- Enum.with_index(String.graphemes(line)),
          ch == "#" or ch == "O",
          into: %{} do
        {{row, col}, ch}
      end

    {length(lines), String.length(hd(lines)), grid}
  end

  def tilt_north(grid, n_cols) do
    init_fall_to = for c <- 0..(n_cols - 1), into: %{}, do: {c, 0}

    for {r, c} <- Enum.sort(Map.keys(grid)),
        ch = Map.fetch!(grid, {r, c}),
        reduce: {%{}, init_fall_to} do
      {tilted, fall_to} ->
        case ch do
          "#" ->
            {Map.put(tilted, {r, c}, ch), Map.put(fall_to, c, r + 1)}
          "O" ->
            {Map.put(tilted, {Map.fetch!(fall_to, c), c}, ch), Map.put(fall_to, c, Map.fetch!(fall_to, c) + 1)}
        end
    end
    |> elem(0)
  end

  def rotate_cw(grid, n_rows) do
    for {{r, c}, ch} <- grid, into: %{} do
      {{c, n_rows - 1 - r}, ch}
    end
  end

  def tilt_cycle(grid, n_rows, n_cols) do
    grid
    |> tilt_north(n_cols)
    |> rotate_cw(n_rows)
    |> tilt_north(n_rows)
    |> rotate_cw(n_cols)
    |> tilt_north(n_cols)
    |> rotate_cw(n_rows)
    |> tilt_north(n_rows)
    |> rotate_cw(n_cols)
  end

  def grid_str(grid, n_rows, n_cols) do
    for r <- 0..(n_rows - 1), into: "" do
      for c <- (0..n_cols - 1), into: "" do
        Map.get(grid, {r, c}, ".")
      end <> "\n"
    end
  end

  def print_grid(grid, n_rows, n_cols) do
    IO.puts(grid_str(grid, n_rows, n_cols))
  end

  def score(grid, n_rows) do
    for {{r, _}, ch} <- grid,
        ch == "O",
        reduce: 0 do
      acc -> acc + n_rows - r
    end
  end

  def find_cycle(grid, n_rows, n_cols) do
    init_seen = %{grid => 0}
    Enum.reduce_while(
      1..1000,  # arbitrary big enough number
      {grid, init_seen},
      fn i, {grid, seen} ->
        next_grid = tilt_cycle(grid, n_rows, n_cols)
        if Map.has_key?(seen, next_grid) do
          {:halt, {seen, Map.fetch!(seen, next_grid), i - Map.fetch!(seen, next_grid)}}
        else
          {:cont, {next_grid, Map.put(seen, next_grid, i)}}
        end
      end
    )
  end

  def problem1(input \\ "data/day14.txt", type \\ :file) do
    {n_rows, n_cols, grid} = read_input(input, type)
    grid |> tilt_north(n_cols) |> score(n_rows)
  end

  def problem2(input \\ "data/day14.txt", type \\ :file) do
    {n_rows, n_cols, grid} = read_input(input, type)
    {all_seen, cycle_start, cycle_length} = find_cycle(grid, n_rows, n_cols)
    i = rem(1000000000 - cycle_start, cycle_length) + cycle_start
    Enum.find(all_seen, fn {_, v} -> v == i end) |> elem(0) |> score(n_rows)
  end
end
