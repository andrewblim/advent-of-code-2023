defmodule Day16 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    grid =
      for {line, row} <- Enum.with_index(lines),
          {ch, col} <- Enum.with_index(String.graphemes(line)),
          ch != ".",
          into: %{} do
        {{row, col}, ch}
      end

    {length(lines), String.length(hd(lines)), grid}
  end

  def move(r, c, dir) do
    case dir do
      :left -> {r, c - 1}
      :right -> {r, c + 1}
      :up -> {r - 1, c}
      :down -> {r + 1, c}
    end
  end

  def advance(beams, grid, n_rows, n_cols, visited \\ MapSet.new()) do
    next_beams =
      for {r, c, dir} <- beams,
          {next_r, next_c} = move(r, c, dir),
          next_r >= 0 and next_r < n_rows,
          next_c >= 0 and next_c < n_cols,
          reduce: [] do
        acc ->
          tile = Map.get(grid, {next_r, next_c}, nil)
          cond do
            tile == nil ->
              [{next_r, next_c, dir} | acc]

            tile == "-" and (dir == :left or dir == :right) ->
              [{next_r, next_c, dir} | acc]
            tile == "-" ->
              [{next_r, next_c, :left}, {next_r, next_c, :right} | acc]

            tile == "|" and (dir == :up or dir == :down) ->
              [{next_r, next_c, dir} | acc]
            tile == "|" ->
              [{next_r, next_c, :up}, {next_r, next_c, :down} | acc]

            tile == "/" and dir == :left ->
              [{next_r, next_c, :down} | acc]
            tile == "/" and dir == :right ->
              [{next_r, next_c, :up} | acc]
            tile == "/" and dir == :up ->
              [{next_r, next_c, :right} | acc]
            tile == "/" and dir == :down ->
              [{next_r, next_c, :left} | acc]

            tile == "\\" and dir == :left ->
              [{next_r, next_c, :up} | acc]
            tile == "\\" and dir == :right ->
              [{next_r, next_c, :down} | acc]
            tile == "\\" and dir == :up ->
              [{next_r, next_c, :left} | acc]
            tile == "\\" and dir == :down ->
              [{next_r, next_c, :right} | acc]
          end
      end
      |> MapSet.new()

    if MapSet.subset?(next_beams, visited) do
      visited
    else
      next_visited = MapSet.union(next_beams, visited)
      advance(next_beams, grid, n_rows, n_cols, next_visited)
    end
  end

  def visited_points(visited) do
    for {r, c, _} <- visited, into: MapSet.new(), do: {r, c}
  end

  def edges(n_rows, n_cols) do
    lr_edges =
      for r <- 0..(n_rows - 1), {c, dir} <- [{-1, :right}, {n_cols, :left}] do
        {r, c, dir}
      end
    ud_edges =
      for c <- 0..(n_cols - 1), {r, dir} <- [{-1, :down}, {n_rows, :up}] do
        {r, c, dir}
      end
    lr_edges ++ ud_edges
  end

  def problem1(input \\ "data/day16.txt", type \\ :file) do
    {n_rows, n_cols, grid} = read_input(input, type)
    advance(MapSet.new([{0, -1, :right}]), grid, n_rows, n_cols)
    |> visited_points()
    |> MapSet.size()
  end

  def problem2(input \\ "data/day16.txt", type \\ :file) do
    {n_rows, n_cols, grid} = read_input(input, type)
    for edge <- edges(n_rows, n_cols) do
      advance(MapSet.new([edge]), grid, n_rows, n_cols)
      |> visited_points()
      |> MapSet.size()
    end
    |> Enum.max()
  end
end
