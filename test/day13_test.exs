defmodule Day13Test do
  use ExUnit.Case

  @example_input """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  test "solves example input for part 1" do
    assert Day13.Part1.solve(@example_input) == 13
  end

  describe ".parse_packet" do
    test "parses list of integers" do
      assert Day13.Part1.parse_packet("[1,2,3]") == [1, 2, 3]
      assert Day13.Part1.parse_packet("[]") == []
    end

    test "parses list of lists" do
      assert Day13.Part1.parse_packet("[1,[2,[3,4]],5]") == [1, [2, [3, 4]], 5]
      assert Day13.Part1.parse_packet("[[1],[2,3,4]]") == [[1], [2, 3, 4]]
      assert Day13.Part1.parse_packet("[[], [[]]]") == [[], [[]]]
    end
  end

  describe ".pair_in_order?" do
    test "returns true when left is lower than right" do
      assert Day13.Part1.pair_in_order?([1], [2]) == true
      assert Day13.Part1.pair_in_order?([1, 1], [1, 2]) == true
    end

    test "returns false when left is higher than right" do
      assert Day13.Part1.pair_in_order?([1, 2], [1, 1]) == false
      assert Day13.Part1.pair_in_order?([1, 2], [1, 1]) == false
    end

    test "compares nested pairs" do
      assert Day13.Part1.pair_in_order?([[1, 1]], [[1, 2]]) == true
      assert Day13.Part1.pair_in_order?([[], 4], [[], 3]) == false
    end

    test "wraps non list in list when comparing" do
      assert Day13.Part1.pair_in_order?([1], [[2]]) == true
      assert Day13.Part1.pair_in_order?([[1]], [2]) == true
      assert Day13.Part1.pair_in_order?([[1], [2, 3, 4]], [[1], 4]) == true
      assert Day13.Part1.pair_in_order?([[[6, [], [5, 7]], [[1], 4]]], [6, 10, 0, 0]) == false

      assert Day13.Part1.pair_in_order?([[6], 5], [6]) == false
    end

    test "returns true when left has fewer items than right" do
      assert Day13.Part1.pair_in_order?([], [1]) == true
      assert Day13.Part1.pair_in_order?([1], []) == false
      assert Day13.Part1.pair_in_order?([1], [1, 1]) == true
      assert Day13.Part1.pair_in_order?([1, 1], [1]) == false
      assert Day13.Part1.pair_in_order?([], [[]]) == true
      assert Day13.Part1.pair_in_order?([[]], []) == false
    end
  end

  # Part 2

  test "solves example input for part 2" do
    assert Day13.Part2.solve(@example_input) == 140
  end
end
