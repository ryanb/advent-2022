defmodule Day02.Part1 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  def score(line) do
    score_win(line) + score_bonus(String.slice(line, 2, 1))
  end

  def score_win(line) do
    case line do
      # Lose
      x when x in ["A Z", "B X", "C Y"] -> 0
      # Draw
      x when x in ["A X", "B Y", "C Z"] -> 3
      # Win
      x when x in ["A Y", "B Z", "C X"] -> 6
      # Unknown
      _ -> throw("Unknown line #{line}")
    end
  end

  def score_bonus(char) do
    case char do
      "X" -> 1
      "Y" -> 2
      "Z" -> 3
      _ -> throw("Unknown character #{char}")
    end
  end
end

defmodule Day02.Part2 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  def score(line) do
    case line do
      # Lose
      "A X" -> 0 + 3
      "B X" -> 0 + 1
      "C X" -> 0 + 2
      # Draw
      "A Y" -> 3 + 1
      "B Y" -> 3 + 2
      "C Y" -> 3 + 3
      # Win
      "A Z" -> 6 + 2
      "B Z" -> 6 + 3
      "C Z" -> 6 + 1
      # Unknown
      _ -> throw("Unknown line #{line}")
    end
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day02-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day02.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day02.Part2.solve(input))
  end
end
