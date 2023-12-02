defmodule Day02 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def parse_line(line) do
    [_, id_text, draws_text] = Regex.run(~r/^Game (\d+)\: (.*)$/, line)
    draws =
      for draw_text <- String.split(draws_text, "; ") do
        for cube_text <- String.split(draw_text, ", "),
            [n_text, color_text] = String.split(cube_text, " "),
            into: %{} do
              {color_text, String.to_integer(n_text)}
        end
      end
    {String.to_integer(id_text), draws}
  end

  def draw_possible?(draw, bag) do
    Enum.all?(draw, fn {color, n} -> Map.get(bag, color, 0) >= n end)
  end

  def draws_possible?(draws, bag) do
    Enum.all?(draws, fn draw -> draw_possible?(draw, bag) end)
  end

  def min_bag(draws) do
    for draw <- draws, reduce: %{} do
      acc -> Map.merge(acc, draw, fn _k, v1, v2 -> max(v1, v2) end)
    end
  end

  def bag_power(bag) do
    bag |> Map.values() |> Enum.product()
  end

  def problem1(input \\ "data/day02.txt", type \\ :file) do
    bag = %{"red" => 12, "green" => 13, "blue" => 14}
    for line <- read_input(input, type),
        {id, draws} = parse_line(line),
        draws_possible?(draws, bag),
        reduce: 0 do
          acc -> acc + id
    end
  end

  def problem2(input \\ "data/day02.txt", type \\ :file) do
    for line <- read_input(input, type),
        {_, draws} = parse_line(line),
        bag = min_bag(draws),
        power = bag_power(bag),
        reduce: 0 do
          acc -> acc + power
    end
  end
end
