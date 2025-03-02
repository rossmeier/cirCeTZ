#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let resistors(
  name,
  func,
  style,
  ..inputs
) = component(
  ("resistors", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))
    anchor("text", (0.5 * style.label.first(), 0))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    // Zig-Zag Resistor
    style.zig-zag-resistor = (scale: 1.0) => {
      let step = style.width / (style.zigs * 2)
      let sgn  = -1
      line(
        (-x * scale, 0),
        (rel: (step/2 * scale, y * scale)),
        ..for _ in range(style.zigs * 2 - 1) {
          ((rel: (step * scale, 2 * y * sgn * scale)),)
          sgn *= -1
        },
        (x * scale, 0),
        fill: none, stroke: body-stroke
      )
    }

    // Rectangular Resistor
    style.rect-resistor = (scale: 1.0) => {
      rect(("a", (1.0 - scale) * 100%, (0,0)), ("b", (1.0 - scale) * 100%, (0,0)), fill: style.fill, stroke: body-stroke)
    }

    // Resistor shape according to the style
    style.resistor = {
      if style.style.resistor == "american" {
        style.zig-zag-resistor
      } else if style.style.resistor == "european" {
        style.rect-resistor
      }
    }

    // Variable Resistor Arrow
    style.var-arrow = (wiper-dim : (0.4, 2)) => {
      let dir = if style.reverse-dir {-1} else {1}
      anchor("wiper", (wiper-dim.first() * -x * dir, wiper-dim.last() * -y*dir))
      anchor("tip",   (wiper-dim.first() *  x * dir, wiper-dim.last() *  y*dir))
      line("wiper", "tip", mark: style.mark, stroke: body-stroke)

      // Move anchors to account for the arrow
      anchor("a", (-x, -y * wiper-dim.last()))
      anchor("b", ( x,  y * wiper-dim.last()))
    }

    // Potentiometer Arrow
    style.pot-arrow = () => {
      anchor("wiper", (style.wiper-pos * style.width - x, style.height*(4/3)))
      anchor("tip", ("wiper", "|-", (0, style.height/2)))
      line("wiper", "tip", mark: style.mark, stroke: body-stroke)

      // Move anchors to account for the arrow
      anchor("a", (-x, -style.height*(4/3)))
      anchor("b", ( x,  style.height*(4/3)))
    }

    // Resistive Sensor Line
    style.sense-line = (label-xScale: 0.4, tip-xScale: 0.4, wiper-xScale: 0.9, tip-yScale: 2, wiper-yScale: 2) => {
      anchor("wiper", (wiper-xScale * -x, -y * wiper-yScale))
      anchor("label", (label-xScale * -x, -y * wiper-yScale))
      anchor("tip", (tip-xScale * x, y * tip-yScale))
      line("wiper", "label", "tip", stroke: body-stroke)

      // Move anchors to account for the arrow
      anchor("a", (-x, -y * calc.max(tip-yScale, wiper-yScale)))
      anchor("b", ( x,  y * calc.max(tip-yScale, wiper-yScale)))
    }

    // PTC and NTC Thermistor Decorations
    style.thermistor-decor = (positive: true) => {
      (style.sense-line)(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.4)

      let mark-style = style.mark // Todo: Check the size of the arrow head
      mark-style.scale *= (2/3)
      let arrow-pos-factor = (0.75/0.7)

      // Todo: Check the positioning of the arrows
      line((-0.62*x, -2*arrow-pos-factor*y), (-0.62*x, -1.4*arrow-pos-factor*y), mark: mark-style, strok: body-stroke)
      if positive {
        line((-0.45*x, -2*arrow-pos-factor*y), (-0.45*x, -1.4*arrow-pos-factor*y), mark: mark-style, strok: body-stroke)
      } else {
        line((-0.45*x, -1.4*arrow-pos-factor*y), (-0.45*x, -2*arrow-pos-factor*y), mark: mark-style, strok: body-stroke)
      }
      content((-0.85*x, -1.5*y), anchor: "north", text(size: 4pt)[\u{03D1}])
    }

    func(style)
  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.8,
      height: 0.3,
      zigs: 3,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
      wiper-pos: 0.5,
      reverse-dir: false,
    ),
    style,
  ),
  ..inputs
)

#let generic(..inputs) = resistors(
  "generic",
  style => {
    (style.rect-resistor)()
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let xgeneric(..inputs) = resistors(
  "xgeneric",
  style => {
    (style.rect-resistor)()
    let cross-stroke = style.stroke
    cross-stroke.thickness *= style.thickness
    line("a", "b", stroke: cross-stroke)
    line(("a", "|-", "b"), ("b", "|-", "a"), stroke: cross-stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let sgeneric(..inputs) = resistors(
  "sgeneric",
  style => {
    (style.rect-resistor)()
    let slash-stroke = style.stroke
    slash-stroke.thickness *= style.thickness
    line("a", "b", stroke: slash-stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let tgeneric(..inputs) = resistors(
  "tgeneric",
  style =>  {
    let wiper-dim = (0.5, 7/3)
    (style.rect-resistor)()
    (style.var-arrow)(wiper-dim: wiper-dim)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let ageneric(..inputs) = resistors(
  "ageneric",
  style => {
    (style.rect-resistor)()
    rect((0.35*style.width, -style.height/2), (style.width/2, style.height/2), fill: style.stroke.paint, stroke: none)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let memristor(..inputs) = resistors(
  "memristor",
  style => {
    (style.rect-resistor)()
    rect((0.35*style.width, -style.height/2), (style.width/2, style.height/2), fill: style.stroke.paint, stroke: none)
    let wave-height = 0.5
    let x = style.width / 2
    let y = style.height / 2
    line(
      (-x, 0),
      (-0.72*x,  0),
      (-0.72*x,  wave-height*y),
      (-0.35*x,  wave-height*y),
      (-0.35*x, -wave-height*y),
      ( 0.05*x, -wave-height*y),
      ( 0.05*x,  wave-height*y),
      ( 0.42*x,  wave-height*y),
      ( 0.42*x,  0),
      ( x, 0),
      stroke: style.stroke)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let resistor(..inputs) = resistors(
  "resistor",
  style => {
    (style.resistor)()
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let vresistor(..inputs) = resistors(
  "vresistor",
  style => {
    (style.resistor)()
    (style.var-arrow)(..if style.style.resistor == "european" {(wiper-dim: (0.5, 7/3))})
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let potentiometer(..inputs) = resistors(
  "potentiometer",
  style => {
    (style.resistor)()
    (style.pot-arrow)()
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let resistivesens(..inputs) = resistors(
  "resistivesens",
  style => {
    (style.resistor)()
    (style.sense-line)(..if style.style.resistor == "european" {(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.68)})
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let ldresistor(..inputs) = resistors(
  "ldresistor",
  style => {
    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness
    circle((0,0), radius: style.width/2, fill: style.fill, stroke: body-stroke)

    let resistor-scale = 0.8
    (style.resistor)(scale: resistor-scale)

    let x = style.width / 2
    // Arrows
    anchor("arrows", (1.6*x, 1.4*x))
    line((1.4*x, 1.4*x), (0.8*x, 0.8*x), mark: style.mark, stroke: body-stroke)
    line((1.6*x, 1.2*x), (1.0*x, 0.6*x), mark: style.mark, stroke: body-stroke)

    // Connect the leads to the end of the component
    line((-x, 0), (resistor-scale * -x, 0), stroke: body-stroke)
    line((x, 0), (resistor-scale * x, 0), stroke: body-stroke)

    // Account for the arrows
    // Its a circle so its a square ;)
    anchor("a", (-x, -x * 1.6))
    anchor("b", ( x,  x * 1.6))
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let varistor(..inputs) = resistors(
  "varistor",
  style => {
    (style.rect-resistor)()
    (style.sense-line)(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.4)
    content((-0.65 * style.width/2, 1.4 * -style.height/2), anchor: "north", text(size: 5pt)[U]) // Todo: Check the size of the text
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let mov(..inputs) = resistors(
  "mov",
  style => {
    (style.rect-resistor)()
    let x = style.width / 2
    let y = style.height / 2
    line(
      (-1.0*x, -1.54*y),
      (-0.7*x, -1.54*y),
      ( 0.7*x,  1.54*y),
      ( 1.0*x,  1.54*y),
      stroke: {let body-stroke = style.stroke; body-stroke.thickness *= style.thickness; body-stroke}
    )

    // Account for the line
    anchor("a", (-x, -y * 1.54))
    anchor("b", ( x,  y * 1.54))
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let photoresistor(..inputs) = resistors(
  "photoresistor",
  style => {
    (style.rect-resistor)()

    anchor("arrows", (0.575*style.width/2, 2.2*style.height/2))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    let mark-style = style.mark // Todo: Check the size of the arrow head
    mark-style.scale *= (2/3)

    line((0.70*style.width/2, 2*style.height/2), (0.30*style.width/2, 1.2*style.height/2), mark: mark-style, stroke: body-stroke)
    line((0.45*style.width/2, 2*style.height/2), (0.05*style.width/2, 1.2*style.height/2), mark: mark-style, stroke: body-stroke)

    // Account for the line
    anchor("a", (-style.width/2, -2*style.height/2))
    anchor("b", ( style.width/2,  2*style.height/2))
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let thermistor(..inputs) = resistors(
  "thermistor",
  style => {
    (style.rect-resistor)()
    (style.sense-line)(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.68)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let thermistorptc(..inputs) = resistors(
  "thermistorptc",
  style => {
    (style.rect-resistor)()
    (style.thermistor-decor)(positive: true)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let thermistorntc(..inputs) = resistors(
  "thermistorntc",
  style => {
    (style.rect-resistor)()
    (style.thermistor-decor)(positive: false)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let short(..inputs) = component(
  "short",
  (style) => {
    // anchor("a", (0.05, 0.05))
    // anchor("b", (-0.05, -0.05))
  },
  (
    stroke: auto
  ),
  ..inputs
)