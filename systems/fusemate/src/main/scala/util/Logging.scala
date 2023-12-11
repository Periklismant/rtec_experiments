
package fm6.util

object Logging {

  // Colorful strings 
  implicit class RainbowString(s: String) {
    import Console._

    /** Colorize the given string foreground to ANSI black */
    def black = BLACK + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def red = RED + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def green = GREEN + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def yellow = YELLOW + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def blue = BLUE + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def magenta = MAGENTA + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def cyan = CYAN + s + RESET
    /** Colorize the given string foreground to ANSI red */
    def white = WHITE + s + RESET

    /** Colorize the given string background to ANSI red */
    def onBlack = BLACK_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onRed = RED_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onGreen = GREEN_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onYellow = YELLOW_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onBlue = BLUE_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onMagenta = MAGENTA_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onCyan = CYAN_B + s + RESET
    /** Colorize the given string background to ANSI red */
    def onWhite = WHITE_B + s + RESET

    /** Make the given string bold */
    def bold = BOLD + s + RESET
    /** Underline the given string */
    def underlined = UNDERLINED + s + RESET
    /** Make the given string blink (some terminals may turn this off) */
    def blink = BLINK + s + RESET
    /** Reverse the ANSI colors of the given string */
    def reversed = REVERSED + s + RESET
    /** Make the given string invisible using ANSI color codes */
    def invisible = INVISIBLE + s + RESET

/*
    sed 's/\x1b\[[0-9;]*m//g'           # Remove color sequences only
    sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'    # Remove all escape sequences
    sed 's/\x1b\[[0-9;]*[mGKH]//g'      # Remove color and move sequences
    sed 's/\x1b\[[0-9;]*[mGKF]//g'      # Remove color and move sequences
 */

    // A regexp covering all color codes
    // val COLORED = raw"\u001B\[[0-9;]*m".r
    val COLORED = raw"\[[0-9;]*m".r

    /** Remove all color */
    def uncolored = COLORED.replaceAllIn(s, "")
  }

  private var noInfo = false
  def log(s: Any): Unit = {
    print((if (noInfo) "" else "[" + "info".yellow +"] ") + s.toString); noInfo = true; System.out.flush()
  }

  def logCr(): Unit = { println(); noInfo = false }

  def loglnDone(s: String = "done"): Unit = {
      println(" [" + s.green + "]"); noInfo = false
  }
  def logln(s: Any): Unit = { println("[" + "info".green + "] " + s.toString) }
  def warn(s: String): Unit = { println("[" + "warn".yellow + "] " + s) }
  def error(s: String): Unit = { println("[" + "error".red + "] " + s) }
  def fatalError(s: String): Unit = { println("[" + "fatalError".red + "] " + s); System.exit(1) }

  def loglnt(t: String, s: Any): Unit = {
    println("[" + t.blue + "] " + s.toString)
  }

  val Dingbats = "✁✂✃✄✆✈✉✏✑✒✓✗✙✚✛✜✝✞✟✠✡✢✣✤✥✦✧✩✪✫✱✲✳✴✵✶✻✼❍❏❐❑❒❖❘❙❚❛❜❝❞❶❷❸❹❺❻❼❽❾❿➀➁➂➃➄➅➆➇➈➉➊➋➌➍➎➏➐➑➒➓➔➘➙➚➛➜➝➞➟➠➡➢➣➤➥➦➧➨➩➪➫➬➭➮➯➱➲➳➴➵➶➷➸➹➾"

  def ding(n: Int) = Dingbats(n)

  def pding(n: Int): Unit = { print(ding(n)); System.out.flush() }

}
