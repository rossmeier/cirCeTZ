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
    rmeter,
    rmeter.with(t: "A"),
    rmeter.with(t: "V"),
    rmeter.with(t: math.Omega),
    rmeterwa,
    rmeterwa.with(t: "A"),
    rmeterwa.with(t: "V"),
    rmeterwa.with(t: math.Omega),
    smeter,
    smeter.with(t: "v"),
    qiprobe,
    qvprobe,
    qpprobe,
    oscope,
    oscope.with(waveform: "sin"),
    oscope.with(waveform: "square"),
    oscope.with(waveform: "triangle"),
    oscope.with(waveform: "lissajous"),
    oscope.with(waveform: "zero"),
    oscope.with(waveform: none),
    oscope.with(waveform: {line((-0.75cm, -0.5cm), (0.75cm, 0.5cm), stroke: red)}),
    iloop,
    iloop2,
    currtap,
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
                                    if name in ("i", ) {
                                      show-anchor("a." + name, offset: "south", pos: (90deg, 0.1))
                                    } else if name == "i+" {
                                      show-anchor("a." + name, offset: "south-east", pos: (135deg, 0.1))
                                    } else if name == "i-" {
                                      show-anchor("a." + name, offset: "south-west", pos: (45deg, 0.1))
                                    } else {
                                      show-anchor("a." + name, offset: "north", pos: (270deg, 0.3))
                                    }                                    
                                  })
  }
})
