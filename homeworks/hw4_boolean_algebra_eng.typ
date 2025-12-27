#import "common.typ": *
#show: template

#set page(
  paper: "a4",
  margin: (top: 3cm, rest: 2cm),
  header: [
    #set text(10pt)
    #smallcaps[*Homework Assignment \#4*]
    #h(1fr)
    #link("https://github.com/Lipen/discrete-math-course")[*Discrete Mathematics*]
    \
    *Boolean Algebra*
    #h(1fr)
    *$#emoji.leaf.maple$ Fall 2025*
    #place(bottom, dy: 0.4em)[
      #line(length: 100%, stroke: 0.6pt)
    ]
  ],
)

#set text(12pt)
#set par(justify: true)

#show table.cell.where(y: 0): strong

#show heading.where(level: 2): set block(below: 1em, above: 1.4em)

#show emph: set text(fill: blue.darken(20%))

// Custom operators and notation
#let power(x) = $cal(P)(#x)$
#let pair(a, b) = $chevron.l #a, #b chevron.r$
#let triple(a, b, c) = $chevron.l #a, #b, #c chevron.r$
#let card(x) = $abs(#x)$
#let DNF = math.op("DNF")
#let CNF = math.op("CNF")
#let BCF = math.op("BCF")
#let ANF = math.op("ANF")
#let ITE = math.op("ITE")
#let majority = math.op("majority")
#let RM = math.op("RM")
#let bfunc(n, k) = $f^((#n))_#k$

// Color helpers
#let Green(x) = text(green.darken(20%), x)
#let Red(x) = text(red.darken(20%), x)
#let Blue(x) = text(blue.darken(20%), x)
#let Orange(x) = text(orange.darken(20%), x)

#let True = Green(`true`)
#let False = Red(`false`)

#let YES = Green(sym.checkmark)
#let NO = Red(sym.crossmark)

// Task list helper
#let tasklist(id, cols: 1, body) = {
  let s = counter(id)
  s.update(1)
  set enum(numbering: _ => context {
    s.step()
    s.display("1.")
  })
  columns(cols, gutter: 1em)[#body]
}

#align(center, [
  "You cannot step twice into the same river." — _Heraclitus_
])


== 1. Karnaugh Maps

#block(sticky: true)[*a) Generate the Function*]

+ Compute
  #footnote[
    You can use any programming language, tool or online service to compute SHA-256 hashes.
  ]
  the SHA-256 _hash_ $h$ of string $s =$ "DM Fall 2025 HW4" (without quotes).
+ Split $h$ into eight 32-bit blocks: $h = h_0 || h_1 || dots || h_7$ where each $h_i$ is 32 bits.
+ XOR all blocks together: $d = h_0 xor h_1 xor dots.c xor h_7$.
+ Apply the mask: $w = d xor #`0x71be8976`$, giving the 32-bit result $w = (w_0 w_1 dots w_(31))_2$.

The resulting bit string $w$ encodes the 5-variable _boolean function_ $f^((5))$: bit $w_0$ (MSB) represents $f(0,0,0,0,0)$, and bit $w_(31)$ (LSB) represents $f(1,1,1,1,1)$.

*Check:* Hash $h$ ends with $dots#`01100010`$; the value $d$ (before masking) begins with $#`0000`dots$

#block(sticky: true)[*b) Trying to master K-Map*]

Construct a 5-variable _Karnaugh map_ for your function using the template below:

#align(center)[
  #import cetz: canvas, draw
  #canvas({
    import draw: *

    // Grid
    grid(
      (0, 0),
      (8, 4),
      stroke: 0.4pt,
    )

    // Column headers (CDE)
    content((0.5, 4), [000], anchor: "south", padding: 0.2)
    content((1.5, 4), [001], anchor: "south", padding: 0.2)
    content((2.5, 4), [011], anchor: "south", padding: 0.2)
    content((3.5, 4), [010], anchor: "south", padding: 0.2)
    content((4.5, 4), [110], anchor: "south", padding: 0.2)
    content((5.5, 4), [111], anchor: "south", padding: 0.2)
    content((6.5, 4), [101], anchor: "south", padding: 0.2)
    content((7.5, 4), [100], anchor: "south", padding: 0.2)

    // Row headers (AB)
    content((0, 3.5), [00], anchor: "east", padding: 0.2)
    content((0, 2.5), [01], anchor: "east", padding: 0.2)
    content((0, 1.5), [11], anchor: "east", padding: 0.2)
    content((0, 0.5), [10], anchor: "east", padding: 0.2)

    // Side annotations for variables
    line((-0.7, 0), (-0.7, 2))
    content((-0.7, 1), std.rotate(-90deg)[$A$], anchor: "east", padding: 0.2)
    line((8.2, 1), (8.2, 3))
    content((8.2, 2), std.rotate(-90deg)[$B$], anchor: "west", padding: 0.2)
    line((4, -0.6), (8, -0.6))
    content((6, -0.6), [$C$], anchor: "north", padding: 0.2)
    line((2, -0.3), (6, -0.3))
    content((3, -0.3), [$D$], anchor: "north", padding: 0.2)
    line((1, 4.7), (3, 4.7))
    content((2, 4.7), [$E$], anchor: "south", padding: 0.2)
    line((5, 4.7), (7, 4.7))
    content((6, 4.7), [$E$], anchor: "south", padding: 0.2)
  })
]

#align(center, image("willem-dafoe.png", width: 50%))

#v(3cm)

#block(sticky: true)[*c) Find Minimal Forms*]

+ Find _minimal_ DNF and CNF for $f$ using your K-map.
+ Count all _prime implicants_. #link("https://www.youtube.com/watch?v=qN2pcweX3iI")[#underline("(PI)")].
+ If inputs where $A and B and C = 1$ are _don't-care conditions_
  #footnote[
    Don't-care conditions are input combinations whose output values don't matter, allowing flexibility in minimization.
    They can be treated as either 0 or 1 to produce smaller expressions.
  ]
  , how do the minimal forms change?


#block(sticky: true)[*d) Analysis and Limitations*]

+ How many fewer _literals_ does your minimal DNF use compared to full minterm expansion?
+ Which is more compact for your function: DNF or CNF? Why?

#v(1cm)

== 2. Boolean Function Analysis

Consider the following four functions
#footnote[
  Notation: $bfunc(n, k)$ is the $k$-th Boolean function of $n$ variables, where $k$ is the decimal truth table value, which, represented in binary as $(f_0 f_1 dots f_(2^n-1))_2$, corresponds to values of $f$: MSB $f_0$ is $f(0,dots,0)$, LSB $f_(2^n-1)$ is $f(1,dots,1)$.
]:

#tasklist("prob3", cols: 2)[
  + $f_1 = bfunc(4, 47541)$

  + $f_2 = sum m(1, 4, 5, 6, 8, 12, 13)$

  #colbreak()

  + $f_3 = bfunc(4, 51011) xor bfunc(4, 40389)$

  + $f_4 = A overline(B) D + overline(A) thin overline(C) D + overline(B) C overline(D) + A overline(C) D$
]

#block(sticky: true)[*a) Boolean Function Decomposition*]

+ Decompose to SoP using _Shannon expansion_ for function _4._ (without constructing the truth table).
+ Construct PoS for function _4._ from the known SoP.

#block(sticky: true)[*b) K-Maps*]

Draw and fill the K-map for each function.

#block(sticky: true)[*c) Prime Implicants*]

+ List all _implicants_ of function _4._
+ Using the K-map, find all _prime implicants_ of function _4._ (Blake Canonical Form)
  #footnote[
    Reduced DNF - Blake Canonical Form
  ]
+ Using the _Quine-McCluskey method_, find all _prime implicants_ of function _4._ (Blake Canonical Form)
+ Determine which of them are _essential_
  #link("https://www.youtube.com/watch?v=skZGD4EAuIM")[#underline("(EPI)")].

#block(sticky: true)[*d) Minimal DNF and CNF*]

+ Using _Petrick's method_ (on the already obtained result of the Quine-McCluskey method) find the minimal DNF of function _4._
+ Using _algebraic method_ find the minimal CNF of function _4._

#block(sticky: true)[*e) Algebraic Normal Form*]

+ Construct the ANF for function _1._ using _Pascal's method_.
+ Construct the ANF for function _2._ using _triangle method_.
+ Construct the ANF for function _4._ using _K-map_.

#block(sticky: true)[*f) Zhegalkin Polynomial*]

+ Identify the _algebraic degree_ of each function from from part (e).
+ Which function has the highest degree? Is it _maximal_ for this number of variables?
+ Prove that $deg(f xor g) <= max(deg(f), deg(g))$. Find an example with strict inequality.

#v(1cm)

== 3. Reed–Muller Codes 

(optional, +1 extra point)

In 1971, Mariner 9 transmitted the first close-up Mars images using Reed–Muller codes.
These error-correcting codes are built from Boolean functions with restricted algebraic degree.

The Reed–Muller code $RM(r, m)$ consists of all Boolean functions $f: FF_2^m to FF_2$ with $deg(f) <= r$.

*Parameters:* length $n = 2^m$, dimension $k = sum_(i=0)^r binom(m, i)$, minimum _Hamming distance_
#footnote[
  The _Hamming distance_ between two codewords is the number of positions in which they differ.
  // The minimum distance of a code is the smallest Hamming distance between any two distinct codewords, determining error correction capability: a code with minimum distance $d$ can detect up to $d-1$ errors and correct up to #box[$t = floor((d-1)"/"2)$] errors.
]
$d = 2^(m-r)$.

*Generator matrix construction:*
Rows correspond to _monomials_ of degree $<= r$.
Columns correspond to inputs $(x_1, dots, x_m) in FF_2^m$.
Entry $(i,j)$ is the value of monomial $i$ evaluated at input $j$.

#example[
  $RM(1, 2)$ has monomials ${1, x_1, x_2}$ and inputs ${(0,0), (0,1), (1,0), (1,1)}$:
  $
    G = mat(1, 1, 1, 1; 0, 0, 1, 1; 0, 1, 0, 1)
  $

  Message $(1, 0, 1)$ encodes to $(1, 0, 1, 0)$ via $bold(c) = bold(u) G$.
]

#block(sticky: true)[*a) Code Construction*]

Consider $RM(1, 3)$:

+ Compute the code parameters: length $n$, dimension $k$, minimum distance $d$, and error correction capability $t = floor((d-1)/2)$.
+ Construct the $4 times 8$ generator matrix $G$.
  Rows correspond to monomials ${1, x_1, x_2, x_3}$.
  Columns are ordered: $(0,0,0), (0,0,1), dots, (1,1,1)$, where column $i$ (for $i = 1, dots, 8$) corresponds to the binary representation of $i-1$.
+ Encode the message $bold(u) = (1, 0, 1, 1)$ into codeword $bold(c) = bold(u) G$.

#block(sticky: true)[*b) Single-Error Correction*]

+ Flip _one_ bit at position $i in {1, dots, 8}$ of your codeword $bold(c)$ to simulate a transmission error, obtaining received word $bold(r) = (r_1, dots, r_8)$.

+ Apply majority-logic decoding to recover the ANF coefficients $(a_0, a_1, a_2, a_3)$:
  - For each $a_j$ where $j > 0$: identify all pairs of positions $(p, q)$ whose input vectors differ only in variable $x_j$
    Each pair gives a vote $v = r_p xor r_q$.
    Set $a_j = majority(v_1, v_2, dots)$.
  - For $a_0$: after determining $a_1, a_2, a_3$, compute $a_0 = r_1 xor (a_1 dot 0) xor (a_2 dot 0) xor (a_3 dot 0) = r_1$, since position 1 corresponds to input $(0,0,0)$.
    #footnote[
      In case of tied votes, choose 0 as the default value.
      Note that with a single error, ties should not occur for $RM(1, 3)$.
    ]

+ Verify that the decoded message $(a_0, a_1, a_2, a_3)$ equals your original $bold(u) = (1, 0, 1, 1)$.

+ Show the detailed computation for coefficient $a_1$: list all pairs differing in $x_1$, compute each XOR vote, and determine the majority.