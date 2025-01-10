#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let capacitors(
  name,
  style,
  inputs
) = component(
  ("capacitors", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-style.width * 0.5, -style.height * 0.5))
    anchor("b", (style.width * 0.5, style.height * 0.5))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    if name in ("capacitor", "vcapacitor", "capacitivesens", "ferrocap") {
      // Dielectric
      rect((-x, -y), (x, y), fill: style.fill, stroke: none)
      // Plates
      line((-x, -y), (-x, y), stroke: body-stroke)
      line(( x, -y), ( x, y), stroke: body-stroke)

    } else if name == "ccapacitor" {
      let sin(start: (), amplitude: 1.1*x, scale: 2*y, samples: 100) = {
        line(..(for x in range(0, samples + 1) {
          let x = x / samples
          let p = calc.pi * x
          ((rel:(-calc.sin(p) * amplitude, -x * scale), to: start),)
        }), fill: none, stroke: body-stroke)
      }
      // Dielectric
      merge-path({
        line((-x, -y), (-x, y), (x, y))
        sin(start: (x, y))
        line((x, -y), (-x, -y))
      }, close: true, fill: style.fill, stroke: none)
      // Plates
      line((-x, -y), (-x, y), stroke: body-stroke)
      sin(start: (x, y))
      // Extend wire to curved capacitor
      line((-0.1*x, 0), (x,0), stroke: style.stroke)

    } else if name == "ecapacitor" {
      // Plus Pole
      rect((-x, -y), (-0.4*x, y), fill: style.fill, stroke: body-stroke)
      // Minus Pole
      rect((x, -y), (0.4*x, y), fill: black, stroke: body-stroke)
      // Plus Pole Annotation
      content((-1.2*x, 0.6*y), anchor: "east", text(size: 9pt)[$+$]) // Todo: Check Position and Size
    } else if name == "piezoelectric" {
      // Outer Markings
      line((-x, y), (-x, -y), stroke: body-stroke)
      line((x, y), (x, -y), stroke: body-stroke)
      // Inner Box
      rect((-0.6*x, -0.9*y), (0.6*x, 0.9*y), fill: style.fill, stroke: body-stroke)

    } else if name == "cpe" {
      // Dielectric
      merge-path({
        line((-x,  y),
             ( 0,  0),
             (-x, -y),
             ( 0, -y),
             ( x,  0),
             ( 0,  y))
      }, close: true, fill: style.fill, stroke: none)
      // Plates
      line((-x, y), (0,0), (-x, -y), stroke: body-stroke)
      line(( 0, y), (x,0), ( 0, -y), stroke: body-stroke)
      // Extend wire to the plate
      line((-x, 0), (0, 0), stroke: style.stroke)
    }

    // Additonal Decorations for special capacitors
    if name == "vcapacitor" {
      anchor("wiper", (-3*x, -y))
      anchor("tip", (3*x, y))
      line("wiper", "tip", mark: style.mark, stroke: body-stroke)
    } else if name == "capacitivesens" {
      anchor("wiper", (-4.4*x,-1.2*y))
      anchor("label", (-2.6*x,-1.2*y))
      anchor("tip",   ( 2.6*x,     y))
      line("wiper", "label", "tip", stroke: body-stroke)
    } else if name == "ferrocap" {

      let deco-x = 1.8*x
      let deco-y = 0.5*y

      anchor("curve-right", (-deco-x,  y))
      anchor("curve-left",  ( deco-x, -y))
      anchor("kink-right",  (-deco-x,  deco-y))
      anchor("kink-left",   ( deco-x, -deco-y))

      let corner-radius = 0.2 * x
      let angle = calc.atan2(2*deco-x, y)
      let hypothenuse = calc.sqrt(calc.pow(deco-x, 2) + calc.pow(deco-y, 2)) - corner-radius
      let diagonal-x = calc.cos(angle) * hypothenuse
      let diagonal-y = calc.sin(angle) * hypothenuse
      merge-path({
        line("curve-right", (rel:(0, corner-radius), to: "kink-right"))
        bezier((), (-diagonal-x, diagonal-y), ("kink-right"))
        line((), (diagonal-x, -diagonal-y))
        bezier((), (rel:(0, -corner-radius), to:("kink-left")), ("kink-left"))
        line((), "curve-left")
      }, close: false, fill:none, stroke: body-stroke)
    }
  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.2,
      height: 0.6,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style
  ),
  ..inputs
)

#let capacitor(..inputs) = capacitors("capacitor", (width: auto), inputs)
#let ccapacitor(..inputs) = capacitors("ccapacitor", (width: auto), inputs)
#let ecapacitor(..inputs) = capacitors("ecapacitor", (width: auto), inputs)
#let vcapacitor(..inputs) = capacitors("vcapacitor", (width: auto), inputs)
#let capacitivesens(..inputs) = capacitors("capacitivesens", (width: auto), inputs)
#let piezoelectric(..inputs) = capacitors("piezoelectric", (width: 0.4, height: 0.7), inputs)
#let cpe(..inputs) = capacitors("cpe", (width: 0.4, height: 0.6), inputs)
#let ferrocap(..inputs) = capacitors("ferrocap", (width: auto), inputs)