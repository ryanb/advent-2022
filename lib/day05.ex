defmodule Day05.Part1 do
  def solve(input) do
    [plan, commands] = input |> String.split("\n\n", trim: true)
    stacks = parse_stacks(plan)

    commands
    |> String.split("\n", trim: true)
    |> Enum.reduce(stacks, &run_command/2)
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def parse_stacks(plan) do
    plan
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.reverse()
    |> Enum.zip_with(& &1)
    |> Enum.chunk_every(4)
    |> Enum.map(&parse_stack/1)
  end

  def parse_stack(stack) do
    stack |> Enum.at(1) |> tl |> Enum.reject(fn str -> str == " " end) |> Enum.reverse()
  end

  def run_command(command, stacks) do
    [amount, from, to] =
      Regex.run(~r/move (\d+) from (\d+) to (\d+)/, command)
      |> tl
      |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..amount, stacks, fn _, stacks -> move(stacks, from - 1, to - 1) end)
  end

  def move(stacks, from, to) do
    from_stack = stacks |> Enum.fetch!(from)
    to_stack = stacks |> Enum.fetch!(to)

    stacks
    |> List.replace_at(from, tl(from_stack))
    |> List.replace_at(to, [hd(from_stack) | to_stack])
  end
end

defmodule Day05.Part2 do
  def solve(input) do
    [plan, commands] = input |> String.split("\n\n", trim: true)
    stacks = Day05.Part1.parse_stacks(plan)

    commands
    |> String.split("\n", trim: true)
    |> Enum.reduce(stacks, &run_command/2)
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def run_command(command, stacks) do
    [amount, from, to] =
      Regex.run(~r/move (\d+) from (\d+) to (\d+)/, command)
      |> tl
      |> Enum.map(&String.to_integer/1)

    from_stack = stacks |> Enum.fetch!(from - 1)
    to_stack = stacks |> Enum.fetch!(to - 1)
    new_from_stack = from_stack |> Enum.slice(amount, length(from_stack) - amount)
    result = from_stack |> Enum.slice(0..(amount - 1))

    stacks
    |> List.replace_at(from - 1, new_from_stack)
    |> List.replace_at(to - 1, result ++ to_stack)
  end
end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day05-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day05.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day05.Part2.solve(input))
  end
end
