package fm6

package object util {

  val osName = System.getProperty("os.name").toLowerCase()
  val isMacOs = osName.startsWith("mac os x")

}
