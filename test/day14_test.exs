defmodule Day14Test do
  use ExUnit.Case

  @example_input """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  test "solves example input for part 1" do
    assert Day14.Part1.solve(@example_input) == 24
  end

  describe ".parse_input" do
    test "returns blocks of rocks" do
      input = """
      1,1 -> 1,3 -> 2,3
      10,11 -> 10,12
      """

      blocks = %{
        {1, 1} => :rock,
        {1, 2} => :rock,
        {1, 3} => :rock,
        {2, 3} => :rock,
        {10, 11} => :rock,
        {10, 12} => :rock
      }

      assert Day14.Part1.parse_input(input) == blocks
    end
  end

  describe ".parse_rocks" do
    test "returns list of points between two points" do
      assert Day14.Part1.parse_rocks([{1, 2}, {1, 4}]) == [{1, 2}, {1, 3}, {1, 4}]
      assert Day14.Part1.parse_rocks([{1, 1}, {3, 1}]) == [{1, 1}, {2, 1}, {3, 1}]
    end
  end

  describe ".step_sand" do
    test "returns next point down" do
      assert Day14.Part1.step_sand({0, 0}, %{}) == {0, 1}
      assert Day14.Part1.step_sand({0, 0}, %{{0, 1} => :rock}) == {-1, 1}
      assert Day14.Part1.step_sand({0, 0}, %{{0, 1} => :rock, {-1, 1} => :rock}) == {1, 1}
    end

    test "settles if no points available" do
      blocks = %{{0, 1} => :rock, {-1, 1} => :rock, {1, 1} => :rock}
      assert Day14.Part1.step_sand({0, 0}, blocks) == :settle
    end

    test "halts if below limit" do
      assert Day14.Part1.step_sand({0, 10000}, %{}) == :halt
    end
  end

  describe ".count_sand" do
    test "returns next point down" do
      blocks = %{{0, 0} => :rock, {0, 1} => :sand, {1, 0} => :sand}
      assert Day14.Part1.count_sand(blocks) == 2
    end
  end
end
