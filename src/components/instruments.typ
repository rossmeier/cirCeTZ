#import "/src/component.typ": component
#import "/src/components/arrows.typ": currarrow
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

// Todo: Add Rotation invariant Symbols/metering window

#let instruments(
  name,
  style,
  inputs,
) = component(
  ("instruments", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    // Square Instruments Y-Shift (0.2*y up)
    // For "qiprobe", "qvprobe", "qpprobe"
    let down = (0.4/0.6)*y
    let up = (0.8/0.6)*y

    // Body
    if name in ("rmeter", "rmeterwa") {
      circle((0,0), radius: y, stroke: body-stroke, fill: style.fill)
      // Label
      content((0,0), inputs.at("t", default: none)) // Todo: Check the size of the label
    } else if name in ("smeter", "oscope") {
      anchor("in-1", (-0.4*x, -0.75*y))
      anchor("in-2", (0.4*x, -0.75*y))
      rect((-x, -y), (x, y), radius: 0.25*x, stroke: body-stroke, fill: style.fill)
      // Label
      content((0,-0.5*y), inputs.at("t", default: none)) // Todo: Check the size of the label
    } else if name in ("qiprobe", "qvprobe", "qpprobe") {
      anchor("v+", (0.6*x, -down))
      anchor("v-", (-0.6*x, -down))
      // Todo: Fix Compass point anchors
      rect((-x, -down), (x, up), radius: 0.25*x, stroke: body-stroke, fill: style.fill)
    } else if name == "iloop" {
      anchor("i", (0, y))
      // loop with 17deg opening
      arc((0,0), start: 180deg - 8.5deg, stop: -(180deg - 8.5deg), radius: (0.4*x, 0.8*y), anchor: "origin", stroke: body-stroke)
      // internal wire
      line((-x, 0), (0.3*x, 0), stroke: style.stroke)
      line((0.5*x, 0), (x, 0), stroke: style.stroke)
      // Contact line up
      line((0, 0.8*y), (0, y), stroke: style.stroke)
    } else if name == "iloop2" {
      let plus =  (105deg, (0.4*x, 0.8*y))
      let minus = ( 75deg, (0.4*x, 0.8*y))
      anchor("i+", (plus, "|-", (0, y)))
      anchor("i-", (minus, "|-", (0, y)))
      // loop with 17deg opening to the left and 30deg opening to the top
      arc((0,0), start: 180deg - 8.5deg, stop: 90deg + 15deg, radius: (0.4*x, 0.8*y), anchor: "origin", stroke: body-stroke)
      arc((0,0), start: 90deg - 15deg, stop: -(180deg - 8.5deg), radius: (0.4*x, 0.8*y), anchor: "origin", stroke: body-stroke)
      // internal wire
      line((-x, 0), (0.3*x, 0), stroke: style.stroke)
      line((0.5*x, 0), (x, 0), stroke: style.stroke)
      // Contact line up
      line("i+", plus, stroke: style.stroke)
      line("i-", minus, stroke: style.stroke)
    } else if name == "currtap" {
      anchor("tap", (0, -style.dot-size*y))
      merge-path({
        line((-x, 0), (-0.95*x, 0))
        arc((), start: 180deg, stop: 0deg, radius: 0.95*x)
        line((), (x, 0))
      }, close: false, stroke: style.stroke)
      circle((0,0), radius: style.dot-size*y, stroke: style.stroke, fill: style.stroke.paint)
    }

    // Decorations
    if name == "rmeterwa" {
      let angle = calc.atan2(0.8*x, 1.2*y)
      line((-0.8*x, -1.2*y), (180deg + angle, 0.6*x), stroke: style.stroke)
      line((angle, 0.6*x), (0.8*x, 1.2*y), stroke: style.stroke, mark: style.mark)
    } else if name == "smeter" {
      // Metering window
      group({
        translate((0, -1.8*y))
        merge-path({
          arc((105deg, 2*y), start: 105deg, stop: 75deg, radius: 2*y)
          line((), (75deg, 2.5*y))
          arc((), start: 75deg, stop: 105deg, radius: 2.5*y)
        }, close: true, stroke: style.stroke)
        line((80deg, 2*y), (80deg, 2.4*y), stroke: style.stroke)
      })
    } else if name in ("qiprobe", "qvprobe", "qpprobe") {
      // Metering window
      group({
        translate((0, -1.7*up))
        merge-path({
          arc((103deg, 2.1*up), start: 103deg, stop: 77deg, radius: 2.1*up)
          line((), (77deg, 2.5*up))
          arc((), start: 77deg, stop: 103deg, radius: 2.5*up)
        }, close: true, stroke: style.stroke)
        line((83deg, 2.1*up), (83deg, 2.4*up), stroke: style.stroke)
      })

      //Todo: Check size of the circle
      let circ-radius = 0.04

      if name == "qiprobe" {
        line((-x, 0), (x, 0), stroke: style.stroke)
        currarrow((0,0))
      } else if name == "qvprobe" {
        line((-x, 0), (-0.6*x, 0), stroke: style.stroke)
        circle((rel:(circ-radius,0)), radius: circ-radius)
        line((x, 0), (0.6*x, 0), stroke: style.stroke)
        circle((rel:(-circ-radius,0)), radius: circ-radius)

        // Plus and Minus signs
        let sign-stroke = style.stroke
        sign-stroke.thickness *= 2
        line((-0.6*x + circ-radius, -1.5*circ-radius), (-0.6*x + circ-radius, -3.5*circ-radius), stroke: sign-stroke)
        line((-0.6*x, -2.5*circ-radius), (-0.6*x + 2*circ-radius, -2.5*circ-radius), stroke: sign-stroke)

        line((0.6*x, -2.5*circ-radius), (0.6*x - 2*circ-radius, -2.5*circ-radius), stroke: sign-stroke)
      } else if name == "qpprobe" {
        line((-x, 0), (x, 0), stroke: style.stroke)
        currarrow((0,0))

        circle((-0.6*x, -3*circ-radius), radius: circ-radius)
        line((-0.6*x, -4*circ-radius), (-0.6*x, -down), stroke: style.stroke)
        circle((0.6*x, -3*circ-radius), radius: circ-radius)
        line((0.6*x, -4*circ-radius), (0.6*x, -down), stroke: style.stroke)

        // Plus and Minus signs
        let sign-stroke = style.stroke
        sign-stroke.thickness *= 2
        line((-0.6*x + 3*circ-radius, -2*circ-radius), (-0.6*x + 3*circ-radius, -4*circ-radius), stroke: sign-stroke)
        line((-0.6*x + 2*circ-radius, -3*circ-radius), (-0.6*x + 4*circ-radius, -3*circ-radius), stroke: sign-stroke)

        line((0.6*x - 4*circ-radius, -3*circ-radius), (0.6*x - 2*circ-radius, -3*circ-radius), stroke: sign-stroke)

      }
    } else if name == "oscope" {
      let grid-stroke = style.stroke
      grid-stroke.thickness *= 0.5
      grid-stroke.paint = rgb(0,0,0,50%)
      grid((-0.75*x, -0.5*y), (0.75*x, 0.5*y),
        step: 0.995*0.25*x, //the "almost one" make the grid complete most of the time --- beware of antialiasing
        stroke: grid-stroke)

      let ramps = {
        line((-0.75cm, -0.25cm), (-0.05cm, 0.25cm), (-0.05cm, -0.25cm), (0.65cm, 0.25cm), (0.65cm, -0.25cm), stroke: body-stroke)
      }

      let sin = {
        // Todo: Move this function to a central place mutliple copies are used at the moment
        let sin(start: (), amplitude, scale, interval: 2*calc.pi, samples: 100, angle: 0deg) = {
          rotate(angle, origin: start)
          line(..(for x in range(0, samples + 1) {
            let x = x / samples
            let p = interval * x
            ((rel:(x * scale, calc.sin(p) * amplitude), to: start),)
          }), fill: none, stroke: body-stroke)
          rotate(-angle, origin: start)
        }
        sin(start: (-0.6cm, 0cm), 0.3cm, 1.2cm)
      }

      let square = {
        line((-0.75cm, -0.25cm), (-0.6cm, -0.25cm), (-0.6cm, 0.25cm), (0cm, 0.25cm), (0cm, -0.25cm), (0.6cm, -0.25cm), (0.6cm, 0.25cm), (0.75cm, 0.25cm), stroke: body-stroke)
      }

      let triangle = {
        line((-0.75cm, 0cm), (-0.6cm, -0.25cm), (-0.3cm, 0.25cm), (0cm, -0.25cm), (0.3cm, 0.25cm), (0.6cm, -0.25cm), (0.75cm, 0cm), stroke: body-stroke)
      }

      let lissajous = {
        // Should be a ellipse with the center (0,0) and the major and minor axis-vector of (0.5cm, 0.35cm) and (-0.3cm, 0.2cm) not yet implemented in CeTZ
        rotate(35deg)
        circle((0cm, 0cm), radius: (0.61cm, 0.34cm), stroke: body-stroke)
      }

      let zero = {
        line((-0.75cm, 0cm), (0.75cm, 0cm), stroke: body-stroke)
      }

      group({
        // Scale the function to the size of the oscilloscope
        // Range of the function is from -0.75 to 0.75 for x and -0.5 to 0.5 for y
        scale(x)
        if type(style.waveform) == "string" {
          if style.waveform == "ramps" { ramps }
          else if style.waveform == "sin" { sin }
          else if style.waveform == "square" { square }
          else if style.waveform == "triangle" { triangle }
          else if style.waveform == "lissajous" { lissajous }
          else if style.waveform == "zero" { zero }
        } else {
          style.waveform
        }
      })
    }
  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.6,
      height: 0.6,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style,
  ),
  ..inputs
)

#let rmeter(..inputs) = instruments("rmeter", (width: auto), inputs)
#let rmeterwa(..inputs) = instruments("rmeterwa", (width: auto), inputs)
#let smeter(..inputs) = instruments("smeter", (width: auto), inputs)
#let qiprobe(..inputs) = instruments("qiprobe", (width: auto), inputs)
#let qvprobe(..inputs) = instruments("qvprobe", (width: auto), inputs)
#let qpprobe(..inputs) = instruments("qpprobe", (width: auto), inputs)
#let oscope(..inputs) = instruments("oscope", (waveform: "ramps"), inputs)
#let iloop(..inputs) = instruments("iloop", (width: 0.4), inputs)
#let iloop2(..inputs) = instruments("iloop2", (width: 0.4), inputs)
#let currtap(..inputs) = instruments("currtap", (width: 0.4, height: 0.4, dot-size: 0.5), inputs)