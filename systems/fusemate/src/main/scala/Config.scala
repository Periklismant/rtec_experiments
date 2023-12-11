package fm6

object Config {
  // Fusemate inference engine configuration
  // See README.md for details

  import scala.util.matching.Regex
  var stratification = true // Whether to use stratification on predicate symbols
  var showStratification = true
  var verbose = false // Prints literals as they are derived. Only those literals whose predicate matches 'verbosePreds' are printed.
  var verbosePreds = Set(".*".r) // E.g., `Set(".*dog.*", ".*cat.*")` The default ".*".r matches every name
  var debug = false
  var logRestartHeads = false
  var xlog = false // whetrher to print xlog pseudoatoms
  var DLCaching = true // Whether to cache results of description logic sat checks 
}

