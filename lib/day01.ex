defmodule Day01.Part1 do
  def solve(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&sum_lines/1)
    |> Enum.max()
  end

  def sum_lines(sub_input) do
    sub_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end

defmodule Day01.Part2 do
  def solve(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&Day01.Part1.sum_lines/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day01-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day01.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day01.Part2.solve(input))
  end
end
