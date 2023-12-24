defmodule Day18 do
  def read_input(input, type \\ :file) do
    lines = Helpers.file_or_io(input, type) |> String.trim() |> String.split("\n")
    for line <- lines,
        [dir, dist, color] = String.split(line) do
      {dir, String.to_integer(dist), color}
    end
  end

  def dig_border(instructions, start) do
    for {dir, dist, color} <- instructions,
        reduce: {%{start => :start}, start} do
      {grid, {r, c}} ->
        points = case dir do
          "U" -> Enum.map(dist..1//-1, fn i -> {r - i, c} end)
          "D" -> Enum.map(dist..1//-1, fn i -> {r + i, c} end)
          "L" -> Enum.map(dist..1//-1, fn i -> {r, c - i} end)
          "R" -> Enum.map(dist..1//-1, fn i -> {r, c + i} end)
        end
        next_grid = for point <- points, into: grid, do: {point, color}
        {next_grid, hd(points)}
    end
  end

  def flip_location(location) do
    case location do
      :outside -> :inside
      :inside -> :outside
    end
  end

  def paint_interior(grid) do
    min_row = Map.keys(grid) |> Enum.min_by(fn {r, _} -> r end) |> elem(0)
    max_row = Map.keys(grid) |> Enum.max_by(fn {r, _} -> r end) |> elem(0)
    min_col = Map.keys(grid) |> Enum.min_by(fn {_, c} -> c end) |> elem(1)
    max_col = Map.keys(grid) |> Enum.max_by(fn {_, c} -> c end) |> elem(1)
    {grid, :outside, nil} =
      for r <- min_row..max_row,
          c <- min_col..max_col,
          reduce: {grid, :outside, nil} do
        {grid, location, wall_from} ->
          is_wall? = Map.has_key?(grid, {r, c}) and Map.get(grid, {r, c}) != :fill
          is_wall_above? = Map.has_key?(grid, {r - 1, c}) and Map.get(grid, {r - 1, c}) != :fill
          is_wall_below? = Map.has_key?(grid, {r + 1, c}) and Map.get(grid, {r + 1, c}) != :fill
          case {is_wall?, location, wall_from, is_wall_above?, is_wall_below?} do
            # Mark blanks per location
            {false, :outside, nil, _, _} ->
              {grid, :outside, nil}
            {false, :inside, nil, _, _} ->
              {Map.put(grid, {r, c}, :fill), :inside, nil}

            # If we hit a wall that extends above and below, flip location
            {true, location, nil, true, true} ->
              {grid, flip_location(location), nil}

            # If we hit a wall that extends only above or below and we're outside/inside, we're riding the wall
            {true, location, nil, true, false} ->
              {grid, location, :above}
            {true, location, nil, false, true} ->
              {grid, location, :below}

            # If we hit a wall that extends neither above or below and we're riding the wall, keep riding
            {true, location, :above, false, false} ->
              {grid, location, :above}
            {true, location, :below, false, false} ->
              {grid, location, :below}

            # If we hit a wall that extends only above or below and we're outside/inside, adjust location as needed
            {true, location, :above, true, false} ->
              {grid, location, nil}
            {true, location, :above, false, true} ->
              {grid, flip_location(location), nil}
            {true, location, :below, true, false} ->
              {grid, flip_location(location), nil}
            {true, location, :below, false, true} ->
              {grid, location, nil}
          end
      end
    grid
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
    {grid, {0, 0}} = dig_border(instructions, {0, 0})
    paint_interior(grid) |> map_size()
  end

  def problem2(input \\ "data/day18.txt", type \\ :file) do
    read_input(input, type)
  end
end
