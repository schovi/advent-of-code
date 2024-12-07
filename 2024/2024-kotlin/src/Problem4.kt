import java.io.File

typealias Input4 = List<String>

class Problem4 {
  fun parse(input: String): Input4 = input.trimIndent().lines()

  fun solve(input: Input4): Int {
    val words = traverse(input)


    return words.count { it == XMAS }
  }

  fun traverse(input: Input4): List<String> {
    val yLen = input.size
    val xLen = input[0].length

    val verticals = input.windowed(XMAS_LENGTH, 1).flatMap() { rowsWindow ->
      val firstRow = rowsWindow[0]

      firstRow.flatMapIndexed() { x, _ ->
        val word = rowsWindow.map { row -> row[x] }.joinToString("")

        return@flatMapIndexed listOf(word, word.reversed())
      }
    }

    val horizontals = input.flatMap() { row ->
      row.windowed(XMAS_LENGTH, 1).flatMap() { columnsWindow ->
        listOf(columnsWindow, columnsWindow.reversed())
      }
    }

    val leftToRight = (0..yLen - XMAS_LENGTH).flatMap() { y ->
      (0..xLen - XMAS_LENGTH).flatMap() { x ->
        val world = (0..XMAS_LENGTH - 1).map() { i ->
          input[y + i][x + i]
        }.joinToString("")

        listOf(world, world.reversed())
      }
    }

    val rightToLeft = (0..yLen - XMAS_LENGTH).flatMap() { y ->
      (xLen-1 downTo -1 + XMAS_LENGTH).flatMap() { x ->
        val world = (0..XMAS_LENGTH - 1).map() { i ->
          input[y + i][x - i]
        }.joinToString("")

        listOf(world, world.reversed())
      }
    }

    return verticals + horizontals + leftToRight + rightToLeft
  }

  fun solveBonus(input: Input4): Int {
    val yLen = input.size
    val xLen = input[0].length

    return (0..yLen - MAS_LENGTH).fold(0) { acc, y ->
      acc + (0..xLen - MAS_LENGTH).count() { x ->
        input[y + 1][x + 1] == 'A' &&
        (input[y][x] == 'M' && input[y + 2][x + 2] == 'S' || input[y][x] == 'S' && input[y + 2][x + 2] == 'M') &&
        (input[y + 2][x] == 'M' && input[y][x + 2] == 'S' || input[y + 2][x] == 'S' && input[y][x + 2] == 'M')
      }
    }
  }

  companion object {
    val XMAS = "XMAS"
    val XMAS_LENGTH = XMAS.length

    val MAS = "MAS"
    val MAS_LENGTH = MAS.length
  }
}



fun main() {
  val DEBUG = """
    ..X...
    .SAMX.
    .A..A.
    XMAS.S
    .X....
  """.trimIndent()

  val TEST_INPUT = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
  """.trimIndent()

  val problem4 = Problem4()

  println(problem4.solve(problem4.parse(DEBUG)))
  println(problem4.solve(problem4.parse(TEST_INPUT)))
  println(problem4.solve(problem4.parse(File("./sources/Problem4.source").readText())))

  val BONUS_TEST_INPUT = """
    .M.S......
    ..A..MSMS.
    .M.S.MAA..
    ..A.ASMSM.
    .M.S.M....
    ..........
    S.S.S.S.S.
    .A.A.A.A..
    M.M.M.M.M.
    ..........
  """.trimIndent()

  println("bonus")
  println(problem4.solveBonus(problem4.parse(BONUS_TEST_INPUT)))
  println(problem4.solveBonus(problem4.parse(File("./sources/Problem4.source").readText())))
}
