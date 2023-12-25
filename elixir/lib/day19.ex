defmodule Day19 do
  def read_input(input, type \\ :file) do
    [workflow_text, parts_text] = Helpers.file_or_io(input, type) |> String.trim() |> String.split("\n\n")
    workflows = for line <- String.split(workflow_text, "\n"), into: %{} do
      [_, name, rules_text] = Regex.run(~r/^(\w+){(.+)}$/, line)
      rules = for rule_text <- String.split(rules_text, ",") do
        case String.split(rule_text, ":") do
          [condition, dest] ->
            [_, category, comp, val] = Regex.run(~r/^([xmas])([<>])(\d+)$/, condition)
            val = String.to_integer(val)
            case comp do
              "<" -> [fn parts -> Map.fetch!(parts, category) < val end, dest]
              ">" -> [fn parts -> Map.fetch!(parts, category) > val end, dest]
            end
          [dest] ->
            [fn _ -> true end, dest]
        end
      end
      {name, rules}
    end

    parts = for line <- String.split(parts_text, "\n") do
      [_ | vals] = Regex.run(~r/^{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}$/, line)
      Enum.zip(["x", "m", "a", "s"], Enum.map(vals, &String.to_integer/1)) |> Map.new()
    end

    {workflows, parts}
  end

  def apply_workflow(part, workflows, name) do
    case name do
      "A" -> {true, part}
      "R" -> {false, part}
      _ ->
        rules = Map.fetch!(workflows, name)
        [_, next_name] = Enum.find(rules, fn [condition, _] -> condition.(part) end)
        apply_workflow(part, workflows, next_name)
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
    read_input(input, type)
  end
end
