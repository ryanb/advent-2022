defmodule Day04.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(&contains?/1)
    |> length
  end

  def contains?(line) do
    [r1, r2] = line |> String.split(",") |> Enum.map(&nums/1)
    [r1a, r1b] = r1
    [r2a, r2b] = r2
    (r1a <= r2a && r1b >= r2b) || (r2a <= r1a && r2b >= r1b)
  end

  def nums(str) do
    str |> String.split("-") |> Enum.map(&String.to_integer/1)
  end
end

defmodule Day04.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(&contains?/1)
    |> length
  end

  def contains?(line) do
    [r1, r2] = line |> String.split(",") |> Enum.map(&Day04.Part1.nums/1)
    [r1a, r1b] = r1
    [r2a, r2b] = r2
    r1a <= r2b && r1b >= r2a
  end
end

defmodule Mix.Tasks.Day04 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day04-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day04.Part2.solve(input))
  end
end
