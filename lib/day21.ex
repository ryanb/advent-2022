defmodule Day21.Part1 do
  def solve(input) do
    input
    |> parse_input()
    |> evaluate("root")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_line/2)
  end

  def parse_line(line, monkeys) do
    [name, operation] = String.split(line, ": ")

    if String.contains?(operation, " ") do
      Map.put(monkeys, name, String.split(operation, " "))
    else
      Map.put(monkeys, name, String.to_integer(operation))
    end
  end

  def evaluate(monkeys, name) do
    case monkeys[name] do
      [a, "+", b] -> evaluate(monkeys, a) + evaluate(monkeys, b)
      [a, "-", b] -> evaluate(monkeys, a) - evaluate(monkeys, b)
      [a, "*", b] -> evaluate(monkeys, a) * evaluate(monkeys, b)
      [a, "/", b] -> round(evaluate(monkeys, a) / evaluate(monkeys, b))
      _ -> monkeys[name]
    end
  end
end

defmodule Day21.Part2 do
end

defmodule Mix.Tasks.Day21 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day21-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day21.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day21.Part2.solve(input))
  end
end
