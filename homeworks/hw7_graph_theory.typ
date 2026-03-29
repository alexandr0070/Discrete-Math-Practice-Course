#import "common.typ": *
#show: template

#set page(
  paper: "a4",
  margin: (top: 3cm, rest: 2cm),
  header: [
    #set text(10pt)
    #smallcaps[*Домашняя работа \#7*]
    #h(1fr)
    #smallcaps[*Дискретная математика*]
    \
    *Теория графов*
    #h(1fr)
    *$#emoji.flower.pink$ Весна 2026*
    #place(bottom, dy: 0.4em)[
      #line(length: 100%, stroke: 0.6pt)
    ]
  ],
)

#set text(12pt)
#set par(justify: true)

#show table.cell.where(y: 0): strong

#show heading.where(level: 2): set block(below: 1em, above: 1.4em)

// Custom operators for graph theory
#let dist = math.op("dist")
#let diam = math.op("diam")
#let rad = math.op("rad")
#let girth = math.op("girth")
#let Center = math.op("center")
#let ecc = math.op("ecc")
#let deg = math.op("deg")
#let Adj = math.op("Adj")

#let pair(a, b) = $angle.l #a, #b angle.r$

// Color helpers
#let Green(x) = text(green.darken(20%), x)
#let Red(x) = text(red.darken(20%), x)
#let Blue(x) = text(blue.darken(20%), x)
#let Orange(x) = text(orange.darken(20%), x)

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

// Fancy box
#let Box(body, align: left, inset: 0.8em) = std.align(align)[
  #box(
    stroke: 0.4pt + gray,
    inset: inset,
    radius: 3pt,
  )[
    #set std.align(left)
    #set text(size: 10pt, style: "italic")
    #body
  ]
]

// Fancy block
#let Block(body, ..args) = {
  block(
    body,
    inset: (x: 1em),
    stroke: (left: 3pt + gray),
    outset: (y: 3pt, left: -3pt),
    ..args,
  )
}

// Graph drawing helpers
#import fletcher: diagram, edge, node, shapes
#let vertex(pos, lbl, name, ..args) = blob(
  pos,
  lbl,
  shape: shapes.circle,
  radius: 8pt,
  name: name,
  ..args,
)

#align(center, [
  "A graph is worth a thousand words." — _Фрэнк Харари_
])

== 1. Закладываем базис

#align(center)[
  #grid(
    columns: 3,
    align: horizon,
    column-gutter: 2em,
    [
      #diagram(
        spacing: 2em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((0, 0), $1$, <a>, tint: blue),
        vertex((1, 0), $2$, <b>, tint: blue),
        vertex((2, 0), $3$, <c>, tint: blue),
        vertex((0, 1), $4$, <d>, tint: blue),
        vertex((1, 1), $5$, <e>, tint: blue),
        vertex((2, 1), $6$, <f>, tint: blue),
        vertex((0, 2), $7$, <g>, tint: blue),
        vertex((1, 2), $8$, <h>, tint: blue),
        vertex((2, 2), $9$, <i>, tint: blue),
        edge(<a>, <b>),
        edge(<b>, <c>),
        edge(<d>, <e>),
        edge(<e>, <f>),
        edge(<g>, <h>),
        edge(<h>, <i>),
        edge(<a>, <d>),
        edge(<b>, <e>),
        edge(<c>, <f>),
        edge(<d>, <g>),
        edge(<e>, <h>),
        edge(<f>, <i>),
        edge(<a>, <e>),
        edge(<e>, <i>),
        edge(<c>, <e>),
        edge(<e>, <g>),
      )
    ],
    [
      #diagram(
        spacing: 2em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((1, 1.5), $a$, <a>, tint: blue),
        vertex((0, 1), $b$, <b>, tint: blue),
        vertex((2, 1), $c$, <c>, tint: blue),
        vertex((0, 0), $d$, <d>, tint: blue),
        vertex((1, 0), $e$, <e>, tint: blue),
        vertex((2, 0), $f$, <f>, tint: blue),
        vertex((3, 1), $g$, <g>, tint: blue),
        vertex((3, 0), $h$, <h>, tint: blue),
        edge(<a>, <b>, bend: 20deg),
        edge(<a>, <c>, bend: -20deg),
        edge(<b>, <d>),
        edge(<b>, <e>),
        edge(<c>, <e>),
        edge(<c>, <f>),
        edge(<c>, <g>),
        edge(<d>, <e>),
        edge(<e>, <f>),
        edge(<f>, <h>),
        edge(<g>, <h>),
        edge(<b>, <c>),
      )
    ],
    [
      #diagram(
        spacing: 1.5em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((-90deg + 360deg / 8 * 0, 1.3), $a$, tint: blue, <a>),
        vertex((-90deg + 360deg / 8 * 1, 1.3), $b$, tint: blue, <b>),
        vertex((-90deg + 360deg / 8 * 2, 1.3), $c$, tint: blue, <c>),
        vertex((-90deg + 360deg / 8 * 3, 1.3), $d$, tint: blue, <d>),
        vertex((-90deg + 360deg / 8 * 4, 1.3), $e$, tint: blue, <e>),
        vertex((-90deg + 360deg / 8 * 5, 1.3), $f$, tint: blue, <f>),
        vertex((-90deg + 360deg / 8 * 6, 1.3), $g$, tint: blue, <g>),
        vertex((-90deg + 360deg / 8 * 7, 1.3), $h$, tint: blue, <h>),
        edge(<a>, <b>),
        edge(<b>, <c>),
        edge(<c>, <d>),
        edge(<d>, <e>),
        edge(<e>, <f>),
        edge(<f>, <g>),
        edge(<g>, <h>),
        edge(<h>, <a>),
        edge(<a>, <c>, bend: -30deg),
        edge(<b>, <d>, bend: -30deg),
        edge(<c>, <e>, bend: -30deg),
        edge(<d>, <f>, bend: -30deg),
        edge(<e>, <g>, bend: -30deg),
        edge(<f>, <h>, bend: -30deg),
      )
    ],
  )
]


Для каждого графа:
- Является ли граф эйлеровым? Гамильтоновым? Двудольным? Ответ обоснуйте.
- Найти: максимальную клику  $Q subset.eq V$, максимальное независимое множество $S subset.eq V$, минимальное доминирующее множество $D subset.eq V$.
- Найти: максимальное паросочетание $M subset.eq E$. Является ли  $M$ совершенным?
- Найти: минимальное вершинное покрытие  $R subset.eq V$, минимальное рёберное покрытие $F subset.eq E$.
- Найти: минимальную вершинную раскраску $C : V to {1, 2, dots, chi(G)}$
- Найти: минимальную рёберную раскраску $C : E to {1, 2, dots, chi'(G)}$


#v(0.5cm)

== 2. Работа над ошибками

Приведенное ниже «доказательство» содержит ошибку. Определите ошибку и объясните, почему заключение неверно, а утверждение не является справедливым.

*Утверждение*:  Каждое дерево с $n$ вершинами имеет путь длины $n - 1$.

*База индукции*: Дерево с одной вершиной, очевидно, имеет путь длины: $0 = 1 - 1$

*Шаг индукции*: Предположим, что каждое дерево с $n$ вершинами имеет путь длины $n - 1$, который заканчивается в некотором листе $u$. Добавим новую вершину $v$ и соединим ее с $u$ ребром. Полученное дерево имеет $n + 1$ вершин и содержит путь длины $n$, что равно $(n+1)-1$.
    
#v(0.5cm)

== 3. Отработка

#block(sticky: true)[*a) Код Прüфера*]

Код Прюфера задает биекцию между помеченными деревьями на $n$ вершинах и последовательностями длины $n - 2$ с элементами из ${1, 2, dots, n}$.

#align(center)[
  #diagram(
    spacing: (2em, 1.5em),
    node-stroke: 1pt,
    edge-stroke: 1pt,
    vertex((1.3, 2), $1$, tint: blue, <1>),
    vertex((2, 2), $2$, tint: blue, <2>),
    vertex((2.7, 2), $3$, tint: blue, <3>),
    vertex((1, 1), $4$, tint: blue, <4>),
    vertex((2, 1), $5$, tint: blue, <5>),
    vertex((3, 1), $6$, tint: blue, <6>),
    vertex((4, 1), $7$, tint: blue, <7>),
    vertex((0.5, 0), $8$, tint: blue, <8>),
    vertex((1.5, 0), $9$, tint: blue, <9>),
    vertex((2.5, 0), $10$, tint: blue, <10>),
    vertex((3.5, 0), $11$, tint: blue, <11>),
    vertex((4.5, 0), $12$, tint: blue, <12>),
    edge(<5>, <1>),
    edge(<5>, <2>),
    edge(<5>, <3>),
    edge(<5>, <4>),
    edge(<5>, <6>),
    edge(<5>, <7>),
    edge(<4>, <8>),
    edge(<4>, <9>),
    edge(<6>, <10>),
    edge(<7>, <11>),
    edge(<7>, <12>),
  )
]

- Закодируйте приведенное выше дерево с помощью кода Прюфера.
- Декодируйте код Прюфера $(3, 3, 3, 7, 7, 5)$ обратно в дерево. Изобразите результат.
- Докажите, что в коде Прюфера число $i$ встречается ровно $deg(i) - 1$ раз.

#block(sticky: true)[*b) Бинарное кодирование*]

Декодируйте бинарный код (11011010010011010010) в дерево. 

#block(sticky: true)[*c) Гомеоморфность*]

Предложить простой граф гомеоморфный заданному.
Сравнить наборы степеней графов, суммы степеней.

#align(center, image("gomeo.png", width: 20%))

#block(sticky: true)[*d) Характеристики*]

Найти радиус, диаметр, центр графов из пунктов a), b) и c).

#v(0.5cm)

== 4. Закрепляем результат

#block(sticky: true)[*a) Эйлеровость*]

- Для каких значений $n >= 3$ полный граф $K_n$ имеет эйлеров цикл? Эйлерову цепь (но не цикл)? Ответ обоснуйте.
- Для каких пар $(m, n)$ с $m, n >= 1$ полный двудольный граф $K_(m,n)$ имеет эйлеров цикл? Эйлерову цепь?

#block(sticky: true)[*b) Гамильтоновость*]

- Докажите, что $K_(m,n)$ является гамильтоновым тогда и только тогда, когда $m = n >= 2$.
- Привести пример негамильтонова графа с $n = 10$ вершинами, у которого $deg(u) + deg(v) >= n—1$ для любой пары несмежных вершин $u$ и $v$.


#block(sticky: true)[*c) Двудольность*]

Доказать:
- Если $G$ - двудольный и $d$-регулярный с $d >= 1$, то $G$ имеет совершенное паросочетание.
- В любом двудольном графе размер наибольшего паросочетания равен размеру наименьшего вершинного покрытия #footnote[
    Теорема Кőнига
  ].

== 5. Гомоморфизм 

_Гомоморфизм графа $f: V(G) to V(H)$, сохраняющее смежность: если $(u, v) in E(G)$, то $f(u)f(v) in E(H)$. В отличие от изоморфизма, отображение не обязано быть биективным, а несмежные вершины могут переходить как в несмежные, так и в смежные (главное — не нарушить условие для рёбер)._

#block(sticky: true)[*a) Разминка*]

Для каждой пары графов либо предъявите явный гомоморфизм $G to H$, либо докажите, что его не существует.

- $G = C_4$, $H = K_3$
- $G = K_3$, $H = K_(3,3)$

#block(sticky: true)[*b) Синтез*]

Докажите, что если существует гомоморфизм $G to H$, то $chi(G) <= chi(H)$.

Докажите, что композиция $g∘f:G to F$ также является гомоморфизмом.

== 6. Теорема Холла

В танцевальной школе 6 лидеров и 6 ведомых. Каждый лидер готов танцевать с определенными ведомыми, как показано в таблице ниже ($times$ обозначает готовность).

#align(center)[
  #table(
    columns: 7,
    stroke: (x, y) => if y == 0 { (bottom: 0.8pt) } + if x == 0 { (right: 0.8pt) },
    table.header([], [*$F_1$*], [*$F_2$*], [*$F_3$*], [*$F_4$*], [*$F_5$*], [*$F_6$*]),
    [*$L_1$*], [$times$], [$times$], [], [], [], [$times$],
    [*$L_2$*], [$times$], [], [$times$], [], [], [],
    [*$L_3$*], [], [$times$], [], [$times$], [], [],
    [*$L_4$*], [], [], [$times$], [], [$times$], [],
    [*$L_5$*], [], [], [], [$times$], [$times$], [],
    [*$L_6$*], [$times$], [], [], [], [], [$times$],
  )
]

- Определите, существует ли совершенное паросочетание, проверив условие Холла.
- Найдите наибольшее паросочетание. Является ли оно совершенным?
- Теперь предположим, что $L_2$ стал более разборчивым и будет танцевать только с $F_1$. Существует ли еще совершенное паросочетание? Если условие Холла нарушено, укажите нарушающее подмножество $S$ и объясните, почему совершенное паросочетание не существует.

== 7. Грациозная разметка

_Грациозной(изящной) разметкой графа $G$ с $m$ ребрами называется инъективная функция $f: V(G) to {0, 1, 2, ..., m}$, такая что индуцированные метки ребер $|f(u) - f(v)|$ для каждого ребра $(u, v) in E(G)$ различны и покрывают множество ${1, 2, ..., m}$. Иными словами, абсолютные разности меток смежных вершин все различны и покрывают целые числа от 1 до $m$. Граф называется грациозным, если он обладает грациозной разметкой._

Покажите, что следующие графы являются грациозными (явно построив для каждого грациозную разметку).

#tasklist("prob13", cols: 3)[
  #let vertex(pos, name, tint, ..args) = blob(
    pos,
    [],
    tint: tint,
    shape: shapes.circle,
    radius: 5pt,
    name: name,
    ..args,
  )

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((2, 0), <v3>, blue),
      vertex((3, 0), <v4>, blue),
      vertex((4, 0), <v5>, blue),
      edge(<v1>, <v2>),
      edge(<v2>, <v3>),
      edge(<v3>, <v4>),
      edge(<v4>, <v5>),
    )

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((2, 0), <v3>, blue),
      vertex((3, 0), <v4>, blue),
      vertex((4, 0), <v5>, blue),
      vertex((2, -1), <v6>, blue),
      vertex((2, -2), <v7>, blue),
      edge(<v1>, <v2>),
      edge(<v2>, <v3>),
      edge(<v3>, <v4>),
      edge(<v4>, <v5>),
      edge(<v3>, <v6>),
      edge(<v6>, <v7>),
    )

  #colbreak()

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((2, 0), <v3>, blue),
      vertex((3, 0), <v4>, blue),
      vertex((1, -1), <v5>, blue),
      edge(<v1>, <v2>),
      edge(<v2>, <v3>),
      edge(<v3>, <v4>),
      edge(<v2>, <v5>),
    )

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((2, 0), <v3>, blue),
      vertex((3, 0), <v4>, blue),
      vertex((1, -1), <v5>, blue),
      vertex((2, -1), <v6>, blue),
      edge(<v1>, <v2>),
      edge(<v2>, <v3>),
      edge(<v3>, <v4>),
      edge(<v2>, <v5>),
      edge(<v3>, <v6>),
    )

  #colbreak()

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((2, 0), <v3>, blue),
      vertex((0, 1), <v4>, blue),
      vertex((1, 1), <v5>, blue),
      vertex((2, 1), <v6>, blue),
      edge(<v1>, <v4>),
      edge(<v1>, <v5>),
      edge(<v1>, <v6>),
      edge(<v2>, <v4>),
      edge(<v2>, <v5>),
      edge(<v2>, <v6>),
      edge(<v3>, <v4>),
      edge(<v3>, <v5>),
      edge(<v3>, <v6>),
    )

  + #diagram(
      spacing: 1.5em,
      node-stroke: 1pt,
      edge-stroke: 1pt,
      vertex((0, 0), <v1>, blue),
      vertex((1, 0), <v2>, blue),
      vertex((0, 1), <v3>, blue),
      vertex((1, 1), <v4>, blue),
      edge(<v1>, <v2>),
      edge(<v1>, <v3>),
      edge(<v1>, <v4>),
      edge(<v2>, <v3>),
      edge(<v2>, <v4>),
      edge(<v3>, <v4>),
    )
]

== 8. Теория Рамсея
_(необязательное, +1 доп. балл)_

Теория Рамсея — раздел математики, изучающий условия, при которых в произвольно формируемых математических объектах обязан появиться некоторый порядок.

Число Рамсея $R(r, s)$  — это минимальное $n$ , такое что при любой 2-раскраске ребер $K_n$ найдется либо красный $K_r$, либо синий $K_s$.

#align(center, image("ramsey-theory.png", width: 20%))

Докажите, что $R(3, 3) = 6$, показав:

- Любую раскраску ребер $K_5$ двумя цветами можно выполнить так, чтобы избежать одноцветных треугольников.

- Любая раскраска ребер $K_6$ двумя цветами обязательно содержит одноцветный треугольник.

Докажите рекуррентное соотношение Рамсея: для всех $r, s >= 2$: $ R(r, s) <= R(r-1, s) + R(r, s-1) $

