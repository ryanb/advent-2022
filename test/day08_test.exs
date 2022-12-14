defmodule Day08Test do
  use ExUnit.Case

  @example_input """
  30373
  25512
  65332
  33549
  35390
  """

  test "solves example input for part 1" do
    assert Day08.Part1.solve(@example_input) == 21
  end

  describe ".parse_rows" do
    test "returns two dimentional list" do
      input = """
      12
      34
      """

      expected = [
        [1, 2],
        [3, 4]
      ]

      assert Day08.Part1.parse_rows(input) == expected
    end
  end

  describe "count_visible" do
    test "returns number of trees that are visible from the edge" do
      tree_rows = [
        [2, 2, 2],
        [2, 2, 2],
        [2, 2, 2]
      ]

      assert Day08.Part1.count_visible(tree_rows) == 8
    end
  end

  describe ".is_visible?" do
    test "returns false if trees are taller in all directions" do
      tree_rows = [
        [2, 2, 2],
        [2, 2, 2],
        [2, 2, 2]
      ]

      assert Day08.Part1.is_visible?(tree_rows, x: 1, y: 1) == false
      assert Day08.Part1.is_visible?(tree_rows, x: 0, y: 1) == true
    end
  end

  describe ".surrounding_trees" do
    test "returns lists surrounding x and y index" do
      tree_rows = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]

      expected = [
        [4],
        [6],
        [2],
        [8]
      ]

      assert Day08.Part1.surrounding_trees(tree_rows, x: 1, y: 1) == expected
    end
  end

  describe ".split_row" do
    test "returns two lists around given index" do
      assert Day08.Part1.split_row([1, 2, 3], 0) == [[], [2, 3]]
      assert Day08.Part1.split_row([1, 2, 3], 1) == [[1], [3]]
      assert Day08.Part1.split_row([1, 2, 3], 2) == [[2, 1], []]
    end
  end

  # Part 2

  test "solves example input for part 2" do
    assert Day08.Part2.solve(@example_input) == 8
  end

  describe ".highest_scenic_score" do
    test "returns highest score of a grid of trees" do
      tree_rows = [
        [1, 1, 1, 1, 1, 1],
        [1, 2, 3, 2, 3, 1],
        [1, 1, 1, 1, 1, 1]
      ]

      assert Day08.Part2.highest_scenic_score(tree_rows) == 4
    end
  end

  describe ".scenic_score" do
    test "returns number of visible trees multiplied together" do
      tree_rows = [
        [1, 1, 1, 1, 1, 1],
        [1, 2, 3, 2, 3, 1],
        [1, 1, 1, 1, 1, 1]
      ]

      assert Day08.Part2.scenic_score(tree_rows, x: 2, y: 1) == 4
    end
  end

  describe ".visible_trees_from_tree" do
    test "returns number of visible trees in a row" do
      assert Day08.Part2.visible_trees_from_tree(5, [1, 2, 5, 4]) == 3
      assert Day08.Part2.visible_trees_from_tree(5, [1]) == 1
    end
  end
end
