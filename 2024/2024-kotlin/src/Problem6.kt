import java.io.File

class Problem6 {
  data class Input(val y: Int, val x: Int,  val direction: Char, val map: List<String>)

  fun parse(input: String): Input {
    val map = input.trimIndent().lines()

    for (y in map.indices) {
      for (x in map[y].indices) {
        val char = map[y][x]

////        println("$y $x $char")
        when(char) {
          '^' -> return Input(y = y, x = x, char, map)
          'v' -> return Input(y = y, x = x, char, map)
          '<' -> return Input(y = y, x = x, char, map)
          '>' -> return Input(y = y, x = x, char, map)
        }
      }
    }

    throw IllegalArgumentException("No starting point found")
  }

  val ROTATIONS = mapOf('>' to 'v', 'v' to '<', '<' to '^', '^' to '>')

  fun solve(input: Input): Int {
    val map = input.map
    val maxX = map[0].length
    val maxY = map.size

    var (y, x, direction) = input
    val visited = mutableSetOf<Pair<Int, Int>>()

    while (true) {
////      println("visiting $y,$x $direction")
      visited.add(y to x)

      val peekY = when (direction) {
        '^' -> y - 1
        'v' -> y + 1
        else -> y
      }

      val peekX =  when (direction) {
        '>' -> x + 1
        '<' -> x - 1
        else -> x
      }

////      println("peeking to $peekY,$peekX")
      if (peekX < 0 || peekX >= maxX || peekY < 0 || peekY >= maxY) {
        return visited.size
      }

      val peek = map[peekY][peekX]
////      println("peek: $peek")

      if (peek == '#') {
        direction = ROTATIONS.getValue(direction)

        when (direction) {
          '^' -> y --
          'v' -> y ++
          else -> y
        }

        when (direction) {
          '>' -> x ++
          '<' -> x --
          else -> x
        }
      } else {
        x = peekX
        y = peekY
      }
    }
  }

  data class Triple(val y: Int, val x: Int, val direction: Char)
  fun solveBonus(input: Input, debug: Boolean = false): Int {
    val map = input.map
    val maxX = map[0].length
    val maxY = map.size

    var (y, x, direction) = input
    val visited = mutableSetOf<Triple>()
    val loops = mutableSetOf<Pair<Int, Int>>()

    while (true) {
////      println("visiting $y,$x $direction")
      visited.add(Triple(y, x, direction))

      val peekY = when (direction) {
        '^' -> y - 1
        'v' -> y + 1
        else -> y
      }

      val peekX =  when (direction) {
        '>' -> x + 1
        '<' -> x - 1
        else -> x
      }

////      println("peeking to $peekY,$peekX")
      if (peekX < 0 || peekX >= maxX || peekY < 0 || peekY >= maxY) {
        break
//        return visited.size
      }


      // Branch for the timeloop
//      println("Starting simulation at $y,$x $direction")
      if (simulateLoop(map, visited, y, x, direction, maxX, maxY)) {
//        println("Simulated loop from $y,$x $direction")
//        println("Loop detected at $peekY,$peekX")
        loops.add(peekY to peekX)

//        break
      }

      // Continue as before

      val peek = map[peekY][peekX]
////      println("peek: $peek")

      if (peek == '#') {
        direction = ROTATIONS.getValue(direction)

        when (direction) {
          '^' -> y --
          'v' -> y ++
          else -> y
        }

        when (direction) {
          '>' -> x ++
          '<' -> x --
          else -> x
        }
      } else {
        x = peekX
        y = peekY
      }
    }

    if (debug) {
      map.forEachIndexed { y, row ->
        println(row.mapIndexed { x, char ->
          if (loops.contains(y to x)) {
            '0'
          } else {
            char
          }
        }.joinToString(""))
      }
    }

    return loops.size
  }

  fun simulateLoop(map: List<String>, visits: Set<Triple>, y: Int, x: Int, direction: Char, maxX: Int, maxY: Int): Boolean {
    val loopDirection = ROTATIONS.getValue(direction)

    var nextY = y
    var nextX = x

    while (true) {
//      println("Simulating $nextY,$nextX $loopDirection")
      when (loopDirection) {
        '^' -> nextY--
        'v' -> nextY++
        else -> nextY
      }

      when (loopDirection) {
        '>' -> nextX ++
        '<' -> nextX --
        else -> nextX
      }
//      println("Next $nextY,$nextX $loopDirection")

      if (nextX < 0 || nextX >= maxX || nextY < 0 || nextY >= maxY) {
        return false
      }

      if (map[nextY][nextX] == '#') {
        return false
      } else if (visits.contains(Triple(nextY, nextX, loopDirection))) {
//        println("Triplet ${Triple(nextY, nextX, loopDirection)}")
        return true
      }
    }
  }
}

fun main() {
  val TEST_INPUT = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
  """.trimIndent()

  val problem6 = Problem6()

  println(problem6.solve(problem6.parse(TEST_INPUT)))
  println(problem6.solve(problem6.parse(File("./sources/Problem6.source").readText())))

  println("bonus")
  println(problem6.solveBonus(problem6.parse(TEST_INPUT)))
  println(problem6.solveBonus(problem6.parse(File("./sources/Problem6.source").readText()), true))
}
