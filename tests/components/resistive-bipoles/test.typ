#import "/src/lib.typ": cetz, components, show-anchor
#import cetz: *

#set page(width: auto, height: auto, margin: 1cm)

= Resistive Bipoles

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
  let xDistance = 2.5
  let yDistance = 3.0

  let symbols = (
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
    varistor,
    mov,
    photoresistor,
    thermistor,
    thermistorptc,
    thermistorntc,
  )

  let styles =  (
    "american",
    "european",
  )

  let tests = (name: "") => {(
    ("a", "Symbol", ()),
    ("b", "D/C-Anchors", ()),
    ("c", "Compas Anchors", ()),
    ("d", "A/B-Anchors", ()),
    ("e", "Additionnal Anchors", ()),
    ("f", "Scale", (scale: 0.5)),
    ("g", "Fill", (fill: blue.lighten(50%))),
    ("h", "Thickness", (thickness: 4)),
    ("i", "Stroke", (stroke: (paint: blue.lighten(50%)))),
    ("j", "Label", (l: name)),
  )}

  // Col-Labels
  move-to((0,1))
  for test in tests() {
    content((rel: (xDistance + line-length/2, 0)), angle: 45deg, anchor: "mid-west", [#test.at(1)])
  }

  anchor("temp", (0, yDistance))
  for DUT in symbols {
    for style in styles {
      set-style(circetz: (style: (resistor: style)))
      // Row-Label
      anchor("temp", (rel:(0,-yDistance), to: "temp"))
      content((), [#DUT #style])

      // Draw the symbols with given arguments
      let tests = tests(name: [#DUT])
      for i in range(tests.len()) {
        let name = tests.at(i).first()
        let args = tests.at(i).last()
        DUT((rel: (xDistance, 0), to: if name == "a" { "temp" } else {tests.at(i - 1).first()}), (rel: (line-length, 0)), name: name, ..args)
      }

      show-anchor("b.center", offset: "south", pos: (90deg, 0.3))
      show-anchor("b.default", offset: "north", pos: (270deg, 0.3))

      show-anchor("c.north", offset: "south", pos: (90deg, 0.2))
      show-anchor("c.south", offset: "north", pos: (270deg, 0.2))
      show-anchor("c.east", offset: "west", pos: (40deg, 0.2))
      show-anchor("c.west", offset: "east", pos: (140deg, 0.2))
      show-anchor("c.north-west", offset: "south-east", pos: (90deg, 0.3))
      show-anchor("c.north-east", offset: "south-west", pos: (90deg, 0.3))
      show-anchor("c.south-west", offset: "north-east", pos: (-90deg, 0.3))
      show-anchor("c.south-east", offset: "north-west", pos: (-90deg, 0.3))

      show-anchor("d.a", offset: "north", pos: (270deg, 0.1))
      show-anchor("d.b", offset: "south", pos: (90deg, 0.1))

      for-each-anchor("e", exclude: ("center",
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
                                "start", "end", "mid", "component", "rect",
                                "text",
                                ), (name) => {
                                if not name in ("wiper", "label") {
                                    show-anchor("e." + name, offset: "west", pos: (30deg, 0.2))
                                } else  if name == "wiper" {
                                  show-anchor("e." + name, offset: "east", pos: (180deg, 0.2))
                                } else if name == "label" {
                                  show-anchor("e." + name, offset: "west", pos: (0deg, 0.2))
                                }
                              })
    }
  }
})