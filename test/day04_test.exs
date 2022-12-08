defmodule Day04Test do
  use ExUnit.Case

  @example_input """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  test "solves example input for part 1" do
    assert Day04.Part1.solve(@example_input) == 2
  end

  test "solves example input for part 2" do
    assert Day04.Part2.solve(@example_input) == 4
  end
end
