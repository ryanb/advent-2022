defmodule Day08.Part1 do
  def solve(input) do
    input |> parse_rows() |> count_visible()
  end

  def parse_rows(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&parse_row/1)
  end

  def parse_row(row) do
    row |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def count_visible(tree_rows) do
    tree_rows
    |> Enum.with_index()
    |> Enum.reduce(0, fn {trees, y}, count ->
      count + count_visible_for_row(tree_rows, trees: trees, y: y)
    end)
  end

  def count_visible_for_row(tree_rows, trees: trees, y: y) do
    trees
    |> Enum.with_index()
    |> Enum.reduce(0, fn {_tree, x}, count ->
      if is_visible?(tree_rows, x: x, y: y) do
        count + 1
      else
        count
      end
    end)
  end

  def is_visible?(tree_rows, x: x, y: y) do
    tree = tree_rows |> Enum.fetch!(y) |> Enum.fetch!(x)

    surrounding_trees(tree_rows, x: x, y: y)
    |> Enum.any?(fn trees ->
      Enum.all?(trees, fn surrounding_tree -> surrounding_tree < tree end)
    end)
  end

  def surrounding_trees(tree_rows, x: x, y: y) do
    horizontals = Enum.fetch!(tree_rows, y) |> split_row(x)
    verticals = tree_rows |> Enum.zip_with(& &1) |> Enum.fetch!(x) |> split_row(y)
    horizontals ++ verticals
  end

  def split_row(trees, index) do
    [
      Enum.slice(trees, 0, index),
      Enum.slice(trees, index + 1, length(trees) - 1)
    ]
  end
end

defmodule Day08.Part2 do
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day08-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day08.Part1.solve(input))
    # IO.puts("")
    # IO.puts("--- Part 2 ---")
    # IO.puts(Day08.Part2.solve(input))
  end
end
