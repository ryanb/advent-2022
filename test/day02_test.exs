defmodule Day02Test do
  use ExUnit.Case

  @example_input """
  A Y
  B X
  C Z
  """

  test "solves example input for part 1" do
    assert Day02.Part1.solve(@example_input) == 15
  end

  test "solves example input for part 2" do
    assert Day02.Part2.solve(@example_input) == 12
  end
end
