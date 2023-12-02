defmodule Day01 do
  def read_input(input, type \\ :file) do
    Helpers.file_or_io(input, type)
    |> String.trim
    |> String.split("\n")
  end

  def calibration_values(line) do
    for ch <- String.graphemes(line),
        parsed_int = Integer.parse(ch),
        parsed_int != :error,
        {x, _} = parsed_int,
        reduce: {nil, nil} do
      acc ->
        case acc do
          {nil, nil} -> {x, x}
          {first, _} -> {first, x}
        end
    end
  end

  def calibration_value_text_forward(line) do
    case line do
      "" -> nil
      "one" <> _ -> 1
      "two" <> _ -> 2
      "three" <> _ -> 3
      "four" <> _ -> 4
      "five" <> _ -> 5
      "six" <> _ -> 6
      "seven" <> _ -> 7
      "eight" <> _ -> 8
      "nine" <> _ -> 9
      _ ->
        {ch, rest} = String.split_at(line, 1)
        case Integer.parse(ch) do
          {int, _} -> int
          :error -> calibration_value_text_forward(rest)
        end
    end
  end

  def calibration_value_text_backward(line) do
    case line do
      "" -> nil
      "eno" <> _ -> 1
      "owt" <> _ -> 2
      "eerht" <> _ -> 3
      "ruof" <> _ -> 4
      "evif" <> _ -> 5
      "xis" <> _ -> 6
      "neves" <> _ -> 7
      "thgie" <> _ -> 8
      "enin" <> _ -> 9
      _ ->
        {ch, rest} = String.split_at(line, 1)
        case Integer.parse(ch) do
          {int, _} -> int
          :error -> calibration_value_text_backward(rest)
        end
    end
  end

  def calibration_value_text(line) do
    {calibration_value_text_forward(line), calibration_value_text_backward(String.reverse(line))}
  end

  def problem1(input \\ "data/day01.txt", type \\ :file) do
    for line <- read_input(input, type),
        {x, y} = calibration_values(line),
        reduce: 0 do
      acc -> acc + 10 * x + y
    end
  end

  def problem2(input \\ "data/day01.txt", type \\ :file) do
    for line <- read_input(input, type),
        {x, y} = calibration_value_text(line),
        reduce: 0 do
      acc -> acc + 10 * x + y
    end
  end
end
