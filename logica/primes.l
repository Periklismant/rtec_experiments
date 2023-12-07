# Define natural numbers from 1 to 29.
N(x) :- x in Range(30);
# Define primes.
Prime(prime: x) :-
  N(x),
  x > 1,
  ~(
    N(y),
    y > 1,
    y != x,
    x % y == 0
  );
  