import java.io.File

typealias InputTemplate = List<String>

class ProblemTemplate {
  fun parse(input: String): InputTemplate = input.trimIndent().lines()

  fun solve(input: InputTemplate): Int {
    return 1
  }

  fun solveBonus(input: InputTemplate): Int {
    return 1
  }
}



fun main() {
  val TEST_INPUT = """
    
  """.trimIndent()

  val problemTemplate = ProblemTemplate()

  println(problemTemplate.solve(problemTemplate.parse(TEST_INPUT)))
  println(problemTemplate.solve(problemTemplate.parse(File("./sources/ProblemTemplate.source").readText())))

  println("bonus")
  println(problemTemplate.solveBonus(problemTemplate.parse(TEST_INPUT)))
  println(problemTemplate.solveBonus(problemTemplate.parse(File("./sources/ProblemTemplate.source").readText())))
}
