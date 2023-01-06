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
    [key, operation_str] = String.split(line, ": ")

    if String.contains?(operation_str, " ") do
      operation = operation_str |> String.split(" ") |> List.to_tuple()
      Map.put(monkeys, key, operation)
    else
      Map.put(monkeys, key, String.to_integer(operation_str))
    end
  end

  def evaluate(monkeys, key) do
    case monkeys[key] do
      {a, "+", b} -> evaluate(monkeys, a) + evaluate(monkeys, b)
      {a, "-", b} -> evaluate(monkeys, a) - evaluate(monkeys, b)
      {a, "*", b} -> evaluate(monkeys, a) * evaluate(monkeys, b)
      {a, "/", b} -> round(evaluate(monkeys, a) / evaluate(monkeys, b))
      _ -> monkeys[key]
    end
  end
end

defmodule Day21.Part2 do
  @human "humn"

  def solve(input) do
    input
    |> Day21.Part1.parse_input()
    |> human_value()
  end

  def human_value(monkeys) do
    path_with_root = monkeys |> path_to_human("root")
    value = non_human_value(monkeys, path_with_root)
    path = tl(path_with_root)
    human_value_for_path(path, monkeys, value)
  end

  def path_to_human(_monkeys, @human) do
    [@human]
  end

  def path_to_human(monkeys, key) do
    case monkeys[key] do
      {a, _operator, b} ->
        path = path_to_human(monkeys, a) || path_to_human(monkeys, b)

        if path do
          [key | path]
        else
          nil
        end

      _ ->
        nil
    end
  end

  def human_value_for_path([@human], _monkeys, value) do
    value
  end

  def human_value_for_path(path, monkeys, value) do
    operation = flatten_operation(monkeys, path)
    next_value = reverse_operation(operation, value)
    human_value_for_path(tl(path), monkeys, next_value)
  end

  def non_human_value(monkeys, path) do
    case flatten_operation(monkeys, path) do
      {:humn, _operator, value} -> value
      {value, _operator, :humn} -> value
      _ -> throw("Unable to find value for path #{inspect(path)}")
    end
  end

  def flatten_operation(monkeys, path) do
    operation = monkeys[hd(path)]
    human_key = path |> tl() |> hd()

    case operation do
      {non_human_key, operator, ^human_key} ->
        {Day21.Part1.evaluate(monkeys, non_human_key), operator, :humn}

      {^human_key, operator, non_human_key} ->
        {:humn, operator, Day21.Part1.evaluate(monkeys, non_human_key)}

      _ ->
        throw("Operation #{inspect(operation)} does not have #{human_key}")
    end
  end

  def reverse_operation(operation, value) do
    case operation do
      {:humn, "+", a} -> value - a
      {a, "+", :humn} -> value - a
      {:humn, "-", a} -> value + a
      {a, "-", :humn} -> a - value
      {:humn, "*", a} -> round(value / a)
      {a, "*", :humn} -> round(value / a)
      {:humn, "/", a} -> value * a
      {a, "/", :humn} -> round(a / value)
      _ -> throw("Unexpected operation: #{inspect(operation)}")
    end
  end
end

defmodule Mix.Tasks.Day21 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day21-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day21.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day21.Part2.solve(input))
  end
end
