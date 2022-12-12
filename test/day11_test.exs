defmodule Day11Test do
  use ExUnit.Case

  @example_input """
  Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """

  test "solves example input for part 1" do
    assert Day11.Part1.solve(@example_input) == 10605
  end

  describe ".parse_monkeys" do
    test "returns monkeys as map" do
      monkey = """
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3

      Monkey 1:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3
      """

      expected = %{
        0 => %{
          items: [79, 98],
          operation: "old * 19",
          divisible: 23,
          if_true: 2,
          if_false: 3,
          inspections: 0
        },
        1 => %{
          items: [79, 98],
          operation: "old * 19",
          divisible: 23,
          if_true: 2,
          if_false: 3,
          inspections: 0
        }
      }

      assert Day11.Part1.parse_monkeys(monkey) == expected
    end
  end

  describe ".parse_monkey" do
    test "returns monkey as map" do
      monkey = """
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3
      """

      expected = %{
        items: [79, 98],
        operation: "old * 19",
        divisible: 23,
        if_true: 2,
        if_false: 3,
        inspections: 0
      }

      assert Day11.Part1.parse_monkey(monkey) == expected
    end
  end

  # Part 2

  test "solves example input for part 2" do
    assert Day11.Part2.solve(@example_input) == 2_713_310_158
  end
end
