defmodule Day06.Part1 do
  @packet_size 4

  def solve(input) do
    Enum.find(0..String.length(input), fn i -> find(input, i) end) + @packet_size
  end

  def find(input, i) do
    result =
      input
      |> String.slice(i, @packet_size)
      |> String.graphemes()
      |> Enum.uniq()

    length(result) == @packet_size
  end
end

defmodule Day06.Part2 do
  @packet_size 14

  def solve(input) do
    Enum.find(0..String.length(input), fn i -> find(input, i) end) + @packet_size
  end

  def find(input, i) do
    result =
      input
      |> String.slice(i, @packet_size)
      |> String.graphemes()
      |> Enum.uniq()

    length(result) == @packet_size
  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day06-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day06.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day06.Part2.solve(input))
  end
end
