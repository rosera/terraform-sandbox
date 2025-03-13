variable"items" {
  type=map(any)
  description="Qwiklabs map variable"
  default={
    "first" = { name = "Mabel", age = 49 },
    "second" = { name = "Andy", age = 52 },
    "third" = { name = "Pete", age = 25 }
  }
}
