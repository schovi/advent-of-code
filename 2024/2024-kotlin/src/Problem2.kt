import java.io.File
import kotlin.math.abs

typealias Input2 = List<List<Int>>

class Problem2 {
  fun parse(input: String): Input2 {
    return input
      .trimIndent()
      .lines()
      .map {
        it.split(" ").map { it.toInt() }
      }
  }

  enum class RowState() {
    ASC,
    DESC,
    NONE,
    UNSAFE
  }

  fun solve(input: Input2): Int = input.count { save(it) }

  fun save(row: List<Int>): Boolean =
    row.windowed(size = 2, step = 1) { it[0] to it[1] }.fold(RowState.NONE) { state, (left, right) ->
      when (abs(left - right)) {
        in (1..3) ->
          when (state) {
            RowState.ASC -> if (left > right) RowState.UNSAFE else RowState.ASC
            RowState.DESC -> if (left < right) RowState.UNSAFE else RowState.DESC
            RowState.NONE -> if (left > right) RowState.DESC else if (left < right) RowState.ASC else RowState.UNSAFE
            RowState.UNSAFE -> state
          }
        else -> RowState.UNSAFE
      }
    } != RowState.UNSAFE

  fun solveBonus(input: Input2): Int =
    input.count { row ->
      save(row) || (0..row.size).any { index ->
        save(row.take(index) + row.drop(index + 1))
      }
    }
}



fun main() {
  val TEST_INPUT = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

  val problem2 = Problem2()

  println(problem2.solve(problem2.parse(TEST_INPUT)))
  println(problem2.solve(problem2.parse(File("./sources/Problem2.source").readText())))

  println("bonus")
  println(problem2.solveBonus(problem2.parse(TEST_INPUT)))
  println(problem2.solveBonus(problem2.parse(File("./sources/Problem2.source").readText())))
}
