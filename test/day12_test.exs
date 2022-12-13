defmodule Day12Test do
  use ExUnit.Case

  @example_input """
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi
  """

  test "solves example input for part 1" do
    assert Day12.Part1.solve(@example_input) == 31
  end

  describe ".parse_input" do
    test "returns state" do
      input = """
      Sb
      cE
      """

      expected = %{
        elevations: %{{0, 0} => 0, {1, 0} => 1, {0, 1} => 2, {1, 1} => 25},
        distances: %{{0, 0} => 0},
        recents: [{0, 0}],
        end: {1, 1}
      }

      assert Day12.Part1.parse_input(input) == expected
    end
  end

  describe ".parse_elevation" do
    test "returns numeric value for alpha characters" do
      assert Day12.Part1.parse_cell(hd('a')) == %{start?: false, end?: false, elevation: 0}
      assert Day12.Part1.parse_cell(hd('z')) == %{start?: false, end?: false, elevation: 25}
      assert Day12.Part1.parse_cell(hd('S')) == %{start?: true, end?: false, elevation: 0}
      assert Day12.Part1.parse_cell(hd('E')) == %{start?: false, end?: true, elevation: 25}
    end
  end

  describe ".neighbors" do
    test "returns list of points around a given point" do
      assert Day12.Part1.neighbors({0, 0}) == [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    end
  end

  describe ".next_neighbors" do
    test "returns state" do
      state = %{
        elevations: %{{0, 0} => 0, {1, 0} => 1, {0, 1} => 1, {1, 1} => 1},
        distances: %{{0, 0} => 0}
      }

      assert Day12.Part1.next_neighbors({0, 0}, state) == [{1, 0}, {0, 1}]
    end
  end
end
