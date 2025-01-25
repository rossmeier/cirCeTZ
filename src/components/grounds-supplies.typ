#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let grounds(
  name,
  func,
  style,
  ..inputs
) = component(
  ("grounds", name),
  style => {
    style.width = 0.25

    anchor("text", (0.5 * style.label.first(), 0))

    // The "standard" ground symbol
    style.ground-lines = (yOffset) => {
      let body-stroke = style.stroke
      body-stroke.thickness *= style.thickness

      line(
        (-0.6 * style.width, (yOffset - 0) * style.width),
        (0.6 * style.width, (yOffset - 0) * style.width),
        stroke: body-stroke
      )
      line(
        (-0.4 * style.width, (yOffset - 0.2) * style.width),
        (0.4 * style.width, (yOffset - 0.2) * style.width),
        stroke: body-stroke
      )
      line(
        (-0.25 * style.width, (yOffset - 0.4) * style.width),
        (0.25 * style.width, (yOffset - 0.4) * style.width),
        stroke: body-stroke
      )
    }

    func(style)
  },
  (
    (
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
    ),
    style,
  ),
  ..inputs
)

#let ground(..inputs) = grounds(
  "ground",
  style => {
    line((0,0), (0, -1.2 * style.width), stroke: style.stroke)
    (style.ground-lines)(-1.2)
  },
  (
    stroke: auto,
  ),
  ..inputs
)

#let tlground(..inputs) = grounds(
  "tlground",
  style => {
    (style.ground-lines)(0)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let rground(..inputs) = grounds(
  "rground",
  style => {
    line((0,0), (0, -style.width), stroke: style.stroke)
    style.stroke.thickness *= style.thickness
    line((-0.6 *style.width, -style.width), (0.6 * style.width, -style.width), stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let sground(..inputs) = grounds(
  "sground",
  style => {
    line((0,0), (0, -style.width), stroke: style.stroke)
    style.stroke.thickness *= style.thickness
    line(
      (-0.6 * style.width, -style.width),
      (0.6 * style.width, -style.width),
      (0, -1.8 * style.width),
      close: true,
      fill: style.fill,
      stroke: style.stroke
    )
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let tground(..inputs) = grounds(
  "tground",
  style => {
    anchor("west", (-0.6 * style.width, 0))
    anchor("east", (0.6 * style.width, 0))
    style.stroke.thickness *= style.thickness
    line((-0.6 * style.width, 0), (0.6 * style.width, 0), stroke: style.stroke)
  },
  (
    stroke: auto,
    thickness: 3
  ),
  ..inputs
)

#let nground(..inputs) = grounds(
  "nground",
  style => {
    line((0,0), (0, -1.2 * style.width), stroke: style.stroke)
    (style.ground-lines)(-1.2)
    style.stroke.thickness *= style.thickness
    arc((0.9 * style.width, -1.6 * style.width), start: 0deg, stop: 180deg, radius: 0.9 * style.width, fill: none, stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let pground(..inputs) = grounds(
  "pground",
  style => {
    let circle-stroke = style.stroke
    circle-stroke.thickness *= style.thickness
    circle((0, -0.9 * style.width), radius: 0.9 * style.width, fill: style.fill, stroke: circle-stroke)
    (style.ground-lines)(-1.0)
    line((0,0), (0, -1 * style.width), stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let cground(..inputs) = grounds(
  "cground",
  style => {
    line((0,0), (0, -1.5 * style.width), stroke: style.stroke)
    style.stroke.thickness *= style.thickness
    line(
      (-1.0  * style.width, -2.1 * style.width),
      (-0.75 * style.width, -1.5 * style.width),
      ( 0.75 * style.width, -1.5 * style.width),
      ( 0.5  * style.width, -2.1 * style.width),
      fill: none, stroke: style.stroke)
    line((0, -1.5 * style.width), (-0.25 * style.width, -2.1 * style.width), stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let eground(..inputs) = grounds(
  "eground",
  style => {
    line((0,0), (0, -style.width), stroke: style.stroke)
    for x in (-1.1, -0.6, -0.1, 0.4) {
      line((x * style.width, -1.7 * style.width), ((x + 0.5) * style.width, -style.width), stroke: style.stroke)
    }
    style.stroke.thickness *= style.thickness
    line((-style.width, -style.width), (style.width, -style.width), stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let eground2(..inputs) = grounds(
  "eground2",
  style => {
    line((0,0), (0, -style.width), stroke: style.stroke)
    for x in (-1.1, -0.45, 0.2) {
      line((x * style.width, -1.7 * style.width), ((x + 0.7) * style.width, -style.width), stroke: style.stroke)
    }
    style.stroke.thickness *= style.thickness
    line((-style.width, -style.width), (style.width, -style.width), stroke: style.stroke)
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let power-supplies(
  name,
  func,
  style,
  ..inputs
  ) = component(
  ("power-supplies", name),
  style => {
    style.width = 0.2

    style.supplie-arrow = {
      let body-stroke = style.stroke
      body-stroke.thickness *= style.thickness
      line(
        (-0.5 * style.width, 0.8 * style.width),
        (0, 1.5 * style.width),
        (0.5 * style.width, 0.8 * style.width),
        stroke: body-stroke
      )
      line((0,0), (0, 1.5 * style.width), stroke: style.stroke)
    }

    func(style)

    anchor("text", (0, 2 * style.width + style.label.last() * 0.5))
  },
  (
    (
      scale: auto,
      fill: none,
      thickness: auto,
      stroke: auto,
    ),
    style,
  ),
  ..inputs
)

#let vcc(..inputs) = power-supplies(
  "vcc",
  style => {
    style.supplie-arrow
  },
  (
    stroke: auto
  ),
  ..inputs
)

#let vee(..inputs) = power-supplies(
  "vee",
  style => {
    scale(y: -1)
    style.supplie-arrow
  },
  (
    stroke: auto
  ),
  ..inputs
)