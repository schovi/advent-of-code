import java.io.File
import kotlin.math.abs

class Problem3 {
  fun parse(input: String): String = input

  fun solve(input: String): Int {
    val regex = Regex("""mul\((\d+),(\d+)\)""")
    val matches = regex.findAll(input)

    return matches.fold(0) { result, match ->
      result + match.groupValues.mapNotNull {
        if (!it.startsWith("mul")) {
          it.toInt()
        } else {
          null
        }
      }.fold(1) { acc, i -> acc * i }
     }
  }

  fun solveBonus(input: String): Int {
    val regex = Regex("""mul\((\d+),(\d+)\)|do\(\)|don't\(\)""")
    val matches = regex.findAll(input)

    var apply = true
    return matches.fold(0) { result, match ->
      if (match.value == "do()") {
        apply = true
        result
      } else if (match.value == "don't()") {
        apply = false
        result
      } else if (apply) {
        result + match.groupValues.mapNotNull {
          if (!it.startsWith("mul")) {
            it.toInt()
          } else {
            null
          }
        }.fold(1) { acc, i -> acc * i }
      } else {
        result
      }
    }
  }
}



fun main() {
  val TEST_INPUT = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  val problem3 = Problem3()

  println(problem3.solve(problem3.parse(TEST_INPUT)))
  println(problem3.solve(problem3.parse(File("./sources/Problem3.source").readText())))

  val BONUS_TEST_INPUT = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  println("bonus")
  println(problem3.solveBonus(problem3.parse(BONUS_TEST_INPUT)))
  println(problem3.solveBonus(problem3.parse(File("./sources/Problem3.source").readText())))
}
