defmodule Day17Test do
  use ExUnit.Case

  @example_input """
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
  """

  test "solves example input for part 1" do
    assert Day17.Part1.solve(@example_input) == 3068
  end

  describe ".parse_jet_pattern" do
    test "returns list of left/right atoms" do
      assert Day17.Part1.parse_jet_pattern(">><") == [:right, :right, :left]
    end
  end

  describe ".move_rock" do
    test "returns state with current rock added to blocks" do
      rock = [{1, 1}, {2, 2}]
      expected = [{2, 2}, {3, 3}]

      assert Day17.Part1.move_rock(rock, 1, 1) == expected
    end
  end

  describe ".settle" do
    test "returns state with current rock added to blocks" do
      state = %{
        blocks: MapSet.new([{1, 1}, {2, 2}]),
        rock: [{1, 2}, {2, 3}]
      }

      expected = %{state | blocks: MapSet.new([{1, 1}, {2, 2}, {1, 2}, {2, 3}])}

      assert Day17.Part1.settle(state) == expected
    end
  end

  describe ".height" do
    test "returns highest block in set" do
      blocks = MapSet.new([{0, 0}, {2, 5}])
      assert Day17.Part1.height(blocks) == 6
    end

    test "returns 0 for heigh with no blocks" do
      blocks = MapSet.new()
      assert Day17.Part1.height(blocks) == 0
    end
  end

  describe ".colliding?" do
    test "returns false when not overlapping with blocks" do
      blocks = MapSet.new([{1, 1}, {2, 2}])
      rock = [{1, 2}, {1, 6}]
      assert Day17.Part1.colliding?(blocks, rock) == false
    end

    test "returns true when overlapping with blocks" do
      blocks = MapSet.new([{1, 1}, {2, 2}])
      rock = [{1, 1}, {2, 3}]
      assert Day17.Part1.colliding?(blocks, rock) == true
    end

    test "returns true when beyond left edge" do
      rock = [{-1, 1}, {2, 3}]
      assert Day17.Part1.colliding?(MapSet.new(), rock) == true
    end

    test "returns true when beyond right edge" do
      rock = [{7, 1}, {2, 3}]
      assert Day17.Part1.colliding?(MapSet.new(), rock) == true
    end

    test "returns true when beyond floor edge" do
      rock = [{1, -1}, {2, 3}]
      assert Day17.Part1.colliding?(MapSet.new(), rock) == true
    end
  end
end
