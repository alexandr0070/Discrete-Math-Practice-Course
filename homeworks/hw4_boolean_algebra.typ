#import "common.typ": *
#show: template

#set page(
  paper: "a4",
  margin: (top: 3cm, rest: 2cm),
  header: [
    #set text(10pt)
    #smallcaps[*Домашняя работа \#4*]
    #h(1fr)
    #smallcaps[*Дискретная математика*]
    \
    *Булева алгебра*
    #h(1fr)
    *$#emoji.leaf.maple$ Осень 2025*
    #place(bottom, dy: 0.4em)[
      #line(length: 100%, stroke: 0.6pt)
    ]
  ],
)

#set text(12pt)
#set par(justify: true)

#show table.cell.where(y: 0): strong

#show heading.where(level: 2): set block(below: 1em, above: 1.4em)

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
  "Нельзя дважды войти в одну и ту же реку." — _Гераклит_
])


== 1. Карты Карно

#block(sticky: true)[*a) Генерация функций*]

+ Вычислите
  #footnote[
    Для вычисления самих хешей SHA-256 можете использовать что угодно.
  ]
  #text(fill: blue, [хеш]) SHA-256 $h$ строки $s =$ "DM Fall 2025 HW4" (без кавычек).
+ Разделите $h$ на восемь 32-битных блоков: $h = h_0 || h_1 || dots || h_7$ где каждый $h_i$ имеет длину 32 бита.
+ Примените операцию XOR ко всем блокам: $d = h_0 xor h_1 xor dots.c xor h_7$.
+ Примените маску: $w = d xor #`0x71be8976`$, получив 32-битный результат  $w = (w_0 w_1 dots w_(31))_2$.

Полученная битовая строка $w$ кодирует #text(fill: blue, [булеву функцию]) от 5 переменных $f^((5))$: бит $w_0$ (старший бит, MSB) представляет $f(0,0,0,0,0)$, и бит $w_(31)$ (младший бит, LSB) представляет $f(1,1,1,1,1)$.

*Проверка:* Хеш $h$ заканчивается на $dots#`01100010`$; значение $d$ (до наложения маски) начинается с $#`0000`dots$


#block(sticky: true)[*b) В попытках освоить K-Map*]

Постройте #text(fill: blue, [карту Карно]) для 5 переменных для вашей функции, используя шаблон ниже:

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

#v(2cm)

#block(sticky: true)[*c) Нахождение минимальных форм*]

+ Найдите #text(fill: blue, [минималные]) ДНФ и КНФ для $f$ с помощью вашей карты Карно.
+ Подсчитайте все #text(fill: blue, [простые импликанты]) #link("https://www.youtube.com/watch?v=qN2pcweX3iI")[#underline("(prime implicants)")].
+ Если входы, где $A and B and C = 1$ это #text(fill: blue, [_don't-care conditions_])
  #footnote[
    Недоопределенная функция
  ]
  , как изменятся минимальные формы?


#block(sticky: true)[*d) Анализируем результат*]

+ На сколько #text(fill: blue, [литералов]) меньше использует ваша минимальная ДНФ по сравнению с СДНФ?
+ Что для вашей функции более компактно: ДНФ или КНФ? Почему?

#v(1cm)

== 2. Анализ булевых функций


Рассмотрим следующие четыре функции:
#footnote[
  Обозначение: $bfunc(n, k)$ это $k$-я булева функция от $n$ переменных, где $k$ десятичное значение таблицы истинности, которое, представленное в двоичном виде как $(f_0 f_1 dots f_(2^n-1))_2$, соответствует значениям $f$: MSB $f_0$ is $f(0,dots,0)$, LSB $f_(2^n-1)$ is $f(1,dots,1)$.
]:

#tasklist("prob3", cols: 2)[
  + $f_1 = bfunc(4, 47541)$

  + $f_2 = sum m(1, 4, 5, 6, 8, 12, 13)$

  #colbreak()

  + $f_3 = bfunc(4, 51011) xor bfunc(4, 40389)$

  + $f_4 = A overline(B) D + overline(A) thin overline(C) D + overline(B) C overline(D) + A overline(C) D$
]

#block(sticky: true)[*a): Разложние булевых функций*]

+ Разложить до СДНФ по #text(fill: blue, [Шеннону]) функцию _3._ (не строя таблицу истинности).
+ Построить СКНФ функции _3._ по известной СДНФ

#block(sticky: true)[*b): K-Maps*]

Постройте карту Карно для каждой функции.

#block(sticky: true)[*c): Простые импликанты*]

+ Перечислите все #text(fill: blue, [импликанты]) функции _4._
+ При помощи карты Карно найдите все #text(fill: blue, [простые импликанты]) функции _4._ (каноническая форма Блейка)
  #footnote[
    Сокращенная ДНФ - каноническая форма Блейка
  ]
+ При помощи #text(fill: blue, [метода Квайна-МакКласки]) найдите все простые импликанты функции _4._ (каноническая форма Блейка)
+ Определите, какие из них являются #text(fill: blue, [ядерными]) #link("https://www.youtube.com/watch?v=skZGD4EAuIM")[#underline("(EPI)")].

#block(sticky: true)[*d): Минимальные ДНФ и КНФ*]

+ Используя #text(fill: blue, [метод Петрика]) (на уже полученном результате метода Квайна-МакКласки) найдите минимальную ДНФ функции .
+ Используя #text(fill: blue, [алгебраический метод]) найдите минимальную КНФ функции _4._

#block(sticky: true)[*e) Алгебраическая нормальная форма*]

+ Постройте АНФ для функции _1._ используя #text(fill: blue, [метод Паскаля]).
+ Постройте АНФ для функции _2._ используя #text(fill: blue, [метод треугольника]).
+ Постройте АНФ для функции _4._ используя #text(fill: blue, [K-map]).

#block(sticky: true)[*f) Полином Жегалкина*]

+ Определите #text(fill: blue, [степень полинома]) каждой функции из части (e).
+ Какая функция имеет наивысшую степень? Является ли она #text(fill: blue, [максимальной]) для этого количества переменных?
+ Докажите, что $deg(f xor g) <= max(deg(f), deg(g))$. Найдите пример со строгим неравенством.

#v(1cm)

== 3. Коды Рида–Маллера 

_(необязательное, +1 доп. балл)_

В 1971 году Маринер-9 передал первые снимки Марса крупным планом, используя коды Рида–Маллера. Эти помехоустойчивые коды построены из булевых функций с ограниченной степенью полинома.

Код Рида–Маллера $RM(r, m)$ состоит из всех булевых функций $f: FF_2^m to FF_2$ у которых $deg(f) <= r$.

*Параметры:* длина $n = 2^m$, размерность $k = sum_(i=0)^r binom(m, i)$, #text(fill: blue, [минимальное расстояние Хэмминга])
#footnote[
  _Расстояние Хэмминга_ между двумя кодовыми словами — это количество позиций, в которых они различаются.
  // The minimum distance of a code is the smallest Hamming distance between any two distinct codewords, determining error correction capability: a code with minimum distance $d$ can detect up to $d-1$ errors and correct up to #box[$t = floor((d-1)"/"2)$] errors.
]
$d = 2^(m-r)$.

*Построение порождающей матрицы:* Строки соответствуют #text(fill: blue, [мономам]) степени $<= r$. Столбцы соответствуют входамs $(x_1, dots, x_m) in FF_2^m$ . Элемент $(i,j)$ — это значение монома $i$ вычисленное на входе $j$.

#example[
  $RM(1, 2)$ имеет мономы ${1, x_1, x_2}$ и входы ${(0,0), (0,1), (1,0), (1,1)}$:
  $
    G = mat(1, 1, 1, 1; 0, 0, 1, 1; 0, 1, 0, 1)
  $

  Сообщение $(1, 0, 1)$ кодируется в $(1, 0, 1, 0)$ через $bold(c) = bold(u) G$.
]

#block(sticky: true)[*a) Построение кода*]

Рассмотрим $RM(1, 3)$:

+ Вычислите параметры кода: длина $n$, размерность $k$, минимальное расстояние $d$,  и способность исправления ошибок $t = floor((d-1)/2)$.
+ Постройте порождающую матрицу $G$ ($4 times 8$).
  Строки соответствуют мономам ${1, x_1, x_2, x_3}$.
  Столбцы упорядочены: $(0,0,0), (0,0,1), dots, (1,1,1)$, где столбец $i$ (for $i = 1, dots, 8$) соответствует двоичному представлению числа $i-1$.
+ Закодируйте сообщение $bold(u) = (1, 0, 1, 1)$ в кодовое слово $bold(c) = bold(u) G$.

#block(sticky: true)[*b) Исправление одиночной ошибки*]

+ Инвертируйте _один_ бит в позиции $i in {1, dots, 8}$ вашего кодового слов $bold(c)$ чтобы смоделировать ошибку передачи, получив принятое слово $bold(r) = (r_1, dots, r_8)$.

+ Декодируйте для восстановления коэффициентов АНФ $(a_0, a_1, a_2, a_3)$:
  - Для каждого $a_j$ где $j > 0$: определите все пары позиций $(p, q)$ чьи входные векторы различаются только переменной $x_j$
    Каждая пара дает _голос_ $v = r_p xor r_q$.
    Установите $a_j = majority(v_1, v_2, dots)$.
  - Для $a_0$: после определения $a_1, a_2, a_3$, вычислите $a_0 = r_1 xor (a_1 dot 0) xor (a_2 dot 0) xor (a_3 dot 0) = r_1$, так как позиция 1 соответствует входу $(0,0,0)$.
    #footnote[
      В случае ничьей в голосовании выберите 0 в качестве значения по умолчанию. Заметьте, что при одной ошибке для $RM(1, 3)$ ничьих возникать не должно..
    ]

+  Убедитесь, что раскодированное сообщение $(a_0, a_1, a_2, a_3)$ равно вашему исходному $bold(u) = (1, 0, 1, 1)$.

+ Покажите подробное вычисление для коэффициента $a_1$: перечислите все пары, различающиеся по $x_1$, вычислите каждый XOR-голос и определите большинство.

