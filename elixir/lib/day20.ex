defmodule Day20 do
  def read_input(input, type \\ :file) do
    lines = Helpers.file_or_io(input, type) |> String.trim() |> String.split("\n")
    board =
      for line <- lines,
          [from_text, to_text] = String.split(line, " -> "),
          to = String.split(to_text, ", "),
          into: %{} do
        cond do
          from_text == "broadcaster" ->
            {
              "broadcaster",
              {:broadcaster, to, nil},
            }
          String.first(from_text) == "%" ->
            {
              String.slice(from_text, 1..(String.length(from_text) - 1)),
              {:flipflop, to, :off},
            }
          String.first(from_text) == "&" ->
            {
              String.slice(from_text, 1..(String.length(from_text) - 1)),
              {:conjunction, to, %{}},
            }
        end
      end

    # add conjunction state - :low for all inputs
    conjunctions =
      for {node, {type, _, _}} <- board, type == :conjunction, into: MapSet.new() do
        node
      end

    for {node, {_, to_all, _}} <- board,
        to <- to_all,
        MapSet.member?(conjunctions, to),
        reduce: board do
      board ->
        Map.update!(board, to, fn x ->
          put_elem(x, 2, Map.put(elem(x, 2), node, :low))
        end)
    end
  end

  def parse_pulses(board, pulses, pulse_count) do
    next_pulse_count = pulses
    |> Enum.group_by(fn {pulse_type, _, _} -> pulse_type end)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> Map.new()
    |> Map.merge(pulse_count, fn _, v1, v2 -> v1 + v2 end)

    {next_pulses, next_board} =
      for {pulse_type, pulse_from, pulse_to} <- pulses,
          Map.has_key?(board, pulse_to),
          {target_type, target_to, state} = Map.fetch!(board, pulse_to),
          next_pulse_to <- target_to,
          reduce: {[], board} do
        {next_pulses, next_board} ->
          case {pulse_type, target_type, state} do
            {_, :broadcaster, nil} ->
              {[{pulse_type, pulse_to, next_pulse_to} | next_pulses], next_board}
            {:high, :flipflop, _} ->
              {next_pulses, next_board}
            {:low, :flipflop, :off} ->
              {
                [{:high, pulse_to, next_pulse_to} | next_pulses],
                Map.update!(next_board, pulse_to, fn x -> put_elem(x, 2, :on) end),
              }
            {:low, :flipflop, :on} ->
              {
                [{:low, pulse_to, next_pulse_to} | next_pulses],
                Map.update!(next_board, pulse_to, fn x -> put_elem(x, 2, :off) end),
              }
            {_, :conjunction, _} ->
              new_state = Map.update!(state, pulse_from, fn _ -> pulse_type end)
              new_pulse_type = if Enum.all?(Map.values(new_state), fn x -> x == :high end), do: :low, else: :high
              {
                [{new_pulse_type, pulse_to, next_pulse_to} | next_pulses],
                Map.update!(next_board, pulse_to, fn x -> put_elem(x, 2, new_state) end),
              }
          end
      end
    case next_pulses do
      [] -> {next_board, next_pulse_count}
      _ -> parse_pulses(next_board, next_pulses, next_pulse_count)
    end
  end

  def push_button(board, times) do
    for _ <- 1..times//1, reduce: {board, %{low: 0, high: 0}} do
      {next_board, pulse_count} ->
        parse_pulses(next_board, [{:low, "button", "broadcaster"}], pulse_count)
    end
  end

  def score_pulse_count(pulse_count) do
    pulse_count[:high] * pulse_count[:low]
  end

  def problem1(input \\ "data/day20.txt", type \\ :file) do
    read_input(input, type)
    |> push_button(1000)
    |> elem(1)
    |> score_pulse_count()
  end

  def problem2(input \\ "data/day20.txt", type \\ :file) do
    read_input(input, type)
  end
end
