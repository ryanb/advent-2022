defmodule Day18Test do
  use ExUnit.Case

  @example_input """
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  test "solves example input for part 1" do
    assert Day18.Part1.solve(@example_input) == 64
  end

  describe ".touching?" do
    test "returns true if two points are next to each other" do
      assert Day18.Part1.touching?({1, 2, 3}, {1, 2, 4}) == true
      assert Day18.Part1.touching?({1, 2, 4}, {1, 2, 4}) == false
      assert Day18.Part1.touching?({1, 2, 5}, {1, 2, 4}) == true
      assert Day18.Part1.touching?({1, 3, 5}, {1, 2, 4}) == false
    end
  end
end
