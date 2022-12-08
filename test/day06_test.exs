defmodule Day06Test do
  use ExUnit.Case

  # The pipes are added to prevent losing whitespace
  @example_input """
  mjqjpqmgbljsphdztnvjfqwrcgsmlb
  """

  test "solves example input for part 1" do
    assert Day06.Part1.solve(@example_input) == 7
  end

  test "solves example input for part 2" do
    assert Day06.Part2.solve(@example_input) == 19
  end
end
