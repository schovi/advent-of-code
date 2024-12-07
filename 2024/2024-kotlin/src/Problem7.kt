import java.io.File
import java.math.BigInteger

typealias Input7 = List<Pair<BigInteger, List<Int>>>

class Problem7 {
  fun parse(input: String): Input7 = input.trimIndent().lines().map {
      val (result, numbers) = it.split(":", limit = 2)
      val numbersList = numbers.trim().split(" ").map { it.toInt() }

      result.toBigInteger() to numbersList
    }

  fun solve(input: Input7): BigInteger =
    input.fold(BigInteger.valueOf(0)) { acc, (result, numbers) ->

      if (combine(numbers, result) != null) {
        acc + result
      } else {
        acc
      }
    }

  fun combine(numbers: List<Int>, target: BigInteger): BigInteger? =
    combine(numbers.drop(1), target, numbers[0].toBigInteger())

  fun combine(numbers: List<Int>, target: BigInteger, result: BigInteger): BigInteger? {
    if (numbers.isEmpty()) {
      return if (result == target) {
        result
      } else {
        null
      }
    }

    val first = numbers[0].toBigInteger()
    val rest = numbers.drop(1)

    val multiply = combine(rest, target, first * result)

    if (multiply != null) {
        return multiply
    }

    val sum = combine(rest, target, first + result)

    if (sum != null) {
      return sum
    }

    return null
  }

  fun solveBonus(input: Input7): BigInteger =
    input.fold(BigInteger.valueOf(0)) { acc, (result, numbers) ->

      if (combineBonus(numbers, result) != null) {
        acc + result
      } else {
        acc
      }
    }


  fun combineBonus(numbers: List<Int>, target: BigInteger): BigInteger? =
    combineBonus(numbers.drop(1), target, numbers[0].toBigInteger())

  fun combineBonus(numbers: List<Int>, target: BigInteger, prev: BigInteger): BigInteger? {
    if (numbers.isEmpty()) {
      return if (prev == target) {
        prev
      } else {
        null
      }
    }

    val first = numbers[0].toBigInteger()
    val rest = numbers.drop(1)

    val multiply = combineBonus(rest, target, prev * first)

    if (multiply != null) {
      return multiply
    }

    val sum = combineBonus(rest, target, prev + first)

    if (sum != null) {
      return sum
    }

    val concat = combineBonus(rest, target, "$prev$first".toBigInteger())

    if (concat != null) {
      return concat
    }

    return null
  }
}

fun main() {
  val TEST_INPUT = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
  """.trimIndent()

  val problem7 = Problem7()

  println(problem7.solve(problem7.parse(TEST_INPUT)))
  println(problem7.solve(problem7.parse(File("./sources/Problem7.source").readText())))

  println("bonus")

  println(problem7.solveBonus(problem7.parse("7290: 6 8 6 15")))
  println(problem7.solveBonus(problem7.parse(TEST_INPUT)))
  println(problem7.solveBonus(problem7.parse(File("./sources/Problem7.source").readText())))
}
