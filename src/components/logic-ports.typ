#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

// Dimensions for IEEE found in the following issue for circuitikz:
// https://github.com/circuitikz/circuitikz/issues/383

#let logic-port(
  name,
  func,
  style,
  ..inputs
) = component(
  ("logic-ports", name),
  style => {
    style.stdH = 0.5 * style.height * style.baselen
    style.pin-length *= style.baselen
    style.not-radius *= style.stdH
    style.xor-bar-distance *= style.baselen

    let body-stoke = style.stroke
    body-stoke.thickness *= style.thickness

    anchor("text", (0,0))

    // IEEE
    style.ieee-multipoles = (type, style) => {
      let num-inputs = calc.max(2, style.number-inputs)
      let H = (2 * style.stdH / 6.5)
      //anchor("left", (-4 * H, 0))
      anchor("body-right", (4 * H, 0))
      anchor("body-left", (-4 * H, 0))

      // In-Anchors
      let draw-reck = false
      let pin-distance = style.stdH * 2 / num-inputs
      let inner-inputs = style.inner-inputs
      if style.inner-inputs == 0 or num-inputs <= style.inner-inputs {
        pin-distance = style.stdH * 2 / num-inputs
      } else {
        if calc.even(num-inputs) != calc.even(style.inner-inputs) {
          inner-inputs -= 1
        }
        pin-distance = style.stdH * 2 / style.inner-inputs
        draw-reck = true
      }
      for i in range(1, num-inputs + 1) {
        anchor("in " + str(i), (-4*H - style.pin-length, ((num-inputs/2 * pin-distance)) - pin-distance * (i - 0.5)))
      }

      if type in ("and", "nand") {
        anchor("up", (0, style.stdH))
        anchor("down", (0, -style.stdH))
        anchor("left", (-4 * H, 0))
        // Body
        merge-path({
          line(("left", "|-", (0,style.stdH)), (0.75*H, style.stdH))
          arc((), start: 90deg, stop: -90deg, radius: 3.25 * H)
          line((), ("left", "|-", (0,-style.stdH)))
        }, close: true, stroke: body-stoke, fill: style.fill)

        // Reck
        if draw-reck {
          let outer = num-inputs - style.inner-inputs
          line(((-4*H), style.stdH), (rel: (0, (outer/2.0) * pin-distance)), stroke: body-stoke)
          line(((-4*H), -style.stdH), (rel: (0, -(outer/2.0) * pin-distance)), stroke: body-stoke)
        }

        // bin-Anchors
        for i in range(1, num-inputs + 1) {
          anchor("bin " + str(i), ("left", "|-", "in " + str(i)))
        }

      } else if type in ("or", "nor", "xor", "xnor") {
        // rounded tip
        //  yAnchor = 3.25H - (6.5H - cos( asin(1.5/6.5) ) * 6.5H)
        //          = 3.25H - (6.5H - 0.9730085 * 6.5H)
        //          = 3.25H - (6.5H - 6.32456H)
        //          = 3.25H - 0.175445H
        //          = 3.07456*H
        let yAnchor = 3.07456*H

        // pointed tip
        //  yAnchor = 3.25H - (6.5H - cos( asin(1.62916512/6.5) ) * 6.5H)
        //          = 3.25H - (6.5H - 0.9680802 * 6.5H)
        //          = 3.25H - (6.5H - 6.29252H)
        //          = 3.25H - 0.207479 x
        //          = 3.04252H
        //let yAnchor = 3.04252*H

        anchor("up", (0, yAnchor))
        anchor("down", (0, -yAnchor))

        // Body
        merge-path({
          // Two options

          // Rounded tip as in the drawings
          // Dimensions for the the tip are messured from Fusion360
          
          arc((-(4 + calc.cos(30deg)) * H, -style.stdH), start: -30deg, stop: 30deg, radius: 6.5*H)
          line((), (-1.5*H, style.stdH))
          arc((), start: 90deg, stop: 34.20545794deg, radius: 6.5*H)
          arc((), start: 34.20545794deg, stop: -34.20545794deg, radius: 0.71875*H)
          arc((), start: -34.20545794deg, stop: -90deg, radius: 6.5*H)
          

          // Pointed tip as in tikz
          /*arc((-(4 + calc.cos(30deg)) * H, -style.stdH), start: -30deg, stop: 30deg, radius: 6.5*H)
          line((), (-1.62916512*H, style.stdH)) // Should be -1.5*H, but to account for the pointed tip it is set to -1.62916512*H (messured in Fusion360)
          arc((), start: 90deg, stop: 30deg, radius: 6.5*H)
          arc((), start: -30deg, stop: -90deg, radius: 6.5*H)*/

        }, close: true, stroke: body-stoke, fill: style.fill)

        // Reck
        if draw-reck {
          let outer = num-inputs - style.inner-inputs
          let reck-offset = H*calc.cos(30deg) + style.xor-bar-distance
          line(((-4*H) - reck-offset, style.stdH), (rel: (0, (outer/2.0) * pin-distance)), stroke: body-stoke)
          line(((-4*H) - reck-offset, -style.stdH), (rel: (0, -(outer/2.0) * pin-distance)), stroke: body-stoke)
        }

        // bin-Anchors
        for i in range(1, num-inputs + 1) {
          let anchorY = (num-inputs/2 * pin-distance) - pin-distance * (i - 0.5)
          let angle = calc.asin(calc.min(calc.abs(anchorY/(6.5*H)), calc.sin(30deg)))
          let anchorX = 6.5*H*calc.cos(angle) - 6.5*H - 4*H - (if type in ("xor", "xnor") {style.xor-bar-distance} else {0})
          anchor("bin " + str(i), (anchorX, anchorY))
        }

        if type in ("xor", "xnor") {
          let arc-stroke = body-stoke
          if draw-reck {arc-stroke.cap = "round"} // round cap for the arc to hide the gap to the reck
          arc((-(4 + calc.cos(30deg)) * H - style.xor-bar-distance, -style.stdH), start: -30deg, stop: 30deg, radius: 6.5*H, stroke: arc-stroke, fill: none)
          anchor("left", (-4 * H - style.xor-bar-distance, 0))
          // ibin-Anchors
          for i in range(1, num-inputs + 1) {
            let anchorY = (num-inputs/2 * pin-distance) - pin-distance * (i - 0.5)
            let angle = calc.asin(calc.min(calc.abs(anchorY/(6.5*H)), calc.sin(30deg)))
            let anchorX = 6.5*H*calc.cos(angle) - 6.5*H - 4*H
            if calc.abs(anchorY) <= style.stdH {
              anchor("ibin " + str(i), (anchorX, anchorY))
              if style.xor-leads-in{
                line("ibin " + str(i), "bin " + str(i), stroke: style.stroke)
              }
            } else {
              anchor("ibin " + str(i), "bin " + str(i))
            }
          }
        } else {
          anchor("left", (-4 * H, 0))
        }
      }

      // Negation Circle
      if type in ("nand", "nor", "xnor") {
        circle("body-right", radius: style.not-radius, stroke: body-stoke, fill: style.fill, anchor: "west", name: "N-Not")
        anchor("right", "N-Not.east")
      } else {
        anchor("right", "body-right")
      }

      // Input Pins
      if not style.no-input-leads {
        for i in range(1, num-inputs + 1) {
          line(("bin " + str(i)),("in " + str(i)), stroke: style.stroke)
        }
      }

      // Output Pin
      anchor("bout", "right")
      anchor("out", (rel: (style.pin-length, 0), to: "body-right"))
      line("bout", "out", stroke: style.stroke)

      // Input negation
      let n = inputs.named().at("n", default: ())

      for k in n.dedup() {
        assert(int(k) <= num-inputs, message: "Input pin " + k + " is out of range to negate")
        let pos = "bin " + k
        circle(pos, radius: style.not-radius * 1/1.6, stroke: style.stroke, anchor: "east")
      }
    }

    style.ieee-dipoles = (type, style) => {

      let left = -calc.cos(30deg) * style.stdH
      let up = style.stdH

      anchor("left", (left, 0))
      anchor("body-right", (-left, 0))

      merge-path({
        line(("left", "|-", (0,style.stdH)), ("body-right"))
        line((), ("left", "|-", (0,-style.stdH)))
      }, close: true, stroke: body-stoke, fill: style.fill)

      // Input
      anchor("bin", "left")
      anchor("in", (rel: (-style.pin-length, 0)))
      line("bin", "in", stroke: style.stroke)

      // Negation Circle
      if type in ("not", "invschmitt") {
        circle("body-right", radius: style.not-radius, stroke: body-stoke, fill: style.fill, anchor: "west", name: "N-Not")
        anchor("right", "N-Not.east")
      } else {
        anchor("right", "body-right")
      }

      // Schmitt Symbol
      if type in ("schmitt", "invschmitt") {
        line(
          (0.75*left, -0.25*up),
          (0.50*left, -0.25*up),
          (0.50*left,  0.25*up),
          (0.00*left,  0.25*up),
          stroke: style.stroke,
          fill: none
        )
        line(
          (0.25*left,  0.25*up),
          (0.25*left, -0.25*up),
          (0.50*left, -0.25*up),
          stroke: style.stroke,
          fill: none
        )
      }

      // Output Pin
      anchor("bout", "right")
      anchor("out", (rel: (style.pin-length, 0), to: "body-right"))
      line("bout", "out", stroke: style.stroke)
    }

    style.ieee-transmissions = (type, style) => {

      let left = -2 * calc.cos(30deg) * style.stdH * style.tgate-scale
      let up = style.stdH * style.tgate-scale * (if type == "double" {2} else {1})

      anchor("left", (left, 0))
      anchor("right", (-left, 0))

      anchor("north", (0, up))
      anchor("south", (0, -up))

      // Input
      anchor("bin", "left")
      anchor("in", (rel: (-style.pin-length, 0)))
      anchor("west", "in")
      line("bin", "in", stroke: style.stroke)

      // Output
      anchor("bout", "right")
      anchor("out", (rel: (style.pin-length, 0), to: "right"))
      anchor("east", "out")
      line("bout", "out", stroke: style.stroke)

      if type == "single" {
        // Body
        merge-path({
          line((left, up), (0,0))
          line((), (left, -up))
        }, close: true, stroke: body-stoke, fill: style.fill,)
        merge-path({
          line((-left, up), (0,0))
          line((), (-left, -up))
        }, close: true, stroke: body-stoke, fill: style.fill,)

        circle((0,2 * style.stroke.thickness), anchor: "south", radius: style.not-radius * style.tgate-scale, stroke: body-stoke, fill: style.fill, name: "N-Not")

        anchor("down", (0,0))

      } else if type == "double" {
        // Body
        merge-path({
          line((left, up), (0, 0.5 * up))
          line((), (left, 0))
        }, close: true, stroke: body-stoke, fill: style.fill,)
        merge-path({
          line((-left, up), (0, 0.5 * up))
          line((), (-left, 0))
        }, close: true, stroke: body-stoke, fill: style.fill,)
        merge-path({
          line((left, -up), (0, -0.5 * up))
          line((), (left, 0))
        }, close: true, stroke: body-stoke, fill: style.fill,)
        merge-path({
          line((-left, -up), (0, -0.5 * up))
          line((), (-left, 0))
        }, close: true, stroke: body-stoke, fill: style.fill,)

        circle((rel:(0,2 * style.stroke.thickness), to: (0, 0.5 * up)), anchor: "south", radius: style.not-radius * style.tgate-scale, stroke: body-stoke, fill: style.fill, name: "N-Not")

        anchor("down", (0, -0.5 * up))
      }

      anchor("up", "N-Not.north")

      // Gates lines
      anchor("bnotgate", "up")
      anchor("notgate", (0, up))
      line("bnotgate", "notgate", stroke: style.stroke)

      anchor("bgate", "down")
      anchor("gate", (0, -up))
      line("bgate", "gate", stroke: style.stroke)

    }

    style.european-ports = (symbol, negated: false, style) => {

      //                   0.42H         0.56H        0.42H
      //                 +-------+------------------+-------+
      //                 |       |                  |       |
      //
      //          +-             +------------------+
      //          |       _______|                  |
      //    0.65H |              |       Body       |________
      //          |       _______|                  |
      //          |              |                  |
      //          +-             +------------------+
      //
      //                 |                                  |
      //                 +----------------------------------+
      //                                1.4H
      //

      let H = style.stdH * 2 / 0.65

      let num-inputs = style.number-inputs
      if symbol != "1" {
        num-inputs = calc.max(2, num-inputs)
      } else {
        num-inputs = 1
      }

      let pin-distance = style.stdH * 2 / num-inputs
      let body-expansion = 0

      // Expand the hight of the body if there are more input pins than inner-inputs
      if style.inner-inputs != 0 and num-inputs > style.inner-inputs {
        pin-distance = style.stdH * 2 / style.inner-inputs
        body-expansion = ((num-inputs - style.inner-inputs) / 2) * pin-distance
      }

      anchor("left", (-0.42*H, 0))
      anchor("body-right", (0.42*H, 0))
      anchor("body-left", (-0.42*H, 0))

      // In-Anchors
      let draw-reck = false
      let inner-inputs = style.inner-inputs
      if style.inner-inputs == 0 or num-inputs <= style.inner-inputs {
        pin-distance = style.stdH * 2 / num-inputs
      } else {
        if calc.even(num-inputs) != calc.even(style.inner-inputs) {
          inner-inputs -= 1
        }
        pin-distance = style.stdH * 2 / style.inner-inputs
        draw-reck = true
      }
      for i in range(1, num-inputs + 1) {
        anchor("in " + str(i), ((-0.7*H, 0), "|-", (0,((num-inputs/2 * pin-distance)) - pin-distance * (i - 0.5))))
        anchor("bin " + str(i), ("left", "|-", "in " + str(i)))
        line(("bin " + str(i)),("in " + str(i)), stroke: style.stroke)
      }

      // Anchors
      anchor("up", (0, 0.325*H + body-expansion))
      anchor("down", (0, -(0.325*H + body-expansion)))

      // In-Anchors
      let draw-reck = false
      let pin-distance = style.stdH * 2 / num-inputs
      let inner-inputs = style.inner-inputs
      if style.inner-inputs == 0 or num-inputs <= style.inner-inputs {
        pin-distance = style.stdH * 2 / num-inputs
      } else {
        if calc.even(num-inputs) != calc.even(style.inner-inputs) {
          inner-inputs -= 1
        }
        pin-distance = style.stdH * 2 / style.inner-inputs
        draw-reck = true
      }
      for i in range(1, num-inputs + 1) {
        anchor("in " + str(i), ((-0.7*H, 0), "|-", (0,((num-inputs/2 * pin-distance)) - pin-distance * (i - 0.5))))
        anchor("bin " + str(i), ("left", "|-", "in " + str(i)))
        line(("bin " + str(i)),("in " + str(i)), stroke: style.stroke)
      }

      // Body
      rect(("left", "|-", "up"), ("body-right", "|-", "down"), stroke: body-stoke, fill: style.fill,)

      if negated {
        if not style.european-ieee-not-style {
          //
          //             0.224H = 0.4 * Body-Width = 0.4 * 0.56H
          //             +---+
          //             |   |
          //
          //      -------+            --+
          //             |\             | 0.0975H = 0.15 * Body-Height = 0.15 * 0.65H
          //             | \            |
          //        Body |__\____     __|
          //             |
          //             |
          //             |
          //      -------+
          //
          line(("body-right", "|-", (0,0.0975 * H)), (rel: (0.224 * H, 0), to: "body-right"))
          anchor("right", "body-right")
        } else {
          circle("body-right", radius: style.not-radius, stroke: body-stoke, fill: style.fill, anchor: "west", name: "N-Not")
          anchor("right", "N-Not.east")
        }
      } else {
        anchor("right", "body-right")
      }

      // Output Pin
      anchor("bout", "right")
      anchor("out", (0.7*H, 0))
      line("bout", "out", stroke: style.stroke)

      content((0,0), [#symbol], style: style)
    }

    func(style)
  },
  (
    (
      baselen: 0.4,
      height: 2,
      pin-length: 0.7,
      not-radius: 0.154,
      xor-bar-distance: 0.192,
      xor-leads-in: true,
      schmitt-symbol-size: 0.3,
      inner-inputs: 0,
      number-inputs: 0,
      no-input-leads: false,
      tgate-scale: 0.7,
      european-style: false,
      european-ieee-not-style: false,
      scale: auto,
      stroke: auto,
      fill: none,
      thickness: auto,
    ),
    style,
  ),
  ..inputs
)

#let and-port = logic-port.with(
  "and-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("and", style)
    } else {
      (style.european-ports)("&", style)
    }
  },
  (
    stroke: auto,
  )
)

#let nand-port = logic-port.with(
  "nand-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("nand", style)
    } else {
      (style.european-ports)("&", negated: true, style)
    }
  },
  (
    stroke: auto,
  )
)

#let or-port = logic-port.with(
  "or-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("or", style)
    } else {
      (style.european-ports)("\u{2265}1", style)
    }
  },
  (
    stroke: auto,
  )
)

#let nor-port = logic-port.with(
  "nor-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("nor", style)
    } else {
      (style.european-ports)("\u{2265}1", negated: true, style)
    }
  },
  (
    stroke: auto,
  )
)

#let xor-port = logic-port.with(
  "xor-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("xor", style)
    } else {
      (style.european-ports)("=1", style)
    }
  },
  (
    stroke: auto,
  )
)

#let xnor-port = logic-port.with(
  "xnor-port",
  style => {
    if not style.european-style {
      (style.ieee-multipoles)("xnor", style)
    } else {
      (style.european-ports)("=1", negated: true, style)
    }
  },
  (
    stroke: auto,
  )
)

#let buffer-port = logic-port.with(
  "buffer-port",
  style => {
    if not style.european-style {
      (style.ieee-dipoles)("buffer", style)
    } else {
      (style.european-ports)("1", style)
    }
  },
  (
    stroke: auto,
  )
)

#let not-port = logic-port.with(
  "not-port",
  style => {
    if not style.european-style {
      (style.ieee-dipoles)("not", style)
    } else {
      (style.european-ports)("1", negated: true, style)
    }
  },
  (
    stroke: auto,
  )
)

#let blank-port = logic-port.with(
  "blank-port",
  style => {
    (style.european-ports)("", style)
  },
  (
    stroke: auto,
  )
)

#let blank-not-port = logic-port.with(
  "blank-not-port",
  style => {
    (style.european-ports)("", negated: true, style)
  },
  (
    stroke: auto,
  )
)

#let schmitt-port = logic-port.with(
  "schmitt-port",
  style => (style.ieee-dipoles)("schmitt", style),
  (
    stroke: auto,
  )
)

#let invschmitt-port = logic-port.with(
  "invschmitt-port",
  style => (style.ieee-dipoles)("invschmitt", style),
  (
    stroke: auto,
  )
)

#let tgate = logic-port.with(
  "tgate",
  style => (style.ieee-transmissions)("single", style),
  (
    stroke: auto,
  )
)

#let double-tgate = logic-port.with(
  "double-tgate",
  style => (style.ieee-transmissions)("double", style),
  (
    stroke: auto,
  )
)

#let notcirc = logic-port.with(
  "notcirc",
  style => {
    let up = style.not-radius
    let left = -up

    // Anchors
    anchor("center", (0, 0))
    anchor("east", (left, 0))
    anchor("west", (-left, 0))
    anchor("south", (0, -up))
    anchor("north", (0, up))
    anchor("south-west", (-left, -up))
    anchor("north-west", (-left, up))
    anchor("north-east", (left, up))
    anchor("south-east", (left, -up))

    // Convinience anchors
    anchor("e", "east")
    anchor("w", "west")
    anchor("s", "south")
    anchor("n", "north")

    style.stroke.thickness *= style.thickness
    circle((0,0), radius: style.not-radius, stroke: style.stroke, fill: style.fill)
  },
  (
    stroke: auto
  )
)

#let schmitt-symbol = logic-port.with(
  "schmitt-symbol",
  style => {
    let up = style.schmitt-symbol-size * style.stdH
    let left = -1.5 * up

    // Anchors
    anchor("center", (0, 0))
    anchor("east", (left, 0))
    anchor("west", (-left, 0))
    anchor("south", (0, -up))
    anchor("north", (0, up))
    anchor("south-west", (-left, -up))
    anchor("north-west", (-left, up))
    anchor("north-east", (left, up))
    anchor("south-east", (left, -up))

    // Convinience anchors
    anchor("e", "east")
    anchor("w", "west")
    anchor("s", "south")
    anchor("n", "north")

    line((left, -up), (left/3, -up), (left/3, up), (-left, up), stroke: style.stroke, fill: none)
    line((-left/3, up), (-left/3, -up), (left, -up), stroke: style.stroke, fill: none)
  },
  (
    stroke: auto
  )
)