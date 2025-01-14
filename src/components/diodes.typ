#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let diodes(
  name,
  style,
  inputs
) = component(
  ("diodes", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    let body-fill = if style.style.diode == "full" {body-stroke.paint} else {style.fill}

    // Basic diode shape
    let varcap-offset = if(name == "varcap") {body-stroke.thickness.cm()*2*0.7} else {0} // Todo: Check why thew factor of 0.7 is needed
    if name == "tvsdiode" {
      merge-path({line((-x, y),(0, 0), (-x, -y))}, close: true, fill: body-fill, stroke: body-stroke)
      merge-path({line(( x, y),(0, 0), ( x, -y))}, close: true, fill: body-fill, stroke: body-stroke)

    } else if name == "shdiode" {
      merge-path({line((-x, -y), (-x, y), (x, 0), (-x, 0))}, close: true, fill: body-fill, stroke: body-stroke)

    } else if name in ("bidirectionaldiode", "triac") {
      let diode-width = 0.3
      merge-path({
        line((-x, 0),
             ( 0.95*x, -0.5*y),
             (-x, -y),
             (-x, y))
        }, close: true, fill: body-fill, stroke: body-stroke)
      merge-path({
        line(( x, 0),
             (-0.95*x, 0.5*y),
             ( x, y),
             ( x, -y))
        }, close: true, fill: body-fill, stroke: body-stroke)

    } else {
      merge-path({
        line((-x, y),(x - varcap-offset, 0), (-x, -y))
      }, close: true, fill: body-fill, stroke: body-stroke)
    }

    if style.style.diode == "stroke" and not name in ("shdiode", "bidirectionaldiode", "triac") {
      line((-x, 0),(x - varcap-offset, 0), stroke: style.stroke)
    }

    // Decorations
    if name == "sdiode" {
      line((0.6*x, -0.6*y),
           (0.6*x, -y),
           (x, -y),
           (x, y),
           (1.4*x, y),
           (1.4*x, 0.6*y),
          stroke: body-stroke)

    } else if name == "zdiode" {
      line((x, -y), (x, y), (0.6*x, y), stroke: body-stroke)

    } else if name == "zzdiode" {
      let whisker-factor = if style.straight-whiskers {0} else {0.5}
      line((1.8*x, -(1 + whisker-factor) * y),
           (x, -y),
           (x, y),
           (0.2*x, (1 + whisker-factor) * y),
          stroke: body-stroke)

    } else if name == "tdiode" {
      line((0.6*x, -y), (x, -y), (x, y), (0.6*x, y), stroke: body-stroke)

    } else if name == "tvsdiode" {
      let whisker-factor = if style.straight-whiskers {1} else {1.3}
      line((-0.4*x, whisker-factor * y), (0, y), (0, -y), (0.4*x, -whisker-factor * y), stroke: body-stroke)

    } else if name == "triac" {
      anchor("gate", (style.gate-kink*(1/0.3)*x, (1/0.8484)*y))
      line((x, 0.5*y), ("gate", "|-", (0, y)), ("gate"), stroke: style.stroke)

    } else if not name in ("bidirectionaldiode", ) {
      // Simple line
      line((x, y), (x, -y), stroke: body-stroke)

      // Additional decorations
      if name == "laserdiode" {
        anchor("arrows", (-0.1*x, 2.2*y))
        line((0, -y), (0, y), stroke: body-stroke)

        line((-0.4*x, 1.1*y), (-0.4*x, 2.1*y), mark: style.mark, stroke: body-stroke)
        line((0.2*x, 1.1*y), (0.2*x, 2.1*y), mark: style.mark, stroke: body-stroke)
      } else if name == "varcap" {
        line((x - varcap-offset, y), (x - varcap-offset, -y), stroke: body-stroke)
      } else if name in ("thyristor", "gto", "gtobar") {
        anchor("gate", (style.gate-kink*(1/0.4)*x, (1.1/0.5)*y))
        line((x, 0), ("gate", "|-", (0, y)), ("gate"), stroke: style.stroke)
        if name == "gto" {
          line((x, 0.5*y), ("gate", "|-", (0, 1.5*y)), stroke: style.stroke)
        }
      } else if name in ("put", "agtobar") {
        anchor("gate", (-style.gate-kink*(1/0.4)*x, (1.1/0.5)*y))
        line((-x, 0), ("gate", "|-", (0, y)), ("gate"), stroke: style.stroke)
      }
      
      if name in ("gtobar", "agtobar") {
        line((rel: (-(1/0.4)*style.gto-bar-width*x, 0), to:("gate", "|-", (0, (1+(1.1/0.5)*y)*0.5*(1.1/0.5)*y))), (rel:(2*(1/0.4)*style.gto-bar-width*x,0)), stroke: style.stroke)
      }
    }

    // Arrows
    if name in ("pdiode", "lediode") {
      let mark = style.mark
      if name == "lediode" {
        mark.start = mark.end
        mark.end = none
      }

      if style.arrows-from-anode {
        anchor("arrows", (1.0*x, 2.0*y))
        line((0.6*x, 2*y), (-0.4*x, y), mark: mark, stroke: body-stroke)
        line((1.2*x, 1.8*y), (0.2*x, 0.8*y), mark: mark, stroke: body-stroke)
      } else {
        anchor("arrows", (-0.2*x, 2.0*y))
        line((-0.6*x, 1.8*y), (0, 0.8*y), mark: mark, stroke: body-stroke)
        line((0, 1.6*y), (0.6*x, 0.6*y), mark: mark, stroke: body-stroke)
      }
    }

  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.4,
      height: 0.5,
      straight-whiskers: false,
      arrows-from-anode: true,
      gate-kink: 1.0,
      gto-bar-width: 0.2,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style,
  ),
  ..inputs
)

#let diode(..inputs) = diodes("diode", (width: auto), inputs)
#let sdiode(..inputs) = diodes("sdiode", (width: auto), inputs)
#let zdiode(..inputs) = diodes("zdiode", (width: auto), inputs)
#let zzdiode(..inputs) = diodes("zzdiode", (width: auto), inputs)
#let tdiode(..inputs) = diodes("tdiode", (width: auto), inputs)
#let pdiode(..inputs) = diodes("pdiode", (width: auto), inputs)
#let lediode(..inputs) = diodes("lediode", (width: auto), inputs)
#let laserdiode(..inputs) = diodes("laserdiode", (width: auto), inputs)
#let varcap(..inputs) = diodes("varcap", (width: 0.45), inputs)
#let tvsdiode(..inputs) = diodes("tvsdiode", (width: 0.8), inputs)
#let shdiode(..inputs) = diodes("shdiode", (width: auto), inputs)
#let bidirectionaldiode(..inputs) = diodes("bidirectionaldiode", (width: 0.3, height: 0.8484), inputs)
#let triac(..inputs) = diodes("triac", (width: 0.3, height: 0.8484), inputs)
#let thyristor(..inputs) = diodes("thyristor", (width: auto), inputs)
#let put(..inputs) = diodes("put", (width: auto), inputs)
#let gto(..inputs) = diodes("gto", (width: auto), inputs)
#let gtobar(..inputs) = diodes("gtobar", (width: auto), inputs)
#let agtobar(..inputs) = diodes("agtobar", (width: auto), inputs)