defmodule Day22Test do
  use ExUnit.Case

  @example_input """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  test "solves example input for part 1" do
    assert Day22.Part1.solve(@example_input) == 6032
  end

  describe ".parse_map" do
    test "adds walls and tiles to map" do
      input = """
       .#
      .#
      """

      expected = %{
        tiles: MapSet.new([{1, 0}, {2, 0}, {0, 1}, {1, 1}]),
        walls: MapSet.new([{2, 0}, {1, 1}])
      }

      assert Day22.Part1.parse_map(input) == expected
    end
  end

  describe ".parse_commands" do
    test "splits numbers and directions" do
      input = "12R3LL45"

      assert Day22.Part1.parse_commands(input) == ["12", "R", "3", "L", "L", "45"]
    end
  end
end
