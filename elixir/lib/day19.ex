defmodule Day19 do
  def read_input(input, type \\ :file) do
    [workflow_text, parts_text] = Helpers.file_or_io(input, type) |> String.trim() |> String.split("\n\n")
    workflows = for line <- String.split(workflow_text, "\n"), into: %{} do
      [_, node, rules_text] = Regex.run(~r/^(\w+){(.+)}$/, line)
      rules = for rule_text <- String.split(rules_text, ",") do
        case String.split(rule_text, ":") do
          [condition, dest] ->
            [_, category, comp, val] = Regex.run(~r/^([xmas])([<>])(\d+)$/, condition)
            {{category, comp, String.to_integer(val)}, dest}
          [dest] ->
            {nil, dest}
        end
      end
      {node, rules}
    end

    parts = for line <- String.split(parts_text, "\n") do
      [_ | vals] = Regex.run(~r/^{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}$/, line)
      Enum.zip(["x", "m", "a", "s"], Enum.map(vals, &String.to_integer/1)) |> Map.new()
    end

    {workflows, parts}
  end

  def apply_workflow(part, workflows, node) do
    case node do
      "A" -> {true, part}
      "R" -> {false, part}
      _ ->
        rules = Map.fetch!(workflows, node)
        {_, next_node} = Enum.find(rules, fn {condition, _} ->
          case condition do
            nil -> true
            {category, "<", val} -> Map.fetch!(part, category) < val
            {category, ">", val} -> Map.fetch!(part, category) > val
          end
        end)
        apply_workflow(part, workflows, next_node)
    end
  end

  def dfs(workflows, current_node, current_intervals) do
    for {condition, dest} <- Map.fetch!(workflows, current_node),
        reduce: {0, current_intervals} do
      {ways, acc_intervals} ->
        {halt_intervals, cont_intervals} = updated_intervals(acc_intervals, condition)
        case dest do
          "A" ->
            {ways + count_ways(halt_intervals), cont_intervals}
          "R" ->
            {ways, cont_intervals}
          _ ->
            {ways + dfs(workflows, dest, halt_intervals), cont_intervals}
        end
    end
    |> elem(0)
  end

  def updated_intervals(intervals, condition) do
    case condition do
      {category, "<", val} ->
        {
          Map.update!(intervals, category, fn v -> interval_intersect_single(v, {1, val - 1}) end),
          Map.update!(intervals, category, fn v -> interval_intersect_single(v, {val, 4000}) end),
        }
      {category, ">", val} ->
        {
          Map.update!(intervals, category, fn v -> interval_intersect_single(v, {val + 1, 4000}) end),
          Map.update!(intervals, category, fn v -> interval_intersect_single(v, {1, val}) end),
        }
      nil ->
        {
          intervals,
          %{"x" => [], "m" => [], "a" => [], "s" => []},
        }
    end
  end

  def interval_intersect_single(existing, {add_x, add_y}) do
    for {x, y} <- existing,
        new_x = max(x, add_x),
        new_y = min(y, add_y),
        new_x <= new_y do
      {new_x, new_y}
    end
  end

  def count_ways(paths) do
    for intervals <- Map.values(paths), reduce: 1 do
      acc ->
        acc * for {x, y} <- intervals, reduce: 0 do
          this_acc -> this_acc + y - x + 1
        end
    end
  end

  def problem1(input \\ "data/day19.txt", type \\ :file) do
    {workflows, parts} = read_input(input, type)
    for part <- parts,
        {accept, _} = apply_workflow(part, workflows, "in"),
        accept,
        reduce: 0 do
      acc -> acc + Enum.sum(Map.values(part))
    end
  end

  def problem2(input \\ "data/day19.txt", type \\ :file) do
    {workflows, _} = read_input(input, type)
    start = %{"x" => [{1, 4000}], "m" => [{1, 4000}], "a" => [{1, 4000}], "s" => [{1, 4000}]}
    dfs(workflows, "in", start)
  end
end
