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

  # Part 2

  describe "Part2.FacesBuilder.build_faces" do
    test "returns faces given minimap of example input" do
      input = """
        .
      ...
        ..
      """

      minimap = Day22.Part1.parse_map(input).tiles

      expected = %{
        {0, 1} => [{2, 0}, {1, 1}, {2, 2}, {3, 2}],
        {1, 1} => [{2, 0}, {2, 1}, {2, 2}, {0, 1}],
        {2, 0} => [{0, 1}, {3, 2}, {2, 1}, {1, 1}],
        {2, 1} => [{2, 0}, {3, 2}, {2, 2}, {1, 1}],
        {2, 2} => [{2, 1}, {3, 2}, {0, 1}, {1, 1}],
        {3, 2} => [{2, 1}, {2, 0}, {0, 1}, {2, 2}]
      }

      assert Day22.Part2.FacesBuilder.build_faces(minimap) == expected
    end

    test "returns faces given minimap of problem input" do
      input = """
       ..
       .
      ..
      .
      """

      minimap = Day22.Part1.parse_map(input).tiles

      expected = %{
        {1, 1} => [{1, 0}, {2, 0}, {1, 2}, {0, 2}],
        {2, 0} => [{0, 3}, {1, 2}, {1, 1}, {1, 0}],
        {0, 2} => [{1, 1}, {1, 2}, {0, 3}, {1, 0}],
        {0, 3} => [{0, 2}, {1, 2}, {2, 0}, {1, 0}],
        {1, 0} => [{0, 3}, {2, 0}, {1, 1}, {0, 2}],
        {1, 2} => [{1, 1}, {2, 0}, {0, 3}, {0, 2}]
      }

      assert Day22.Part2.FacesBuilder.build_faces(minimap) == expected
    end
  end

  describe "Part2.FacesBuilder.rotate_neighbors" do
    test "returns array rotated by the amount" do
      assert Day22.Part2.FacesBuilder.rotate_neighbors([1, 2, 3], 1) == [2, 3, 1]
      assert Day22.Part2.FacesBuilder.rotate_neighbors([1, 2, 3], 4) == [2, 3, 1]
      assert Day22.Part2.FacesBuilder.rotate_neighbors([1, 2, 3], -1) == [3, 1, 2]
      assert Day22.Part2.FacesBuilder.rotate_neighbors([1, 2, 3], -4) == [3, 1, 2]
    end
  end

  describe "Part2.parse_map" do
    test "adds walls and tiles to map" do
      input = """
        .#
        ..
      ....
      .#..
      """

      expected = %{
        minimap: MapSet.new([{1, 0}, {0, 1}, {1, 1}]),
        walls: MapSet.new([{3, 0}, {1, 3}]),
        scale: 2
      }

      assert Day22.Part2.parse_map(input, 2) == expected
    end
  end

  describe "Part2.position_to_offset" do
    test "returns offset for each direction" do
      assert Day22.Part2.position_to_offset(%{position: {5, 0}, direction: :north, scale: 4}) == 1
      assert Day22.Part2.position_to_offset(%{position: {0, 5}, direction: :east, scale: 4}) == 1
      assert Day22.Part2.position_to_offset(%{position: {5, 0}, direction: :south, scale: 4}) == 2
      assert Day22.Part2.position_to_offset(%{position: {0, 5}, direction: :west, scale: 4}) == 2
    end
  end

  describe "Part2.offset_to_position" do
    test "returns position for each direction" do
      assert Day22.Part2.offset_to_position(%{offset: 1, direction: :north, scale: 4}) == {1, 3}
      assert Day22.Part2.offset_to_position(%{offset: 1, direction: :east, scale: 4}) == {0, 1}
      assert Day22.Part2.offset_to_position(%{offset: 1, direction: :south, scale: 4}) == {2, 0}
      assert Day22.Part2.offset_to_position(%{offset: 1, direction: :west, scale: 4}) == {3, 2}
    end
  end

  test "solves example input for part 2" do
    assert Day22.Part2.solve(@example_input, 4) == 5031
  end
end
