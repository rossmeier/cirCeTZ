#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let grounds(
  name,
  style,
  inputs
) = component(
  ("grounds", name),
  style => {
    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    anchor("left", (0,0))
    anchor("right", (0,0))

    // The "standard" ground symbol
    let ground-lines = (yOffset) => {
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

    if name == "ground" {
      line((0,0), (0, -1.2 * style.width), stroke: style.stroke)
      ground-lines(-1.2)

    } else if name == "tlground" {
      ground-lines(0)

    } else if name == "rground" {
      line((0,0), (0, -style.width), stroke: style.stroke)
      style.stroke.thickness *= style.thickness
      line((-0.6 *style.width, -style.width), (0.6 * style.width, -style.width), stroke: style.stroke)

    } else if name == "sground" {
      line((0,0), (0, -style.width), stroke: style.stroke)
      style.stroke.thickness *= style.thickness
      merge-path({
        line((-0.6 * style.width, -style.width), (0.6 * style.width, -style.width))
        line((), (0, -1.8 * style.width))
      },close: true, fill: style.fill, stroke: style.stroke)

    } else if name == "tground" {
      anchor("west", (-0.6 * style.width, 0))
      anchor("east", (0.6 * style.width, 0))
      style.stroke.thickness *= style.thickness
      line((-0.6 * style.width, 0), (0.6 * style.width, 0), stroke: style.stroke)

    } else if name == "nground" {
      line((0,0), (0, -1.2 * style.width), stroke: style.stroke)
      ground-lines(-1.2)
      style.stroke.thickness *= style.thickness
      arc((0.9 * style.width, -1.6 * style.width), start: 0deg, stop: 180deg, radius: 0.9 * style.width, fill: none, stroke: style.stroke)

    } else if name == "pground" {
      circle((0, -0.9 * style.width), radius: 0.9 * style.width, fill: style.fill, stroke: body-stroke)
      ground-lines(-1.0)
      line((0,0), (0, -1 * style.width), stroke: style.stroke)

    } else if name == "cground" {
      line((0,0), (0, -1.5 * style.width), stroke: style.stroke)
      style.stroke.thickness *= style.thickness
      line(
        (-1.0  * style.width, -2.1 * style.width),
        (-0.75 * style.width, -1.5 * style.width),
        ( 0.75 * style.width, -1.5 * style.width),
        ( 0.5  * style.width, -2.1 * style.width),
        fill: none, stroke: style.stroke)
      line((0, -1.5 * style.width), (-0.25 * style.width, -2.1 * style.width), stroke: style.stroke)

    } else if name == "eground" {
      line((0,0), (0, -style.width), stroke: style.stroke)
      for x in (-1.1, -0.6, -0.1, 0.4) {
        line((x * style.width, -1.7 * style.width), ((x + 0.5) * style.width, -style.width), stroke: style.stroke)
      }
      style.stroke.thickness *= style.thickness
      line((-style.width, -style.width), (style.width, -style.width), stroke: style.stroke)

    } else if name == "eground2" {
      line((0,0), (0, -style.width), stroke: style.stroke)
      for x in (-1.1, -0.45, 0.2) {
        line((x * style.width, -1.7 * style.width), ((x + 0.7) * style.width, -style.width), stroke: style.stroke)
      }
      style.stroke.thickness *= style.thickness
      line((-style.width, -style.width), (style.width, -style.width), stroke: style.stroke)

    } else {
      panic("Unknown ground type: \(name)")
    }
  },
  (
    (
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.25
    ),
    style,
  ),
  ..inputs
)

#let ground(..inputs) = grounds("ground", (width: auto), inputs)
#let tlground(..inputs) = grounds("tlground", (width: auto), inputs)
#let rground(..inputs) = grounds("rground", (width: auto), inputs)
#let sground(..inputs) = grounds("sground", (width: auto), inputs)
#let tground(..inputs) = grounds("tground", (width: auto, thickness: 3), inputs)
#let nground(..inputs) = grounds("nground", (width: auto), inputs)
#let pground(..inputs) = grounds("pground", (width: auto), inputs)
#let cground(..inputs) = grounds("cground", (width: auto), inputs)
#let eground(..inputs) = grounds("eground", (width: auto), inputs)
#let eground2(..inputs) = grounds("eground2", (width: auto), inputs)

#let power-supplies(
  name,
  style,
  inputs
  ) = component(
  ("power-supplies", name),
  style => {
    set-style(stroke: style.stroke)
    anchor("left", (0,0))
    anchor("right", (0,0))
    if name == "vee" {
      // panic()
      scale(y: -1)
    }
    let width = style.width
    anchor("text", (
      0,
      2 * width + style.label.last() * 0.5
    ))
    line(
      (-0.5 * width, 0.8 * width),
      (0, 1.5 * width),
      (0.5 * width, 0.8 * width),
      stroke: (thickness: style.stroke.thickness * style.thickness)
    )
    line((0,0), (0, 1.5 * width))
  },
  (
    (
      scale: auto,
      fill: none,
      thickness: auto,
      stroke: auto,
      width: 0.2
    ),
    style
  ),
  ..inputs
)

#let vcc(..inputs) = power-supplies("vcc", (width: auto), inputs)
#let vee(..inputs) = power-supplies("vee", (width: auto), inputs)