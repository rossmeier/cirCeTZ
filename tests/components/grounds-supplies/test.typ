#import "/src/lib.typ": cetz, components, show-anchor
#import cetz: *

#set page(width: auto, height: auto, margin: 1cm)

= Grounds & Supplies

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

  let xDistance = 2.5
  let yDistance = 2.5

  let symbols = (
    ground,
    tlground,
    rground,
    sground,
    tground,
    nground,
    pground,
    cground,
    eground,
    eground2,
    vcc,
    vee,
  )

  let tests = (name: "") => {(
    ("a", "Symbol", ()),
    ("b", "D/C-Anchors", ()),
    ("c", "Compas Anchors", ()),
    ("d", "Scale", (scale: 0.5)),
    ("e", "Fill", (fill: blue.lighten(50%))),
    ("f", "Thickness", (thickness: 4)),
    ("g", "Stroke", (stroke: (paint: blue.lighten(50%)))),
    ("h", "Label", (l: name)),
  )}

  // Col-Labels
  move-to((0,1))
  for test in tests() {
    content((rel: (xDistance, 0)), angle: 45deg, anchor: "mid-west", [#test.at(1)])
  }

  anchor("temp", (0, yDistance))
  for DUT in symbols {
    // Row-Label
    anchor("temp", (rel:(0,-yDistance), to: "temp"))
    content((), [#DUT])

    // Draw the symbols with given arguments
    let tests = tests(name: [#DUT])
    for i in range(tests.len()) {
      let name = tests.at(i).first()
      let args = tests.at(i).last()
      DUT((rel: (xDistance, 0), to: if name == "a" { "temp" } else {tests.at(i - 1).first()}), name: name, ..args)
    }

    show-anchor("b.center", offset: "east", pos: (180deg, 0.2))
    show-anchor("b.default", offset: "west", pos: (00deg, 0.2))

    show-anchor("c.north", offset: "south", pos: (90deg, 0.2))
    show-anchor("c.south", offset: "north", pos: (270deg, 0.2))
    show-anchor("c.east", offset: "west", pos: (40deg, 0.2))
    show-anchor("c.west", offset: "east", pos: (140deg, 0.2))
    show-anchor("c.north-west", offset: "south-east", pos: (90deg, 0.3))
    show-anchor("c.north-east", offset: "south-west", pos: (90deg, 0.3))
    show-anchor("c.south-west", offset: "north-east", pos: (-90deg, 0.3))
    show-anchor("c.south-east", offset: "north-west", pos: (-90deg, 0.3))
  }

  // Divider
  for i in range(tests().len()) {
    line((xDistance*(i+0.5), 0), ((xDistance*(i+0.5), 0), "|-", "a.south"), stroke: (paint: gray))
  }
})