defmodule Day04 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def parse_line(line) do
    [_, id_text, winners_text, draw_text] = Regex.run(~r/^Card\s+(\d+)\: (.*) \| (.*)$/, line)
    winners = for x <- String.split(winners_text), do: String.to_integer(x)
    draw = for x <- String.split(draw_text), do: String.to_integer(x)
    {String.to_integer(id_text), winners, draw}
  end

  def score_card(winners, draw) do
    n_winners = MapSet.intersection(MapSet.new(winners), MapSet.new(draw)) |> MapSet.size()
    if n_winners == 0, do: 0, else: Integer.pow(2, n_winners - 1)
  end

  def update_card_count(card_map) do
    for id <- Enum.sort(Map.keys(card_map)),
        {_, winners, draw} = Map.get(card_map, id),
        n_winners = MapSet.intersection(MapSet.new(winners), MapSet.new(draw)) |> MapSet.size(),
        n_winners > 0,
        i <- (id + 1)..(id + n_winners),
        i <= Enum.max(Map.keys(card_map)),
        reduce: card_map do
      acc ->
        {n_to_add, _, _} = Map.get(acc, id)
        Map.update!(acc, i, fn {n, winners, draw} -> {n + n_to_add, winners, draw} end)
    end
  end

  def problem1(input \\ "data/day04.txt", type \\ :file) do
    for line <- Day04.read_input(input, type),
        {_, winners, draw} = parse_line(line),
        score = score_card(winners, draw),
        reduce: 0 do
      acc -> acc + score
    end
  end

  def problem2(input \\ "data/day04.txt", type \\ :file) do
    initial_card_map =
      for line <- Day04.read_input(input, type),
          {id, winners, draw} = parse_line(line),
          into: %{} do
        {id, {1, winners, draw}}
      end
    for {n, _, _} <- Map.values(update_card_count(initial_card_map)), reduce: 0 do
      acc -> acc + n
    end
  end
end
