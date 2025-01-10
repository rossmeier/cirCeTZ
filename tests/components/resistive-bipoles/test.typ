#set page(width: auto, height: auto, margin: 1cm)
#import "/src/lib.typ": cetz, components, show-anchor
#import cetz: *

#canvas({
  import components: *
  import draw: *

  set-style(
    stroke: (thickness: 0.4pt),
    content: (padding: (0.1em)),
    circetz: (
      stroke: (thickness: 0.4pt),
    ),
  )

  let line-length = 2
  let xDistance = 2
  let yDistance = 2.5

  anchor("temp", (0, yDistance))
  for r in (
    generic,
    xgeneric,
    sgeneric,
    tgeneric,
    ageneric,
    memristor,
    resistor,
    vresistor,
    vresistor.with(reverse-dir: true),
    potentiometer,
    potentiometer.with(wiper-pos: 0.8),
    resistivesens,
    ldresistor,
    resistor.with(style: (resistor: "european")),
    vresistor.with(style: (resistor: "european")),
    vresistor.with(reverse-dir: true, style: (resistor: "european")),
    potentiometer.with(style: (resistor: "european")),
    potentiometer.with(wiper-pos: 0.8, style: (resistor: "european")),
    resistivesens.with(style: (resistor: "european")),
    ldresistor.with(style: (resistor: "european")),
    varistor,
    mov,
    photoresistor,
    thermistor,
    thermistorptc,
    thermistorntc,
  ) {
    anchor("temp", (rel:(0,-yDistance), to: "temp"))
    content((), [#r])
    r((rel: (xDistance, 0)), (rel: (line-length,0)), name: "a")

    r((rel: (xDistance, 0), to: "a"), (rel: (line-length,0)), name: "a")
    show-anchor("a.center", offset: "south", pos: (90deg, 0.6))
    show-anchor("a.default", offset: "north", pos: (270deg, 0.6))

    r((rel: (xDistance, 0), to: "a"), (rel: (line-length, 0)), name: "a")
    show-anchor("a.north", offset: "south", pos: (90deg, 0.2))
    show-anchor("a.south", offset: "north", pos: (270deg, 0.2))
    show-anchor("a.east", offset: "west", pos: (40deg, 0.2))
    show-anchor("a.west", offset: "east", pos: (140deg, 0.2))
    show-anchor("a.north-west", offset: "south-east", pos: (90deg, 0.3))
    show-anchor("a.north-east", offset: "south-west", pos: (90deg, 0.3))
    show-anchor("a.south-west", offset: "north-east", pos: (-90deg, 0.3))
    show-anchor("a.south-east", offset: "north-west", pos: (-90deg, 0.3))

    r((rel: (xDistance, 0), to: "a"), (rel: (line-length,0)), name: "a")
    show-anchor("a.a", offset: "north", pos: (270deg, 0.1))
    show-anchor("a.b", offset: "south", pos: (90deg, 0.1))

    r((rel: (xDistance, 0), to: "a"), (rel: (line-length,0)), name: "a")
    for-each-anchor("a", exclude: ("center",
                                   "default",
                                   "north",
                                   "south",
                                   "west",
                                   "east",
                                   "north-west",
                                   "north-east",
                                   "south-west",
                                   "south-east",
                                   "a",
                                   "b",
                                   "start", "end", "mid", "component", "rect"
                                   ), (name) => {
                                    if not name in ("wiper", "label") {
                                        show-anchor("a." + name, offset: "west", pos: (30deg, 0.2))
                                    } else  if name == "wiper" {
                                      show-anchor("a." + name, offset: "east", pos: (180deg, 0.2))
                                    } else if name == "label" {
                                      show-anchor("a." + name, offset: "west", pos: (0deg, 0.2))
                                    }
                                  })
  }
})
