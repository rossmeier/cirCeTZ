#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let inductors(
  name,
  style,
  inputs
) = component(
  ("inductors", name),
  style => {

    // Default Style Values
    let cute-style = (height: 0.3, width: 0.6, coils: 5)
    let american-style = (height: 0.3, width: 0.8, coils: 4)
    let european-style = (height: 0.3, width: 0.8)
    if style.style.inductor == "cute" {
      style = cute-style + style
    } else if style.style.inductor == "american" {
      style = american-style + style
    } else if style.style.inductor == "european" {
      style = european-style + style
    }

    let x = style.width / 2
    let y = style.height / 2
    let coil-y = if style.style.inductor == "european" {y} else {style.coil-height / 2}

    anchor("a", (-style.width * 0.5, -style.height * 0.5))
    anchor("b", ( style.width * 0.5,  style.height * 0.5))

    anchor("core-east", (rel:(0,  style.core-distance), to: ( x,y)))
    anchor("core-west", (rel:(0,  style.core-distance), to: (-x,y)))

    anchor("ll-dot", (rel:(-style.dot-x-distance, -style.dot-y-distance), to: (-x,-coil-y)))
    anchor("ul-dot", (rel:(-style.dot-x-distance,  style.dot-y-distance), to: (-x, y)))
    anchor("lr-dot", (rel:( style.dot-x-distance, -style.dot-y-distance), to: ( x,-coil-y)))
    anchor("ur-dot", (rel:( style.dot-x-distance,  style.dot-y-distance), to: ( x, y)))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    // Todo: Check why the factor of 0.7 is needed
    let line-width = body-stroke.thickness.cm() * 0.7
    let start-line-width = style.stroke.thickness.cm() * 0.7

    if style.style.inductor == "cute" {
      anchor("midtap", (0, if calc.even(style.coils) {-coil-y} else {y}))

      let small-coil-width = 0.5 * style.coil-aspect * style.width / (style.coils - 1)
      let step = (style.width + line-width/2 + (style.coils - 1) * 2 * small-coil-width) / style.coils / 2

      move-to((-x - line-width/2, -0.5*start-line-width))
      merge-path({
        for _ in range(0, style.coils - 1) {
          arc((), start: 180deg, stop: 0deg, radius: (step, y))
          arc((), start: 0deg, stop: -180deg, radius: (small-coil-width, coil-y))
        }
        arc((), start: 180deg, stop: 0deg, radius: (step, y))
      }, close: false, fill: none, stroke: body-stroke)

    } else if style.style.inductor == "american" {
      anchor("midtap", (0, if calc.even(style.coils) {0} else {coil-y*2}))

      let step = (x*2 + line-width) / style.coils / 2
      move-to((-x -0.5*line-width, -0.5*start-line-width))
      merge-path({
        for _ in range(0, style.coils) {
          arc((), start: 180deg, stop: 0deg, radius: (step, coil-y*2))
        }
      }, close: false, fill: none, stroke: body-stroke)

      coil-y = y / 3 // Since the american inductor has not coils on the bottom the distance of additioinal decorations is reduced

    } else if style.style.inductor == "european" {
      anchor("midtap", (0, y))
      rect((-x, -y), (x, y), fill: style.stroke.paint, stroke: body-stroke)
    }

    // Additonal Decorations for special inductors
    if name == "vinductor" {
      let xFactor = if style.style.inductor == "european" {0.5} else {0.4}
      
      anchor("wiper", (-xFactor*x, -coil-y*2))
      anchor("tip", (xFactor*x, y*2))

      line("wiper", "tip", mark: style.mark, stroke: body-stroke)

    } else if name == "sinductor" {
      let (xFactor-label, yFactor-label, xFactor-wiper, xFactor-tip, yFactor-tip) = if style.style.inductor == "european" {
        (0.4, 2, 1, 1, 2)
      } else {
        (0.8, 2.6, 1.6, 0.8, 2)
      }

      anchor("label", (-xFactor-label*x, -yFactor-label*coil-y))
      anchor("wiper", (-xFactor-wiper*x, -yFactor-label*coil-y))
      anchor("tip", (xFactor-tip*x, yFactor-tip*y))
      line("wiper", "label", "tip", stroke: body-stroke)
    }

  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      coil-height: 0.15,
      coil-aspect: 0.5,
      core-distance: 2pt,
      dot-x-distance: 4pt,
      dot-y-distance: 1pt,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style,
  ),
  ..inputs
)

#let inductor(..inputs) = inductors("inductor", (style: auto), inputs)
#let vinductor(..inputs) = inductors("vinductor", (style: auto), inputs)
#let sinductor(..inputs) = inductors("sinductor", (style: auto), inputs)