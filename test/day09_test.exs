defmodule Day09Test do
  use ExUnit.Case

  @example_input """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  @example_input_2 """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
  """

  test "solves example input for part 1" do
    assert Day09.Part1.solve(@example_input) == 13
  end

  describe "move_tail" do
    test "moves tail closer to head when not touching" do
      state = %{head: {2, 2}, tails: [{0, 0}]}
      %{tails: tails} = Day09.Part1.move_tail(state)
      assert tails == [{1, 1}, {0, 0}]
    end

    test "does not move tail when touching head" do
      state = %{head: {1, 1}, tails: [{0, 0}]}
      %{tails: tails} = Day09.Part1.move_tail(state)
      assert tails == [{0, 0}]
    end
  end

  describe "parse_input_line" do
    test "returns list of operations" do
      assert Day09.Part1.parse_input_line("R 2") == [:right, :right]
      assert Day09.Part1.parse_input_line("L 1") == [:left]
      assert Day09.Part1.parse_input_line("U 3") == [:up, :up, :up]
      assert Day09.Part1.parse_input_line("D 2") == [:down, :down]
    end
  end

  describe ".is_touching?" do
    test "returns true if head is within one from tail" do
      assert Day09.Part1.is_touching?(head: {0, 0}, tail: {0, 0}) == true
      assert Day09.Part1.is_touching?(head: {1, 0}, tail: {0, 0}) == true
      assert Day09.Part1.is_touching?(head: {1, 1}, tail: {0, 0}) == true
      assert Day09.Part1.is_touching?(head: {2, 0}, tail: {0, 0}) == false
      assert Day09.Part1.is_touching?(head: {2, 1}, tail: {0, 0}) == false
      assert Day09.Part1.is_touching?(head: {-1, -1}, tail: {0, 0}) == true
      assert Day09.Part1.is_touching?(head: {-2, -1}, tail: {0, 0}) == false
    end
  end

  # Part 2

  test "solves example input for part 2" do
    assert Day09.Part2.solve(@example_input) == 1
    assert Day09.Part2.solve(@example_input_2) == 36
  end
end
