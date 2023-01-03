defmodule Day20.Part1 do
  @targets [1000, 2000, 3000]

  def solve(input) do
    input
    |> parse_input()
    |> move_values(0)
    |> Enum.map(fn {value, _index} -> value end)
    |> target_values()
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {String.to_integer(value), index} end)
  end

  def move_values(values, index) do
    if index >= length(values) do
      values
    else
      values
      |> move_value(index)
      |> move_values(index + 1)
    end
  end

  def move_value(values, index) do
    {{value, _index}, current_index} =
      values
      |> Enum.with_index()
      |> Enum.find(fn {{_value, i}, _current_index} -> i == index end)

    new_index = new_index(values, current_index, value)

    values
    |> List.delete_at(current_index)
    |> List.insert_at(new_index, {value, index})
  end

  def new_index(values, index, value) do
    result = rem(index + value, length(values) - 1)

    if result <= 0 do
      length(values) - 1 + result
    else
      result
    end
  end

  def target_values(values) do
    zero_index = Enum.find_index(values, fn value -> value == 0 end)
    length = length(values)
    Enum.map(@targets, fn target -> Enum.at(values, rem(zero_index + target, length)) end)
  end
end

defmodule Day20.Part2 do
end

defmodule Mix.Tasks.Day20 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day20-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day20.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day20.Part2.solve(input))
  end
end
