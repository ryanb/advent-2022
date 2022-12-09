defmodule Day09.Part1 do
  def solve(input) do
    # Track tails in a list so we have record of the previous tail
    # The first tail is the current tail
    state = %{head: {0, 0}, tails: [{0, 0}]}

    input
    |> parse_input()
    |> Enum.reduce(state, &move_rope/2)
    |> Map.fetch!(:tails)
    |> Enum.uniq()
    |> length
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_input_line/1)
    |> List.flatten()
  end

  def parse_input_line(line) do
    [direction_str, amount] = String.split(line, " ", trim: true)
    direction = parse_direction(direction_str)
    Enum.map(1..String.to_integer(amount), fn _ -> direction end)
  end

  def parse_direction(direction_str) do
    case direction_str do
      "L" -> :left
      "R" -> :right
      "U" -> :up
      "D" -> :down
      _ -> throw("Unknown direction #{direction_str}")
    end
  end

  def move_rope(direction, state) do
    state |> move_head(direction) |> move_tail()
  end

  def move_head(state, direction) do
    {x, y} = state.head

    new_head =
      case direction do
        :left -> {x - 1, y}
        :right -> {x + 1, y}
        :up -> {x, y + 1}
        :down -> {x, y - 1}
        _ -> throw("Unknown direction #{direction}")
      end

    %{state | head: new_head}
  end

  def move_tail(state) do
    if is_touching?(head: state.head, tail: hd(state.tails)) do
      state
    else
      {head_x, head_y} = state.head
      {tail_x, tail_y} = hd(state.tails)
      new_tail = {step_towards(tail_x, head_x), step_towards(tail_y, head_y)}
      %{state | tails: [new_tail | state.tails]}
    end
  end

  def step_towards(from, to) do
    cond do
      from == to -> from
      from < to -> from + 1
      from > to -> from - 1
    end
  end

  def is_touching?(head: head, tail: tail) do
    {head_x, head_y} = head
    {tail_x, tail_y} = tail
    abs(head_x - tail_x) <= 1 && abs(head_y - tail_y) <= 1
  end
end

defmodule Day09.Part2 do
end

defmodule Mix.Tasks.Day09 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day09-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day09.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day09.Part2.solve(input))
  end
end
