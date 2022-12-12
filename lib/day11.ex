defmodule Day11.Part1 do
  @rounds 20

  def solve(input) do
    monkeys = input |> parse_monkeys()

    turns = monkeys |> Map.keys() |> Enum.sort() |> List.duplicate(@rounds) |> List.flatten()

    turns
    |> Enum.reduce(monkeys, &take_turn/2)
    |> Enum.map(fn {_key, monkey} -> monkey.inspections end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> List.to_tuple()
    |> Tuple.product()
  end

  def parse_monkeys(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_monkey/1)
    |> Enum.with_index()
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Map.new()
  end

  def parse_monkey(monkey_str) do
    %{
      items: parse_items(monkey_str),
      operation: parse_operation(monkey_str),
      divisible: parse_divisible(monkey_str),
      if_true: parse_if_true(monkey_str),
      if_false: parse_if_false(monkey_str),
      inspections: 0
    }
  end

  def parse_items(monkey_str) do
    [_, items_str] = Regex.run(~r/Starting items: (.+)/, monkey_str)
    items_str |> String.split(", ") |> Enum.map(&String.to_integer/1)
  end

  def parse_operation(monkey_str) do
    [_, operation_str] = Regex.run(~r/Operation: new = (.+)/, monkey_str)
    operation_str
  end

  def parse_divisible(monkey_str) do
    [_, divisible_str] = Regex.run(~r/Test: divisible by (.+)/, monkey_str)
    String.to_integer(divisible_str)
  end

  def parse_if_true(monkey_str) do
    [_, if_true_str] = Regex.run(~r/If true: throw to monkey (.+)/, monkey_str)
    String.to_integer(if_true_str)
  end

  def parse_if_false(monkey_str) do
    [_, if_false_str] = Regex.run(~r/If false: throw to monkey (.+)/, monkey_str)
    String.to_integer(if_false_str)
  end

  def take_turn(index, monkeys) do
    monkey = monkeys[index]

    monkey.items
    |> Enum.map(&build_item_transition(&1, monkey))
    |> Enum.reduce(monkeys, &apply_item_transition/2)
    |> Map.put(index, %{
      monkey
      | items: [],
        inspections: monkey.inspections + length(monkey.items)
    })
  end

  def build_item_transition(item, monkey) do
    new_item = inspect_item(item, monkey.operation)

    %{
      item: new_item,
      recipient: item_recipient(new_item, monkey)
    }
  end

  def inspect_item(item, operation) do
    new_item = item |> perform_operation(operation)
    floor(new_item / 3)
  end

  def perform_operation(item, operation) do
    [x_str, operator, y_str] =
      operation |> String.replace("old", to_string(item)) |> String.split(" ")

    x = String.to_integer(x_str)
    y = String.to_integer(y_str)

    case operator do
      "+" -> x + y
      "-" -> x - y
      "*" -> x * y
      "/" -> floor(x / y)
      _ -> throw("Unknown operator #{operator}")
    end
  end

  def item_recipient(item, monkey) do
    if rem(item, monkey.divisible) == 0 do
      monkey.if_true
    else
      monkey.if_false
    end
  end

  def apply_item_transition(item_transition, monkeys) do
    monkey = monkeys[item_transition.recipient]
    item = rem(item_transition.item, common_multiple(monkeys))

    Map.put(monkeys, item_transition.recipient, %{
      monkey
      | items: monkey.items ++ [item]
    })
  end

  def common_multiple(monkeys) do
    monkeys
    |> Enum.map(fn {_key, monkey} -> monkey.divisible end)
    |> List.to_tuple()
    |> Tuple.product()
  end
end

defmodule Day11.Part2 do
  @rounds 10000

  def solve(input) do
    monkeys = input |> Day11.Part1.parse_monkeys()
    turns = monkeys |> Map.keys() |> Enum.sort() |> List.duplicate(@rounds) |> List.flatten()

    turns
    |> Enum.reduce(monkeys, &take_turn/2)
    |> Enum.map(fn {_key, monkey} -> monkey.inspections end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> List.to_tuple()
    |> Tuple.product()
  end

  def take_turn(index, monkeys) do
    monkey = monkeys[index]

    monkey.items
    |> Enum.map(&build_item_transition(&1, monkey))
    |> Enum.reduce(monkeys, &Day11.Part1.apply_item_transition/2)
    |> Map.put(index, %{
      monkey
      | items: [],
        inspections: monkey.inspections + length(monkey.items)
    })
  end

  def build_item_transition(item, monkey) do
    new_item = inspect_item(item, monkey.operation)

    %{
      item: new_item,
      recipient: Day11.Part1.item_recipient(new_item, monkey)
    }
  end

  def inspect_item(item, operation) do
    item |> Day11.Part1.perform_operation(operation)
  end
end

defmodule Mix.Tasks.Day11 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day11-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day11.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day11.Part2.solve(input))
  end
end
