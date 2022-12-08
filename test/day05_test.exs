defmodule Day05Test do
  use ExUnit.Case

  # The pipes are added to prevent losing whitespace
  @example_input """
  |   [D]   |
  [N] [C]   |
  [Z] [M] [P]
  |1   2   3|

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  test "solves example input for part 1" do
    assert Day05.Part1.solve(@example_input) == "CMZ"
  end

  test "solves example input for part 2" do
    assert Day05.Part2.solve(@example_input) == "MCD"
  end
end
