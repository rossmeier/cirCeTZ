#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let resistors(
  name,
  style,
  inputs
) = component(
  ("resistors", name),
  style => {
    let x = style.width / 2
    let height = style.height

    anchor("a", (-x, -height/2))
    anchor("b", (x, height/2))

    let resistor-style = style.style.resistor

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    let draw-Resistor = (scale: 1.0) => {
      if resistor-style == "american" {
        // Zig-Zag Resistor
        let step = style.width / (style.zigs * 2)
        let sgn  = -1
        line((-x * scale, 0), (rel: (step/2 * scale, height/2 * scale)),
          ..for _ in range(style.zigs * 2 - 1) {
            ((rel: (step * scale, height * sgn * scale)),)
            sgn *= -1
          },
          (x * scale, 0),
          fill: none, stroke: body-stroke)
      } else if resistor-style == "european" {
        // Rectangular Resistor
        rect((-x * scale, -height/2 * scale), (x * scale, height/2 * scale), fill: style.fill, stroke: body-stroke)
      }
    }

    let draw-Variable-Line = (label-xScale: 0.4, tip-xScale: 0.4, wiper-xScale: 0.9, tip-yScale: 2, wiper-yScale: 2) => {
      anchor("wiper", (wiper-xScale * -x, -height/2 * wiper-yScale))
      anchor("label", (label-xScale * -x, -height/2 * wiper-yScale))
      anchor("tip", (tip-xScale * x, height/2 * tip-yScale))
      line("wiper", "label", "tip", stroke: body-stroke)
    }

    if name in ("generic", "resistor") {
      draw-Resistor()

    } else if name == "xgeneric" {
      draw-Resistor()
      line((-x, -height/2), (x,  height/2), stroke: body-stroke)
      line((-x,  height/2), (x, -height/2), stroke: body-stroke)

    } else if name == "sgeneric" {
      draw-Resistor()
      line((-x, -height/2), (x,  height/2), stroke: body-stroke)

    } else if name in ("tgeneric", "vresistor") {
      let xScale = 0.4 // Arrow steapness
      let yScale = 2 // Account for the arrow height
      let dir = if style.reverse-dir {-1} else {1}

      if resistor-style == "european" {
        xScale = 0.5
        yScale = (7/3)
      }

      anchor("wiper", (xScale * -x * dir, yScale * -height/2*dir))
      anchor("tip",   (xScale *  x * dir, yScale *  height/2*dir))

      draw-Resistor()
      line("wiper", "tip", mark: style.mark, stroke: body-stroke)

    } else if name in ("ageneric", "memristor") {
      draw-Resistor()
      rect((0.7*x, -height/2), (x, height/2), fill: black, stroke: none)
      if name == "memristor" {
        let wave-height = 0.25
        line(
          (-x, 0),
          (-0.72*x,  0),
          (-0.72*x,  wave-height*height),
          (-0.35*x,  wave-height*height),
          (-0.35*x, -wave-height*height),
          ( 0.05*x, -wave-height*height),
          ( 0.05*x,  wave-height*height),
          ( 0.42*x,  wave-height*height),
          ( 0.42*x,  0),
          ( x, 0),
          stroke: style.stroke)
      }

    } else if name == "potentiometer" {
      anchor("wiper", (style.wiper-pos * style.width - x, height*(4/3)))
      anchor("tip", ("wiper", "|-", (0, height/2)))

      draw-Resistor()
      line("wiper", "tip", mark: style.mark, stroke: body-stroke)

    } else if name in ("resistivesens", "thermistor") {
      draw-Resistor()
      if resistor-style == "european" {
        draw-Variable-Line(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.68)
      } else {
        draw-Variable-Line()
      }

    } else if name == "ldresistor" {
      anchor("a", (-x, -x)) // Its a circle so its a square ;)
      anchor("b", (x, x))

      let resistor-scale = 0.8

      circle((0,0), radius: x, fill: style.fill, stroke: body-stroke)
      {
        let x = x * 0.8
        let height = height * 0.8
        draw-Resistor(scale: resistor-scale)
      }

      // Arrows
      anchor("arrows", (1.6*x, 1.4*x))
      line((1.4*x, 1.4*x), (0.8*x, 0.8*x), mark: style.mark, stroke: body-stroke)
      line((1.6*x, 1.2*x), (1.0*x, 0.6*x), mark: style.mark, stroke: body-stroke)

      // Connect the leads to the end of the component
      line((-x, 0), (resistor-scale * -x, 0), stroke: body-stroke)
      line((x, 0), (resistor-scale * x, 0), stroke: body-stroke)

    } else if name == "varistor" {
      draw-Resistor()
      draw-Variable-Line(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.4)
      content((-0.65 * x, 1.4 * -height/2), anchor: "north", text(size: 5pt)[U]) // Todo: Check the size of the text

    } else if name == "mov" {
      draw-Resistor()
      line((-1.0*x, -1.54*height/2), (-0.7*x, -1.54*height/2), (0.7*x, 1.54*height/2), (1.0*x, 1.54*height/2) ,stroke: body-stroke)

    } else if name == "photoresistor" {
      draw-Resistor()
      anchor("arrows", (0.575*x, 2.2*height/2))
      let mark-style = style.mark // Todo: Check the size of the arrow head
      mark-style.scale *= (2/3)
      line((0.70*x, 2*height/2), (0.30*x, 1.2*height/2), mark: mark-style, stroke: body-stroke)
      line((0.45*x, 2*height/2), (0.05*x, 1.2*height/2), mark: mark-style, stroke: body-stroke)

    } else if name in ("thermistorptc", "thermistorntc"){
      draw-Resistor()
      draw-Variable-Line(tip-xScale: 1.0, wiper-xScale: 1.0, tip-yScale: 1.4, wiper-yScale: 1.4)
      let mark-style = style.mark // Todo: Check the size of the arrow head
      mark-style.scale *= (2/3)
      let arrow-pos-factor = (0.75/0.7)
      // Todo: Check the positioning of the arrows
      line((-0.62*x, -arrow-pos-factor*height), (-0.62*x, -0.7*arrow-pos-factor*height), mark: mark-style, strok: body-stroke)
      if name == "thermistorptc" {
        line((-0.45*x, -arrow-pos-factor*height), (-0.45*x, -0.7*arrow-pos-factor*height), mark: mark-style, strok: body-stroke)
      } else {
        line((-0.45*x, -0.70*arrow-pos-factor*height), (-0.45*x, -arrow-pos-factor*height), mark: mark-style, strok: body-stroke)
      }
      content((-0.85*x, -0.75*height), anchor: "north", text(size: 4pt)[\u{03D1}])
    }

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

#let generic(..inputs) = resistors("generic", (width: auto, style: (resistor: "european")), inputs)
#let xgeneric(..inputs) = resistors("xgeneric", (width: auto, style: (resistor: "european")), inputs)
#let sgeneric(..inputs) = resistors("sgeneric", (width: auto, style: (resistor: "european")), inputs)
#let tgeneric(..inputs) = resistors("tgeneric", (width: auto, style: (resistor: "european")), inputs)
#let ageneric(..inputs) = resistors("ageneric", (width: auto, style: (resistor: "european")), inputs)
#let memristor(..inputs) = resistors("memristor", (width: auto, style: (resistor: "european")), inputs)
#let resistor(..inputs) = resistors("resistor", (width: auto), inputs)
#let vresistor(..inputs) = resistors("vresistor", (width: auto), inputs)
#let potentiometer(..inputs) = resistors("potentiometer", (width: auto), inputs)
#let resistivesens(..inputs) = resistors("resistivesens", (width: auto), inputs)
#let ldresistor(..inputs) = resistors("ldresistor", (width: auto), inputs)
#let varistor(..inputs) = resistors("varistor", (width: auto, style: (resistor: "european")), inputs)
#let mov(..inputs) = resistors("mov", (width: auto, style: (resistor: "european")), inputs)
#let photoresistor(..inputs) = resistors("photoresistor", (width: auto, style: (resistor: "european")), inputs)
#let thermistor(..inputs) = resistors("thermistor", (width: auto, style: (resistor: "european")), inputs)
#let thermistorptc(..inputs) = resistors("thermistorptc", (width: auto, style: (resistor: "european")), inputs)
#let thermistorntc(..inputs) = resistors("thermistorntc", (width: auto, style: (resistor: "european")), inputs)

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