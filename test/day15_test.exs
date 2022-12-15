defmodule Day15Test do
  use ExUnit.Case

  @example_input """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  test "solves example input for part 1" do
    assert Day15.Part1.solve(@example_input, 10) == 26
  end

  describe ".parse_line" do
    test "returns sensor and distance" do
      line = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15"
      assert Day15.Part1.parse_line(line) == %{sensor: {2, 18}, beacon: {-2, 15}, distance: 7}
    end
  end

  describe ".count_coverage" do
    test "returns number of points the sensors cover" do
      sensors = [
        %{sensor: {2, 0}, beacon: {1, 0}, distance: 1},
        %{sensor: {6, 1}, beacon: {4, 1}, distance: 2}
      ]

      assert Day15.Part1.count_coverage(sensors, 0) == 5
    end
  end

  describe ".x_range" do
    test "returns x range at y" do
      sensor = %{sensor: {3, 0}, distance: 2}

      assert Day15.Part1.x_range(sensor, 0) == 1..5
      assert Day15.Part1.x_range(sensor, 1) == 2..4
      assert Day15.Part1.x_range(sensor, 2) == 3..3
      assert Day15.Part1.x_range(sensor, 4) == nil
    end
  end

  describe ".union_ranges" do
    test "returns a range combining other ranges" do
      assert Day15.Part1.union_ranges([2..5, 4..6, 8..8]) == [8..8, 2..6]
    end
  end
end
