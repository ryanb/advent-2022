defmodule Day01Test do
  use ExUnit.Case

  @example_input """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "solves example input for part 1" do
    assert Day01.Part1.solve(@example_input) == 24000
  end

  test "solves example input for part 2" do
    assert Day01.Part2.solve(@example_input) == 45000
  end
end
