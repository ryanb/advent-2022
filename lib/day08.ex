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
      Enum.slice(trees, 0, index) |> Enum.reverse(),
      Enum.slice(trees, index + 1, length(trees) - 1)
    ]
  end
end

defmodule Day08.Part2 do
  def solve(input) do
    input |> Day08.Part1.parse_rows() |> highest_scenic_score()
  end

  def highest_scenic_score(tree_rows) do
    tree_rows
    |> Enum.with_index()
    |> Enum.map(fn {trees, y} ->
      trees
      |> Enum.with_index()
      |> Enum.map(fn {_tree, x} ->
        scenic_score(tree_rows, x: x, y: y)
      end)
    end)
    |> List.flatten()
    |> Enum.max()
  end

  def scenic_score(tree_rows, x: x, y: y) do
    tree = tree_rows |> Enum.fetch!(y) |> Enum.fetch!(x)

    Day08.Part1.surrounding_trees(tree_rows, x: x, y: y)
    |> Enum.map(fn trees -> visible_trees_from_tree(tree, trees) end)
    |> Enum.reduce(fn count, score -> count * score end)
  end

  def visible_trees_from_tree(tree, trees) do
    Enum.reduce_while(trees, 0, fn visible_tree, count ->
      if visible_tree >= tree do
        {:halt, count + 1}
      else
        {:cont, count + 1}
      end
    end)
  end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    {:ok, input} = File.read("inputs/day08-input.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day08.Part1.solve(input))
    IO.puts("")
    IO.puts("--- Part 2 ---")
    IO.puts(Day08.Part2.solve(input))
  end
end
