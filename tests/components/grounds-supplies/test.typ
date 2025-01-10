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

  let xDistance = 2
  let yDistance = 2.5

  anchor("temp", (0, yDistance))
  for gs in (
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
  ) {
    anchor("temp", (rel:(0,-yDistance), to: "temp"))
    content((), [#gs])
    gs((rel: (xDistance, 0), to: "temp"), name: "a")

    gs((rel: (xDistance, 0), to: "a"), name: "a")
    show-anchor("a.center", offset: "west", pos: (0deg, 0.1))
    show-anchor("a.default", offset: "north-east", pos: (235deg, 0.1))
    show-anchor("a.left", offset: "east", pos: (150deg, 0.2))
    show-anchor("a.right", offset: "west", pos: (30deg, 0.2))

    gs((rel: (xDistance, 0), to: "a"), name: "a")
    show-anchor("a.north", offset: "south", pos: (90deg, 0.2))
    show-anchor("a.south", offset: "north", pos: (270deg, 0.2))
    show-anchor("a.east", offset: "west", pos: (0deg, 0.2))
    show-anchor("a.west", offset: "east", pos: (180deg, 0.2))
    show-anchor("a.north-west", offset: "south-east", pos: (90deg, 0.3))
    show-anchor("a.north-east", offset: "south-west", pos: (90deg, 0.3))
    show-anchor("a.south-west", offset: "north-east", pos: (-90deg, 0.3))
    show-anchor("a.south-east", offset: "north-west", pos: (-90deg, 0.3))
  }
})
