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
    battery,
    battery1,
    battery2,
    solar,
    vsource,
    vsource.with(style: (voltage: "cute")),
    vsource.with(style: (voltage: "american")),
    isource,
    isource.with(style: (current: "cute")),
    isource.with(style: (current: "american")),
    vsourcesin,
    isourcesin,
    isourcesin.with(isourcesin-angle: 80deg),
    cvsource,
    cvsource.with(style: (voltage: "cute")),
    cvsource.with(style: (voltage: "american")),
    cisource,
    cisource.with(style: (current: "cute")),
    cisource.with(style: (current: "american")),
    ecsource,
    cvsourcesin,
    cisourcesin,
    vsourceN,
    isourceN,
    vsourceN.with(noise-dashed: true),
    isourceN.with(noise-dashed: true),
    vsourcesquare,
    vsourcetri,
    esource,
    pvsource,
    pvmodule,
    voosource,
    ioosource,
    oosourcetrans,
    oosourcetrans.with(prim: "delta", sec: "wye"),
    oosourcetrans.with(prim: "eyw", sec: "zig"),
    ooosource,
    ooosource.with(prim: "delta", sec: "wye", tert: "zig"),
    nullator,
    norator,
    dcvsource,
    dcisource,
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
                                    if name == "centerprim" {
                                      show-anchor("a." + name, offset: "south-east", pos: (90deg, 0.3))                                      
                                    } else if name == "centersec" {
                                      show-anchor("a." + name, offset: "south-west", pos: (90deg, 0.3))
                                    } else if name == "centertert" {
                                      show-anchor("a." + name, offset: "north-west", pos: (270deg, 0.3))
                                    } else if name == "symbolprim" {
                                      show-anchor("a." + name, offset: "south-east", pos: (160deg, 0.3))
                                    } else if name == "symbolsec" {
                                      show-anchor("a." + name, offset: "south-west", pos: (20deg, 0.3))
                                    } else if name == "symboltert" {
                                      show-anchor("a." + name, offset: "north-east", pos: (250deg, 0.3))
                                    } else {
                                      //show-anchor("a." + name, offset: "north", pos: (270deg, 0.3))
                                    }
                                  })
  }
})
