defmodule Day21Test do
  use ExUnit.Case

  @example_input """
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  test "solves example input for part 1" do
    assert Day21.Part1.solve(@example_input) == 152
  end

  test "solves example input for part 2" do
    assert Day21.Part2.solve(@example_input) == 301
  end

  describe ".path_to_human" do
    test "returns list of monkeys to human" do
      monkeys = %{
        "root" => {"a", "+", "b"},
        "a" => 1,
        "b" => {"c", "+", "d"},
        "c" => {"e", "+", "humn"},
        "d" => 2,
        "e" => 3,
        "humn" => 4
      }

      assert Day21.Part2.path_to_human(monkeys, "root") == ["root", "b", "c", "humn"]
    end
  end

  describe ".reverse_operation" do
    test "reverses math operation" do
      assert Day21.Part2.reverse_operation({:humn, "+", 3}, 5) == 2
      assert Day21.Part2.reverse_operation({3, "+", :humn}, 5) == 2

      assert Day21.Part2.reverse_operation({:humn, "-", 3}, 5) == 8
      assert Day21.Part2.reverse_operation({8, "-", :humn}, 5) == 3

      assert Day21.Part2.reverse_operation({:humn, "*", 3}, 6) == 2
      assert Day21.Part2.reverse_operation({3, "*", :humn}, 6) == 2

      assert Day21.Part2.reverse_operation({:humn, "/", 3}, 2) == 6
      assert Day21.Part2.reverse_operation({6, "/", :humn}, 2) == 3
    end
  end
end
