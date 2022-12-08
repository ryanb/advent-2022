defmodule Day07Test do
  use ExUnit.Case

  # The pipes are added to prevent losing whitespace
  @example_input """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  test "solves example input for part 1" do
    assert Day07.Part1.solve(@example_input) == 95437
  end

  test "solves example input for part 2" do
    assert Day07.Part2.solve(@example_input) == 24_933_642
  end
end