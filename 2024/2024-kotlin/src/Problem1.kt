import java.io.File

typealias Input1 = Pair<List<Int>, List<Int>>
fun parse1(input: String): Input1 {
  return input
    .trimIndent()
    .lines()
    .fold(listOf<Int>() to listOf<Int>()) { (left, right), line ->
      val parsed = line.split("   ", limit = 2).map { it.toInt() }

      return@fold (
        (left + parsed[0]!!)
          to
          (right + parsed[1]!!)
        )
    }
}

fun solve1(input: Input1): Int {
  val (left, right) = input
  val sortedLeft = left.asSequence().sorted()
  val sortedRight = right.asSequence().sorted()

  return sortedLeft.zip(sortedRight).fold(0) { acc, (left, right) ->
    val res = left - right

    if (res < 0) {
      return@fold acc + (res * -1)
    } else {
      return@fold acc + res
    }
  }
}

fun solve1Bonus(input: Input1): Int {
  val (left, right) = input

  val rightGrouped = right.groupBy { it }.mapValues { it.value.size }

  return left.fold(0) { acc, leftValue ->
    val count = rightGrouped[leftValue] ?: 0
    return@fold acc + (leftValue * count)
  }
}

fun main() {
  val TEST_INPUT = """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  println(solve1(parse1(TEST_INPUT)))
  println(solve1(parse1(File("./sources/Problem1.source").readText())))

  println("bonus")
  println(solve1Bonus(parse1(TEST_INPUT)))
  println(solve1Bonus(parse1(File("./sources/Problem1.source").readText())))
}
