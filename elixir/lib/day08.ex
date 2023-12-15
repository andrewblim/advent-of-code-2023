defmodule Day08 do
  def read_input(input, type \\ :file) do
    [instructions, paths_text] =
      Helpers.file_or_io(input, type)
      |> String.trim
      |> String.split("\n\n")
    paths =
      for line <- String.split(paths_text, "\n") do
        [_, from, left, right] = Regex.run(~r/^(\w+) = \((\w+), (\w+)\)$/, line)
        {from, left, right}
      end
    {instructions, paths}
  end

  def make_map(paths) do
    for {from, left, right} <- paths, into: %{}, do: {from, {left, right}}
  end

  def move(start, map, step) do
    {l, r} = Map.get(map, start)
    case step do
      "L" -> l
      "R" -> r
    end
  end

  def move_until(start, target, map, instructions) do
    Enum.reduce_while(
      Stream.cycle(String.graphemes(instructions)),
      {start, 0},
      fn step, {current, i} ->
        if current == target do
          {:halt, i}
        else
          {:cont, {move(current, map, step), i + 1}}
        end
      end
    )
  end

  # From a node, we must go a certain number of steps but eventually start cycling, since there are only
  # a finite number of nodes

  def steps_at_target(node, map, instructions, target_suffix, steps \\ 0, visited \\ %{}, at_target \\ []) do
    n = String.length(instructions)
    if rem(steps, n) == 0 and Map.has_key?(visited, node) do
      # Note: by observation on actual input, for instruction length n, the nodes all ended up cycling
      # such that they hit targets at i * k * n, for i = 1, 2, 3... and k = some cycle length that varied
      # by node. So the answer ended up being the LCM of all the k * n (and actually all the k were prime,
      # so really the (product of the k) * n).
      at_target_stream(Map.get(visited, node), steps, Enum.reverse(at_target)) |> Enum.take(10)
    else
      visited = if rem(steps, n) == 0, do: Map.put(visited, node, steps), else: visited
      at_target = if at_target?(node, target_suffix), do: [steps | at_target], else: at_target
      next = move(node, map, String.at(instructions, rem(steps, n)))
      steps_at_target(next, map, instructions, target_suffix, steps + 1, visited, at_target)
    end
  end

  def at_target_stream(cycle_point, recycle_point, at_target) do
    at_target_before_cycle = Enum.filter(at_target, fn x -> x < cycle_point end)
    at_target_in_cycle = Enum.filter(at_target, fn x -> x >= cycle_point end)
    n = length(at_target_in_cycle)
    cycle_length = recycle_point - cycle_point
    Stream.concat(
      at_target_before_cycle,
      at_target_in_cycle
      |> Stream.cycle()
      |> Stream.with_index()
      |> Stream.map(fn {x, i} -> Integer.floor_div(i, n) * cycle_length + x end)
    )
  end

  def at_target?(node, target_suffix) do
    String.ends_with?(node, target_suffix)
  end

  def problem1(input \\ "data/day08.txt", type \\ :file) do
    {instructions, paths} = read_input(input, type)
    map = make_map(paths)
    move_until("AAA", "ZZZ", map, instructions)
  end

  def problem2(input \\ "data/day08.txt", type \\ :file) do
    {instructions, paths} = read_input(input, type)
    map = make_map(paths)
    start_nodes = Map.keys(map) |> Enum.filter(fn x -> String.ends_with?(x, "A") end) |> MapSet.new()
    for node <- start_nodes, into: %{}, do: {node, steps_at_target(node, map, instructions, "Z")}
  end
end
