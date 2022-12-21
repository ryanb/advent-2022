defmodule Day18.Part1 do
  def solve(input) do
    input |> parse_input() |> surface_area()
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  def surface_area(points) do
    length(points) * 6 - count_touching(points)
  end

  def count_touching(points) do
    Enum.reduce(points, 0, fn point_1, acc_1 ->
      Enum.reduce(points, acc_1, fn point_2, acc_2 ->
        if touching?(point_1, point_2) do
          acc_2 + 1
        else
          acc_2
        end
      end)
    end)
  end

  def touching?({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2) == 1
  end
end

defmodule Day18.Part2 do
end

defmodule Mix.Tasks.Day18 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day18-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day18.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day18.Part2.solve(input))
  end
end
