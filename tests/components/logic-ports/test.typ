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
      logic-ports: (
        scale: 0.7,
      ),
    )
  )

  let port-list(start) = {
    and-port(start)
    nand-port((rel: (0,-1)))
    or-port((rel: (0,-1)))
    or-port((rel: (0,-1)))
    xor-port((rel: (0,-1)))
    xnor-port((rel: (0,-1)))
    buffer-port((rel: (0,-1)))
    not-port((rel: (0,-1)))
  }

  // IEEE Style Logic Gates
  port-list((0,0))

  // European Style Logic Gates
  group({
    set-style(circetz: (logic-ports: (european-style: true)))
    port-list((2, 0))
  })

  // Special Logic Gates
  schmitt-port((4,0))
  invschmitt-port((rel: (0,-1)))
  tgate((rel: (0,-1)))
  double-tgate((rel: (0,-1)))

  // Blank Ports
  blank-port((rel: (0, -1)), l: $A*B$)
  blank-not-port((rel: (0, -1)), l: $A*B$)

  // Additional Symbols
  schmitt-symbol((rel: (0, -1)))
  notcirc((rel: (0, -1)))

  // Anchors
  let gate(gate-type, pos, name) = {
    gate-type(pos, name: name)
  }
  
  anchor("first_a", (3,0))
  for port in (
    and-port,
    nand-port,
    or-port,
    nor-port,
    xor-port,
    xnor-port,
    and-port.with(number-inputs: 4, inner-inputs: 2),
    xor-port.with(number-inputs: 4, inner-inputs: 2),
    and-port.with(european-style: true),
    nand-port.with(european-style: true),
    nand-port.with(european-style: true, european-ieee-not-style: true),
    and-port.with(european-style: true, number-inputs: 4, inner-inputs: 2),
  ) {
    gate(port, (rel:(4,0), to:"first_a"), "first_a")
    for a in (
      ("north", "south-west", (45deg, 0.1)),
      ("south", "north-west", (-45deg, 0.1)),
      ("west", "east", (180deg, 0.1)),
      ("east", "south-west", (45deg, 0.1)),
      ("north-west", "south-east", (135deg, 0.1)),
      ("north-east", "south-west", (45deg, 0.1)),
      ("south-west", "north-east", (225deg, 0.1)),
      ("south-east", "north-west", (-45deg, 0.1)),
      ("center", "north", (270deg, 0.1))
    ) {
      show-anchor("first_a." + a.first(), offset: a.at(1), pos: a.last())
    }

    gate(port, (rel:(0,-2), to:"first_a"), "a")
    for a in (
      ("up", "south-west", (45deg, 0.1)),
      ("down", "north-west", (-45deg, 0.1)),
      ("left", "east", (180deg, 0.1)),
      ("right", "south-west", (45deg, 0.1))
    ) {
      show-anchor("a." + a.first(), offset: a.at(1), pos: a.last())
    }

    gate(port, (rel:(0,-2), to:"a"), "a")
    for a in (
      ("in 1", "south-east", (180deg, 0.2)),
      ("bin 1", "north-east", (200deg, 0.2)),
      ("in 2", "south-east", (180deg, 0.2)),
      ("bin 2", "north-east", (200deg, 0.2)),
      ("out", "south-west", (45deg, 0.1)),
      ("bout", "north-west", (-45deg, 0.1)),
    ) {
      show-anchor("a." + a.first(), offset: a.at(1), pos: a.last())
    }

    gate(port, (rel:(0,-2), to:"a"), "a")
    for a in (
      ("body-right", "south-west", (45deg, 0.1)),
      ("body-left", "east", (180deg, 0.1)),
    ) {
      show-anchor("a." + a.first(), offset: a.at(1), pos: a.last())
    }
  }
})
