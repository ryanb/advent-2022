defmodule Day03.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  def priority(line) do
    half = (String.length(line) / 2) |> trunc()
    rucksack_1 = String.slice(line, 0, half) |> String.to_charlist() |> MapSet.new()
    rucksack_2 = String.slice(line, half, half) |> String.to_charlist() |> MapSet.new()
    char = MapSet.intersection(rucksack_1, rucksack_2) |> MapSet.to_list() |> hd
    priorities = Enum.to_list(hd('a')..hd('z')) ++ Enum.to_list(hd('A')..hd('Z'))
    Enum.find_index(priorities, fn c -> c == char end) + 1
  end
end

defmodule Day03.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  def priority(elves) do
    sets = Enum.map(elves, fn elf -> String.to_charlist(elf) |> MapSet.new() end)

    char = Enum.reduce(tl(sets), hd(sets), &MapSet.intersection/2) |> MapSet.to_list() |> hd

    priorities = Enum.to_list(hd('a')..hd('z')) ++ Enum.to_list(hd('A')..hd('Z'))
    Enum.find_index(priorities, fn c -> c == char end) + 1
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day03-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day03.Part2.solve(input))
  end
end
