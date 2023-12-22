defmodule Day17 do
  def read_input(input, type \\ :file) do
    lines =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n")

    grid =
      for {line, row} <- Enum.with_index(lines),
          {ch, col} <- Enum.with_index(String.graphemes(line)),
          into: %{} do
        {{row, col}, String.to_integer(ch)}
      end

    {length(lines), String.length(hd(lines)), grid}
  end

  def make_edges(grid, n_rows, n_cols) do
    from_vert_nodes =
      for r <- 0..(n_rows - 1),
          c <- 0..(n_cols - 1),
          offset <- [-3, -2, -1, 1, 2, 3],
          next_r = r + offset,
          next_r >= 0 and next_r < n_rows,
          reduce: %{} do
        acc ->
          from = {r, c, :vert}
          to = {next_r, c, :horiz}
          cost_range = if offset < 0, do: offset..-1, else: 1..offset
          cost = Enum.map(cost_range, fn i -> Map.fetch!(grid, {r + i, c}) end) |> Enum.sum()
          Map.update(acc, from, [{to, cost}], fn x -> [{to, cost} | x] end)
      end
    from_horiz_nodes =
      for r <- 0..(n_rows - 1),
          c <- 0..(n_cols - 1),
          offset <- [-3, -2, -1, 1, 2, 3],
          next_c = c + offset,
          next_c >= 0 and next_c < n_cols,
          reduce: %{} do
        acc ->
          from = {r, c, :horiz}
          to = {r, next_c, :vert}
          cost_range = if offset < 0, do: offset..-1, else: 1..offset
          cost = Enum.map(cost_range, fn i -> Map.fetch!(grid, {r, c + i}) end) |> Enum.sum()
          Map.update(acc, from, [{to, cost}], fn x -> [{to, cost} | x] end)
      end
    Map.merge(from_vert_nodes, from_horiz_nodes)
  end

  def dijkstra(node, edges, targets, distances, visited) do
    if rem(MapSet.size(visited), 100) == 0, do: IO.inspect(MapSet.size(visited))
    next_distances =
      for {neighbor, cost} <- Map.fetch!(edges, node),
          not MapSet.member?(visited, neighbor),
          reduce: distances do
        distances ->
          d = Map.fetch!(distances, node) + cost
          Map.update!(distances, neighbor, fn x -> if x == nil, do: d, else: min(x, d) end)
      end
    next_visited = MapSet.put(visited, node)
    if MapSet.subset?(targets, next_visited) do
      next_distances
    else
      next_node = distances
      |> Map.filter(fn {k, _} -> not MapSet.member?(visited, k) end)
      |> Enum.min_by(fn {_, v} -> v end)  # nil comes after integers in Elixir sorting
      |> elem(0)
      dijkstra(next_node, edges, targets, next_distances, next_visited)
    end
  end

  def problem1(input \\ "data/day17.txt", type \\ :file) do
    {n_rows, n_cols, grid} = read_input(input, type)

    edges = make_edges(grid, n_rows, n_cols)
    distances = for {r, c} <- Map.keys(grid), orient <- [:horiz, :vert], into: %{}, do: {{r, c, orient}, nil}
    # add fake initial node that points to both upper-left states at 0 cost
    init_node = {nil, nil, nil}
    edges = Map.put(edges, init_node, [{{0, 0, :horiz}, 0}, {{0, 0, :vert}, 0}])
    distances = Map.put(distances, init_node, 0)

    targets = MapSet.new([{n_rows - 1, n_cols - 1, :horiz}, {n_rows - 1, n_cols - 1, :vert}])
    dijkstra(init_node, edges, targets, distances, MapSet.new())
    |> Map.filter(fn {k, _} -> MapSet.member?(targets, k) end)
    |> Map.values()
    |> Enum.min()
  end

  def problem2(input \\ "data/day17.txt", type \\ :file) do
    read_input(input, type)
  end
end
