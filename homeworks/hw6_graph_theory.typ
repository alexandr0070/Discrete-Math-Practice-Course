#import "common.typ": *
#show: template

#set page(
  paper: "a4",
  margin: (top: 3cm, rest: 2cm),
  header: [
    #set text(10pt)
    #smallcaps[*Домашняя работа \#6*]
    #h(1fr)
    #smallcaps[*Дискретная математика*]
    \
    *Теория графов*
    #h(1fr)
    *$#emoji.snowflake$ Весна 2026*
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
  "The origins of graph theory are humble, even frivolous." — _Норман Линстед Биггс_
])

== 1. Анализ инвариантов

#grid(
  columns: 2,
  column-gutter: 8em,
  [
    *(a)* #align(center)[
      #diagram(
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((0, 0), $a$, <a>, tint: blue),
        vertex((2, 0), $b$, <b>, tint: black),
        vertex((1, 1), $c$, <c>, tint: green),
        vertex((0, 2), $d$, <d>, tint: red),
        vertex((2, 2), $e$, <e>, tint: yellow),
        edge(<a>, <c>),
        edge(<a>, <d>),
        edge(<c>, <b>),
        edge(<c>, <d>),
        edge(<c>, <e>),
        edge(<b>, <e>),
      )
    ]
  ],
  [
    *(b)* #align(center)[
      #diagram(
        node-stroke: 1pt,
        edge-stroke: 1pt,
        spacing: (13mm, 13mm),
        vertex((1, 1.5), $1$, <a>, tint: blue),
        vertex((0, 1), $2$, <b>, tint: blue),
        vertex((2, 1), $3$, <c>, tint: blue),
        vertex((0, 0), $4$, <d>, tint: blue),
        vertex((1, 0), $5$, <e>, tint: blue),
        vertex((2, 0), $6$, <f>, tint: blue),
        vertex((3, 1), $7$, <g>, tint: blue),
        vertex((3, 0), $8$, <h>, tint: blue),
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
    ]
  ],
)

#block(sticky: true)[*a) Способы задания*]

- Задайте данные графы всеми известными способами 

#block(sticky: true)[*b) Основные характеристики связности*]

Для каждого из них вычислите указанные характеристики и свойства:

- Минимальная степень вершины $delta(G)$, максимальная степень вершины $Delta(G)$

- Вершинная связность $kappa(G)$, рёберная связность $lambda(G)$

- Все $(kappa - 1)$-connected компоненты, $(lambda + 1)$-edge-connected компоненты

- Проверка неравенства Уитни: $kappa(G) <= lambda(G) <= delta(G)$

#block(sticky: true)[*c) Простой граф*]

- Докажите, что в каждом простом графе $(n-1)$ найдутся вершины $u!=v: deg(u) = deg(v)$

- При каких $n$ существуют простые графы с $n$ вершинами каждая из которых имеет степень 3

- Какое наименьшее и наибольшее число ребер может быть в графе с $n$ вершинами и $k$ компонентами связности?

#v(0.5cm)

== 2. Степени, последовательности

Последовательность $d = (d_1, d_2, dots, d_n)$, где $d_1 >= d_2 >= dots >= d_n >= 0$ называется #text(fill: blue, [_графической_]), если существует простой граф с этой последовательностью степеней.

Для каждой последовательности определите, является ли она графической.
- Если да - постройте реализующий граф (используя алгоритм Хавела-Хакими).
- Если нет - объясните почему (используя критерий Эрдёша-Галлаи).
    #[
      #set enum(numbering: "(a)")
      + $(5, 4, 3, 2, 2, 2)$
      + $(3, 3, 3, 3, 3, 3)$
      + $(4, 3, 2, 1, 0)$
      + $(6, 3, 3, 3, 3, 2, 2)$
      + $(1, 1, 1, 1, 1, 1)$
    ]

    
#v(0.5cm)

== 3. Изоморфизм графов

#block(sticky: true)[*a) Математическая основа*]

- Для каждой изоморфной пары графов укажите явную биекцию: $f: V(G) to V(H)$ сохраняющую смежность.
- Для неизоморфных укажите различающий инвариант (например: последовательность степеней, обхват и тд).

#grid(
  columns: 2,
  align: left,
  column-gutter: 8em,
  row-gutter: 2em,
  [
    *Graph $H_1$:* #align(center)[
      #diagram(
        spacing: 2em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((-90deg + 360deg / 7 * 0, 1.3), $1$, tint: blue, <1>),
        vertex((-90deg + 360deg / 7 * 1, 1.3), $2$, tint: blue, <2>),
        vertex((-90deg + 360deg / 7 * 2, 1.3), $3$, tint: blue, <3>),
        vertex((-90deg + 360deg / 7 * 3, 1.3), $4$, tint: blue, <4>),
        vertex((-90deg + 360deg / 7 * 4, 1.3), $5$, tint: blue, <5>),
        vertex((-90deg + 360deg / 7 * 5, 1.3), $6$, tint: blue, <6>),
        vertex((-90deg + 360deg / 7 * 6, 1.3), $7$, tint: blue, <7>),
        edge(<1>, <2>),
        edge(<2>, <3>),
        edge(<3>, <4>),
        edge(<4>, <5>),
        edge(<5>, <6>),
        edge(<6>, <7>),
        edge(<7>, <1>),
        edge(<1>, <3>, bend: -30deg),
        edge(<2>, <5>),
      )
    ]

    *Graph $H_3$:* #align(center)[
      #diagram(
        spacing: 3em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((0, 0), $a$, tint: green, <a>),
        vertex((1, 0), $b$, tint: green, <b>),
        vertex((2, 0), $c$, tint: green, <c>),
        vertex((3, 0), $d$, tint: green, <d>),
        vertex((0.5, 1), $e$, tint: green, <e>),
        vertex((1.5, 1), $f$, tint: green, <f>),
        vertex((2.5, 1), $g$, tint: green, <g>),
        edge(<a>, <b>),
        edge(<b>, <c>),
        edge(<c>, <d>),
        edge(<a>, <e>),
        edge(<b>, <e>),
        edge(<b>, <f>),
        edge(<c>, <f>),
        edge(<c>, <g>),
        edge(<d>, <g>),
      )
    ]
  ],
  [
    *Graph $H_2$:* #align(center)[
      #diagram(
        spacing: 2em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((1, 1), $p$, tint: orange, <p>),
        vertex((0, 0.5), $q$, tint: orange, <q>),
        vertex((0.5, -0.3), $r$, tint: orange, <r>),
        vertex((1.5, -0.3), $s$, tint: orange, <s>),
        vertex((2, 0.5), $t$, tint: orange, <t>),
        vertex((2, 1.5), $u$, tint: orange, <u>),
        vertex((0, 1.5), $v$, tint: orange, <v>),
        edge(<p>, <q>),
        edge(<p>, <v>),
        edge(<p>, <t>),
        edge(<p>, <u>),
        edge(<q>, <r>),
        edge(<r>, <s>),
        edge(<s>, <t>),
        edge(<t>, <u>),
        edge(<q>, <v>),
      )
    ]

    *Graph $H_4$:* #align(center)[
      #diagram(
        spacing: 2em,
        node-stroke: 1pt,
        edge-stroke: 1pt,
        vertex((0, 1), $w$, tint: purple, <w>),
        vertex((1, 0), $x$, tint: purple, <x>),
        vertex((1, 2), $y$, tint: purple, <y>),
        vertex((2, 0.5), $z$, tint: purple, <z>),
        vertex((2, 1.5), $alpha$, tint: purple, <alpha>),
        vertex((3, 1), $beta$, tint: purple, <beta>),
        vertex((1.5, 1), $gamma$, tint: purple, <gamma>),
        edge(<w>, <x>, bend: 30deg),
        edge(<w>, <y>, bend: -30deg),
        edge(<w>, <gamma>),
        edge(<x>, <z>),
        edge(<y>, <alpha>),
        edge(<z>, <beta>),
        edge(<alpha>, <beta>),
        edge(<z>, <gamma>),
        edge(<alpha>, <gamma>),
      )
    ]
  ],
)

#block(sticky: true)[*b) Классы эквивалентности*]

Разбить данное множество графов на классы эквивалентности по отношению изоморфности графов:

#align(center,
  [
    #image("task3.png", width: 70%)
  ]
)

Предложить инварианты (или системы инвариантов), разделяющие данные классы.

#v(0.5cm)

== 4. Транзакционность

Чтобы понять, не «сломают» ли друг другу программу одновременно работающие куски кода, нужно посмотреть, в каком порядке они обращаются к переменным. Мы должны построить схему (хронологию) того, кто и когда читал или менял данные. Чтобы код работал предсказуемо и корректно, нам нужно жестко договориться, кто и когда имеет право читать или писать данные. Нужно запретить хаос и установить четкую очередь (строгую последовательность) на операции чтения и записи. Чтобы проверить, нет ли в нашем расписании логической ошибки исполььзуется граф предшествования #footnote[
    На самом деле все что мы описали используется в моделях конфликтов транзакций с которыми вы познакомитесь на 2 курсе
  ]

#text(fill: blue, [_Граф предшествования_]) - это ориентированный граф, где:
- вершины представляют инструкции программы
- рёбра представляют зависимости между инструкциями

Постройте граф предшествования для программы:

```
S1: x := 0
S2: x := x + 1
S3: y := 2
S4: z := y
S5: x := x + 2
S6: y := x + z
S7: z := 4
```
