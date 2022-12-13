defmodule Day13.Part1 do
  def solve(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)
    # |> Enum.map(&inspect_pair/1)
    |> Enum.with_index()
    |> Enum.filter(fn {[left, right], _index} -> pair_in_order?(left, right) end)
    |> Enum.map(fn {_value, index} -> index + 1 end)
    |> Enum.sum()
  end

  def parse_pair(pair) do
    pair |> String.split("\n", trim: true) |> Enum.map(&parse_packet/1)
  end

  def parse_packet(packet_str) do
    tokens = Regex.scan(~r/\[|\]|\d+/, packet_str) |> List.flatten()
    {packet, _remaining_tokens} = append_tokens([], tl(tokens))
    packet
  end

  def append_tokens(list, tokens) do
    token = hd(tokens)

    case token do
      "[" ->
        {inner_list, remaining_tokens} = append_tokens([], tl(tokens))
        append_tokens(list ++ [inner_list], remaining_tokens)

      "]" ->
        {list, tl(tokens)}

      _ ->
        append_tokens(list ++ [String.to_integer(token)], tl(tokens))
    end
  end

  def inspect_pair([left, right]) do
    IO.inspect(left, charlists: :as_list, limit: :infinity, width: :infinity, label: "left")
    IO.inspect(right, charlists: :as_list, limit: :infinity, width: :infinity, label: "right")
    IO.inspect(pair_in_order?(left, right), label: "in order")
    IO.puts("")
    [left, right]
  end

  def pair_in_order?(left_packet, right_packet) do
    left =
      if left_packet == [] do
        nil
      else
        hd(left_packet)
      end

    right =
      if right_packet == [] do
        nil
      else
        hd(right_packet)
      end

    cond do
      left == nil -> true
      right == nil -> false
      left == [] && right == [] -> pair_in_order?(tl(left_packet), tl(right_packet))
      is_list(left) && is_list(right) -> pair_in_order?(left, right)
      is_list(left) && !is_list(right) -> pair_in_order?(left, [right])
      !is_list(left) && is_list(right) -> pair_in_order?([left], right)
      left < right -> true
      left > right -> false
      true -> pair_in_order?(tl(left_packet), tl(right_packet))
    end
  end
end

defmodule Day13.Part2 do
end

defmodule Mix.Tasks.Day13 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day13-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day13.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day13.Part2.solve(input))
  end
end
