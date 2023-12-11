package fm6.util

object JsonIO {

  import java.io._
  import play.api.libs.json._

  // FileInputStream contains JSon objects and readObject reads the next object
  // This is a simplistic parser that just reads the input between a matching "{" - "}" pair
  def readObject(stream: FileInputStream): JsObject = {
    var level = 0 // how many open '{' there are
    var res = ""
    var done = false
    while (!done) {
      var d = stream.read()
      if (d == -1) return null
      res = res + d.toChar
      if (d == '{') level +=1 // conversion to char is done automatically
      else if (d == '}') {
        level -= 1
        if (level == 0) done = true
        else if (level < 0) {
          println(s"Syntax error in input file")
          null
        }
      }
    }
    Json.parse(res).as[JsObject]
  }

  class readObjects(stream: FileInputStream) extends Iterable[JsObject] {

    def this(file: File) = {
      this(new FileInputStream(file))
    }

    def this(fileName: String) = {
      this(new File(fileName).getCanonicalFile)
    }

    lazy val iterator = new Iterator[JsObject] {
      var last = readObject(stream)
      def hasNext = last != null
      def next() = {
        val res = last
        last = readObject(stream)
        res
      }
    }
  }

}
