defmodule Day20Test do
  use ExUnit.Case

  @example_input """
  1
  2
  -3
  3
  -2
  0
  4
  """

  test "solves example input for part 1" do
    assert Day20.Part1.solve(@example_input) == 3
  end

  describe ".parse_input" do
    test "returns numbers with index" do
      input = """
      1
      2
      -3
      """

      expected = [
        {1, 0},
        {2, 1},
        {-3, 2}
      ]

      assert Day20.Part1.parse_input(input) == expected
    end
  end

  describe ".move_values" do
    test "moves numbers by their value" do
      input = [
        {0, 0},
        {-1, 1},
        {2, 2},
        {-3, 3}
      ]

      expected = [
        {-1, 1},
        {2, 2},
        {0, 0},
        {-3, 3}
      ]

      assert Day20.Part1.move_values(input, 0) == expected
    end
  end

  describe ".move_value" do
    test "moves number forward" do
      values = [
        {1, 0},
        {2, 1}
      ]

      next_values = [
        {2, 1},
        {1, 0}
      ]

      assert Day20.Part1.move_value(values, 0) == next_values
    end

    test "moves number backward" do
      values = [
        {1, 0},
        {2, 1},
        {-1, 2}
      ]

      next_values = [
        {1, 0},
        {-1, 2},
        {2, 1}
      ]

      assert Day20.Part1.move_value(values, 2) == next_values
    end

    test "moves number forward and wraps to end" do
      values = [
        {1, 0},
        {3, 1},
        {-1, 2}
      ]

      next_values = [
        {1, 0},
        {-1, 2},
        {3, 1}
      ]

      assert Day20.Part1.move_value(values, 1) == next_values
    end

    test "moves number forward and wraps to mid" do
      values = [
        {1, 0},
        {4, 1},
        {-1, 2}
      ]

      next_values = [
        {1, 0},
        {4, 1},
        {-1, 2}
      ]

      assert Day20.Part1.move_value(values, 1) == next_values
    end

    test "moves number backward and wraps to end" do
      values = [
        {1, 0},
        {2, 1},
        {-2, 2},
        {-1, 3}
      ]

      next_values = [
        {1, 0},
        {2, 1},
        {-1, 3},
        {-2, 2}
      ]

      assert Day20.Part1.move_value(values, 2) == next_values
    end

    test "moves number backward and wraps to mid" do
      values = [
        {1, 0},
        {-4, 1},
        {-1, 2}
      ]

      next_values = [
        {1, 0},
        {-4, 1},
        {-1, 2}
      ]

      assert Day20.Part1.move_value(values, 1) == next_values
    end

    test "keeps zero in place" do
      values = [
        {1, 0},
        {0, 1},
        {-1, 2}
      ]

      next_values = [
        {1, 0},
        {0, 1},
        {-1, 2}
      ]

      assert Day20.Part1.move_value(values, 1) == next_values
    end
  end

  test "solves example input for part 2" do
    assert Day20.Part2.solve(@example_input) == 1_623_178_306
  end
end
