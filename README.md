# What's this?
This project contains a small DSL (domain specific language) for working with matrices. It has an easy-to-read syntax and comes
with many matrix operations already built in (such as calculating a determinant, finding an equialent diagonal matrix, testing
matrices for equivalence, multiplying and adding matrices, ...). All the basic programming language constructs (loops, conditions,
user-defined functions) are supported as well.

# Example
Let's dive right in with an example of the syntax:

```
§ Single line comments

§§
  multi line comments
§§

import mylib; § import functions from other files

int x := 3; § every line must be ended with a semicolon
ℤ ∋ y := 7; § you can also specify types using this more mathematical notation

rational z := &lt;2/3&gt;; § use this syntax for rational numbers
ℚ ∋ r := &lt;4/9&gt; § element notation is available for rationals as well

x := 3 * 7 + 21 - 2^3; § basic arithmetic, including exponentiation
var t := x / y; § variable types can be inferred, in this case it's a rational number

§§ So let's get to matrices: §§
(2 ° 3) A; § specify matrix dimensions with "(&lt;lines&gt; ° &lt;columns&gt;)"
A := { § easy-to-read matrix syntax
  1 2 3
  0 0 1
};

var D := { § type inference works for matrices as well
  1 0
  0 1
  1 1
};
var product := A * D; § multiply matrices (only works if dimensions are accordingly)
var sum := (A * D + A * D) * 3 - (A * D)^2; § add, subtract, exponentiate (square) matrices
ℤ ∋ d := |A * D|; § calculate determinant

if (¬(C ~ A)) { § test for (non-) equivalence
    C := stdlib::strictly_diagonalize(A); § use builtin stdlib functions
}

var L := init (int i..3, int j..3) ~> i * j; § calculate matrix entries from line and column number
int entry := L[1,1]; § access (and set) individual entries

§ define custom functions
def myfunc : (int a, (2 ° 2) A) -> boolean {
  §§
    NOTE:
    You can also define functions that take matrices of arbitrary sizes,
    or only square matrices, or only column vectors, or ....
  §§
  return A[1,1] = a;
}
var result := myfunc(A * D, 1);

proc @doSomething : () -> { § functions without return value are called "proc"
    § TODO
}
```

# Full IDE support
This DSL is realized with the XText framework, which gives you a complete integration into the Eclipse editor,
with syntax highlighting, error markers and content assist.

# What's to come
The example above only uses integer matrices. But support is also planned for matrices with rational, real, complex
and polynomial entries. More builtin functions regarding explicit equivalences, matrix similarity etc. are planned.

# Dependencies

* XText
* XSemantics
* Google Guice, Google Guice Assisted Inject
* jsr305