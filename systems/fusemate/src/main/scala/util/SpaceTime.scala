package fm6.util

object SpaceTime {

  import java.time.LocalDateTime
  import java.time.temporal.ChronoUnit._

  /*
   * Space
   */

  // Decimal degrees to meters
  val DDToMeters: Double = 111139.0

  case class Coord(lat: Double, lng: Double) {

    def isValid = lat.abs != 180 && lng.abs != 180 && lat != 0 && lng != 0

    /** Distance of this `Coord` to another `Coord`
      * (Slightly obsolete)
      * @param other the other Coord
      * @return distance in meters
      */

    def distanceTo(other: Coord) = Dist.between(this, other).meters

    // Obsolete: use - and / operations of Dist 
    // def subVectorTo(other: Coord, steps:Int): Coord = {
    //   val deltaLat = (other.lat - lat)
    //   val deltaLng = (other.lng - lng)
    //   // Abuse of Coord for representing a delta - don't do that
    //   Coord(deltaLat/steps, deltaLng/steps)
    // }

    // Abuse of Coord for representing a vector - don't do that
    // Obsolete: use + and * operations of Dist 
    // def addSubVectors(vector: Coord, times:Int): Coord = {
    //   val newLat = (lat + vector.lat * times)
    //   val newLng = (lng + vector.lng * times)
    //   Coord(newLat, newLng)
    // }

    def midPointTo(other: Coord) = {
      // todo: incorrect because of modulo 180 - fix eventually
      Coord((lat + other.lat)/2, (lng + other.lng)/2)
    }

    def + (d: Dist) = Coord(lat + d.lat / DDToMeters, lng + d.lng / DDToMeters)
  }

  implicit class MyLong(d: Long) {
    def toDistanceString = if (d > 1000) "%1.1fkm".format(d.toDouble / 1000) else "%dm".format(d)
  }

  // Distance vector in meters
  case class Dist(lat: Double, lng: Double) {
    def meters = math.sqrt(lat * lat + lng * lng).toLong
    // Vector addition and subtraction
    def +(d: Dist) = Dist(lat + d.lat, lng + d.lng)
    def -(d: Dist) = Dist(lat - d.lat, lng - d.lng)
    // Scalar operations
    def *(n: Int) = Dist(lat * n, lng * n)
    def /(n: Int) = Dist(lat / n, lng / n)
  }

  implicit class myIntForMult(n: Int) {
    def *(d: Dist) = d * n
  }


  object Dist {
    // todo: c1 and c2 should be interchanged
    def between(from: Coord, to: Coord) = Dist(to.lat*DDToMeters - from.lat*DDToMeters, to.lng*DDToMeters - from.lng*DDToMeters)
    def from(speed: Speed, period: Long) = Dist(speed.lat * period, speed.lng * period)
  }

  // Speed vector in meters / second
  case class Speed(lat: Double, lng: Double) {
    def metersPerSec = math.sqrt(lat * lat + lng * lng)
    def kmh = metersPerSec * 3.6
  }

  object Speed {
    // period in seconds
    def from(dist: Dist, period: Long) = Speed(dist.lat / period, dist.lng / period)
  }


  /*
   * Time
   */

  // A thin wrapper around LocalDateTime for some added functionality 
  implicit class MyLocalDateTime(t: LocalDateTime) {
    def isBeforeOrEqual(s: LocalDateTime) = (t isEqual s) || (t isBefore s)
    def isAfterOrEqual(s: LocalDateTime) = (t isEqual s) || (t isAfter s)
    def where(year: Int = t.getYear, month: Int = t.getMonthValue, dayOfMonth: Int = t.getDayOfMonth, hour: Int = t.getHour, minute: Int = t.getMinute, second: Int = t.getSecond) =
      LocalDateTime.of(year, month, dayOfMonth, hour, minute, second, 0)
    // def toLocalDateTimeComp = LocalDateTimeComp(t.getYear, t.getMonthValue, t.getDayOfMonth, t.getHour, t.getMinute, t.getSecond, t.getOffset)
  }

  implicit class MyString(s: String) {
    def toLocalDateTime = LocalDateTime.parse(s)
  }

  def DHMtoString(d: Int, h: Int, m: Int) = (d, h, m) match {
    case (0, 0, m) => s"${m}min"
    case (0, h, m) => s"${h}hr ${m}min"
    case (d, h, m) => s"${d}day ${h}hr ${m}min"
  }

  def DHMStoString(d: Int, h: Int, m: Int, s: Int) = (d, h, m, s) match {
    case (0, 0, 0, s) => s"${s}sec"
    case (0, 0, m, s) => s"${m}min ${s}sec"
    case (0, h, m, s) => s"${h}hr ${m}min ${s}sec"
    case (d, h, m, s) => s"${d}day ${h}hr ${m}min"
  }

  implicit class MyDurationLong(duration: Long) {
    def minsToDHMString = DHMtoString((duration / (60 * 24)).toInt, ((duration / 60) % 24).toInt, (duration % 60).toInt)
    def secsToDHMSString = DHMStoString((duration / (60 * 60 * 24)).toInt, ((duration / (60 * 60)) % 24).toInt, ((duration / 60) % 60).toInt, (duration % 60).toInt)
  }

  def earlierOf(t1: LocalDateTime, t2: LocalDateTime) =  if (t1 isBefore t2) t1 else t2
  def laterOf(t1: LocalDateTime, t2: LocalDateTime) =  if (t1 isAfter t2) t1 else t2

  case class Period(start: LocalDateTime, end: LocalDateTime) {
    require(start isBeforeOrEqual end)

    lazy val durationMinutes = MINUTES.between(start, end)
    lazy val durationSeconds = SECONDS.between(start, end)
    lazy val midPoint = start plusSeconds durationSeconds/2
    lazy val toDHMString = durationMinutes.minsToDHMString
    def intersect(other: Period) = {
      val (s,e) = (laterOf(start, other.start), earlierOf(end, other.end))
      if (s isBeforeOrEqual e) Some(s,e) else None
    }
  }
}
