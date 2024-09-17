/// Constrain a value to the range [lo, hi]
constrain value/float lo/float hi/float:
  return value <= lo ? lo : (value >= hi ? hi : value)

/// Map a value from [from-lo, from-hi] to [to-lo, to-hi]
map value/float from-lo/float from-hi/float to-lo/float to-hi/float:
  return (value - from-lo) * (to-hi - to-lo) / (from-hi - from-lo) + to-lo

is-near a/float b/float:
  return (a - b).abs < 0.01
