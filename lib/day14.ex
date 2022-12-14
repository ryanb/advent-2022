defmodule Day14.Part1 do
  @sand_spawner {500, 0}
  @y_limit 1000

  def solve(input) do
    input
    |> parse_input()
    |> fill_sand()
    |> count_sand()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.flatten()
    |> Map.new(fn point -> {point, :rock} end)
  end

  def parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&parse_point/1)
    # Pair up each rock point
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&parse_rocks/1)
  end

  def parse_point(point_str) do
    point_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_rocks([{x1, y1}, {x2, y2}]) do
    Enum.map(x1..x2, fn x ->
      Enum.map(y1..y2, fn y ->
        {x, y}
      end)
    end)
    |> List.flatten()
  end

  def fill_sand(blocks) do
    point = drop_sand(@sand_spawner, blocks)

    if point == :halt do
      blocks
    else
      blocks |> Map.put(point, :sand) |> fill_sand()
    end
  end

  def drop_sand(point, blocks) do
    next_point = step_sand(point, blocks)

    case next_point do
      :halt -> next_point
      :settle -> point
      _ -> drop_sand(next_point, blocks)
    end
  end

  def step_sand({x, y}, blocks) do
    cond do
      y > @y_limit -> :halt
      !Map.has_key?(blocks, {x, y + 1}) -> {x, y + 1}
      !Map.has_key?(blocks, {x - 1, y + 1}) -> {x - 1, y + 1}
      !Map.has_key?(blocks, {x + 1, y + 1}) -> {x + 1, y + 1}
      true -> :settle
    end
  end

  def count_sand(blocks) do
    blocks |> Enum.filter(fn {_point, value} -> value == :sand end) |> length()
  end
end

defmodule Day14.Part2 do
  @sand_spawner {500, 0}
  @floor_offset 2

  def solve(input) do
    input
    |> Day14.Part1.parse_input()
    |> mark_floor()
    |> fill_sand()
    |> Day14.Part1.count_sand()
  end

  def mark_floor(blocks) do
    max_y = Enum.map(blocks, fn {{_x, y}, _type} -> y end) |> Enum.max()
    Map.put(blocks, :floor, max_y + @floor_offset)
  end

  def fill_sand(blocks) do
    point = drop_sand(@sand_spawner, blocks)

    if point == :halt do
      blocks
    else
      blocks |> Map.put(point, :sand) |> fill_sand()
    end
  end

  def drop_sand(point, blocks) do
    next_point = step_sand(point, blocks)

    case next_point do
      :halt -> next_point
      :settle -> point
      _ -> drop_sand(next_point, blocks)
    end
  end

  def step_sand({x, y}, blocks) do
    cond do
      Map.has_key?(blocks, {x, y}) -> :halt
      y + 1 >= blocks.floor -> :settle
      !Map.has_key?(blocks, {x, y + 1}) -> {x, y + 1}
      !Map.has_key?(blocks, {x - 1, y + 1}) -> {x - 1, y + 1}
      !Map.has_key?(blocks, {x + 1, y + 1}) -> {x + 1, y + 1}
      true -> :settle
    end
  end
end

defmodule Mix.Tasks.Day14 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day14-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day14.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day14.Part2.solve(input))
  end
end
