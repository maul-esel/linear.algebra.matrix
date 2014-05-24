# What's this?
This project contains a small DSL (domain specific language) for working with matrices. It has an easy-to-read syntax and comes
with many matrix operations already built in (such as calculating a determinant, finding an equialent diagonal matrix, testing
matrices for equivalence, multiplying and adding matrices, ...). All the basic programming language constructs (loops, conditions,
	user-defined functions) are supported as well.

# Example
Let's dive right in with an example of the syntax:

<pre><code>
<span style="color:green">§ Single line comments</span>

<span style="color:green">§§
  multi line comments
§§</span>

<span style="color:blue">import</span> mylib; <span style="color:green">§ import functions from other files</span>

<span style="color:purple">int</span> x <span style="color:teal">:=</span> 3; <span style="color:green">§ every line must be ended with a semicolon</span>
<span style="color:purple">ℤ ∋</span> y <span style="color:teal">:=</span> 7; <span style="color:green">§ you can also specify types using this more mathematical notation</span>

<span style="color:purple">rational</span> z <span style="color:teal">:=</span> &lt;2/3&gt;; <span style="color:green">§ use this syntax for rational numbers</span>
<span style="color:purple">ℚ ∋</span> r <span style="color:teal">:=</span> &lt;4/9&gt; <span style="color:green">§ element notation is available for rationals as well</span>

x <span style="color:teal">:=</span> 3 <span style="color:teal">*</span> 7 <span style="color:teal">+</span> 21 <span style="color:teal">-</span> 2<span style="color:teal">^</span>3; <span style="color:green">§ basic arithmetic, including exponentiation</span>
<span style="color:purple">var</span> t <span style="color:teal">:=</span> x <span style="color:teal">/</span> y; <span style="color:green">§ variable types can be inferred, in this case it's a rational number</span>

<span style="color:green">§§ So let's get to matrices: §§</span>
<span style="color:purple">(2 ° 3)</span> A; <span style="color:green">§ specify matrix dimensions with "(&lt;lines&gt; ° &lt;columns&gt;)"</span>
A <span style="color:teal">:=</span> { <span style="color:green">§ easy-to-read matrix syntax</span>
  1 2 3
  0 0 1
};

<span style="color:purple">var</span> D <span style="color:teal">:=</span> { <span style="color:green">§ type inference works for matrices as well</span>
  1 0
  0 1
  1 1
};
<span style="color:purple">var</span> product <span style="color:teal">:=</span> A <span style="color:teal">*</span> D; <span style="color:green">§ multiply matrices (only works if dimensions are accordingly)</span>
<span style="color:purple">var</span> sum <span style="color:teal">:=</span> (A <span style="color:teal">*</span> D <span style="color:teal">+</span> A <span style="color:teal">*</span> D) <span style="color:teal">*</span> 3 <span style="color:teal">-</span> (A <span style="color:teal">*</span> D)<span style="color:teal">^</span>2; <span style="color:green">§ add, subtract, exponentiate (square) matrices</span>
<span style="color:purple">ℤ ∋</span> d <span style="color:teal">:=</span> <span style="color:teal">|</span>A <span style="color:teal">*</span> D<span style="color:teal">|</span>; <span style="color:green">§ calculate determinant</span>

<span style="color:blue">if</span> (<span style="color:teal">¬</span>(C <span style="color:teal">~</span> A)) { <span style="color:green">§ test for (non-) equivalence</span>
    C <span style="color:teal">:=</span> stdlib::strictly_diagonalize(A); <span style="color:green">§ use builtin stdlib functions</span>
}

<span style="color:purple">var</span> L <span style="color:teal">:=</span> <span style="color:blue">init</span> (<span style="color:purple">int</span> i..3, <span style="color:purple">int</span> j..3) <span style="color:blue">~></span> i <span style="color:teal">*</span> j; <span style="color:green">§ calculate matrix entries from line and column number</span>
<span style="color:purple">int</span> entry <span style="color:teal">:=</span> L[1,1]; <span style="color:green">§ access (and set) individual entries</span>

<span style="color:green">§ define custom functions</span>
<span style="color:blue">def</span> myfunc : (<span style="color:purple">int</span> a, <span style="color:purple">(2 ° 2)</span> A) -> <span style="color:purple">boolean</span> {
  <span style="color:green">§§
    NOTE:
    You can also define functions that take matrices of arbitrary sizes,
    or only square matrices, or only column vectors, or ....
  §§</span>
  <span style="color:blue">return</span> A[1,1] <span style="color:teal">=</span> a;
}
var result <span style="color:teal">:=</span> myfunc(A <span style="color:teal">*</span> D, 1);

<span style="color:blue">proc</span> @doSomething : () -> { <span style="color:green">§ functions without return value are called "proc"</span>
    <span style="color:green">§ TODO</span>
}
</code></pre>

# Full IDE support
This DSL is realized with the XText framework, which gives you a complete integration into the Eclipse editor,
with syntax highlighting, error markers and content assist.

# What's to come
The example above only uses integer matrices. But support is also planned for matrices with rational, real, complex
and polynomial entries. More builtin functions regarding explicit equivalences, matrix similarity etc. are planned.
