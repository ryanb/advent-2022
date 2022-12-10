defmodule Day10Test do
  use ExUnit.Case

  @example_input """
  addx 15
  addx -11
  addx 6
  addx -3
  addx 5
  addx -1
  addx -8
  addx 13
  addx 4
  noop
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx -35
  addx 1
  addx 24
  addx -19
  addx 1
  addx 16
  addx -11
  noop
  noop
  addx 21
  addx -15
  noop
  noop
  addx -3
  addx 9
  addx 1
  addx -3
  addx 8
  addx 1
  addx 5
  noop
  noop
  noop
  noop
  noop
  addx -36
  noop
  addx 1
  addx 7
  noop
  noop
  noop
  addx 2
  addx 6
  noop
  noop
  noop
  noop
  noop
  addx 1
  noop
  noop
  addx 7
  addx 1
  noop
  addx -13
  addx 13
  addx 7
  noop
  addx 1
  addx -33
  noop
  noop
  noop
  addx 2
  noop
  noop
  noop
  addx 8
  noop
  addx -1
  addx 2
  addx 1
  noop
  addx 17
  addx -9
  addx 1
  addx 1
  addx -3
  addx 11
  noop
  noop
  addx 1
  noop
  addx 1
  noop
  noop
  addx -13
  addx -19
  addx 1
  addx 3
  addx 26
  addx -30
  addx 12
  addx -1
  addx 3
  addx 1
  noop
  noop
  noop
  addx -9
  addx 18
  addx 1
  addx 2
  noop
  noop
  addx 9
  noop
  noop
  noop
  addx -1
  addx 2
  addx -37
  addx 1
  addx 3
  noop
  addx 15
  addx -21
  addx 22
  addx -6
  addx 1
  noop
  addx 2
  addx 1
  noop
  addx -10
  noop
  noop
  addx 20
  addx 1
  addx 2
  addx 2
  addx -6
  addx -11
  noop
  noop
  noop
  """

  test "solves example input for part 1" do
    assert Day10.Part1.solve(@example_input) == 13140
  end

  describe ".run_command with noop" do
    test "increments cycles by 1" do
      state = %{cycles: 0, register: 1, signals: [], signal_strengths: []}
      expected = %{state | cycles: 1}
      assert Day10.Part1.run("noop", state) == expected
    end

    test "sets signal strength to cycles * register" do
      state = %{cycles: 1, register: 2, signals: [2], signal_strengths: []}
      expected = %{cycles: 2, register: 2, signals: [], signal_strengths: [4]}
      assert Day10.Part1.run("noop", state) == expected
    end
  end

  describe ".run_command with addx" do
    test "increments cycles by 2 and adds register" do
      state = %{cycles: 0, register: 1, signals: [], signal_strengths: []}
      expected = %{state | cycles: 2, register: 3}
      assert Day10.Part1.run("addx 2", state) == expected
    end
  end

  # Part 2

  test "solves example input for part 2" do
    expected = """
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
    """

    assert Day10.Part2.solve(@example_input) == String.trim(expected)
  end

  describe ".cycle" do
    test "adds pixel based on register" do
      state = %{register: 1, pixels: []}
      expected = %{register: 1, pixels: ["#"]}
      assert Day10.Part2.cycle(state) == expected
    end
  end

  describe ".pixel" do
    test "returns # when cycles is near register" do
      assert Day10.Part2.pixel(cycles: 1, register: 3) == "."
      assert Day10.Part2.pixel(cycles: 2, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 3, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 4, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 5, register: 3) == "."
    end

    test "mods cycles by screen width" do
      assert Day10.Part2.pixel(cycles: 41, register: 3) == "."
      assert Day10.Part2.pixel(cycles: 42, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 43, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 44, register: 3) == "#"
      assert Day10.Part2.pixel(cycles: 45, register: 3) == "."
    end
  end
end
