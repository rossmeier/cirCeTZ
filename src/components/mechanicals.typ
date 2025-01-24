#import "/src/component.typ": component
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let mechanicals(
  name,
  style,
  inputs,
) = component(
  ("mechanicals", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    if name == "damper" {
      let length = 0.3
      // rect for filling
      rect((length*x, -y), (x, y), stroke: none, fill: style.fill)

      // connecting line
      line((-x, 0), (length*x, 0), stroke: style.stroke)

      // body
      line((-x, -y), (x, -y), (x, y), (-x, y), stroke: body-stroke)
      line((length*x, -0.8*y), (length*x, 0.8*y), stroke: body-stroke)  
    } else if name == "inerter" {
      rect((-x, -y), (x, y), stroke: body-stroke, fill: style.fill)
    } else if name == "spring" {
      let steps = 4
      let line-width = body-stroke.thickness.cm()*0.7 // Check why the factor of 0.7 is needed
      let step = (2*x + line-width) / (4*steps)
      let sgn = -1
      let spring-angle = calc.atan2(step, y)
      let spring-length = (y / calc.sin(spring-angle)) - 0.5 * y
      let winding-width = calc.cos(spring-angle) * spring-length
      let winding-height = calc.sin(spring-angle) * spring-length
      merge-path({
        move-to((-x - line-width/2, 0))
        let winding-x = -x - line-width/2 + step
        let winding-y = winding-height
        let sgn = 1
        for _ in range(steps*2) {
          line((), (winding-x - winding-width, sgn * winding-y))
          bezier((), (winding-x + winding-width, sgn * winding-y), (winding-x, sgn * y))
          winding-x += 2*step
          sgn *= -1
        }
        line((), (x + line-width/2, 0))
      }, stroke: body-stroke)
    } else if name == "viscoe" {
      let length = 0.3
      // rect for filling
      rect((length*x, -y), (x, y), stroke: none, fill: style.fill)

      // Spring
      let steps = 3
      let line-width = body-stroke.thickness.cm()*0.7 // Check why the factor of 0.7 is needed
      let step = (2*x - (1-length)*x + line-width/2) / (4*steps)
      let sgn = -1
      let spring-angle = calc.atan2(step, 0.75*y)
      let spring-length = (0.75*y / calc.sin(spring-angle)) - 0.25 * y
      let winding-width = calc.cos(spring-angle) * spring-length
      let winding-height = calc.sin(spring-angle) * spring-length
      merge-path({
        move-to((-x - line-width/2, 0))
        let winding-x = -x - line-width/2 + step
        let winding-y = winding-height
        let sgn = 1
        for _ in range(steps*2) {
          line((), (winding-x - winding-width, sgn * winding-y))
          bezier((), (winding-x + winding-width, sgn * winding-y), (winding-x, sgn * 0.75 * y))
          winding-x += 2*step
          sgn *= -1
        }
        line((), (x - (1-length)*x, 0))
      }, stroke: body-stroke)

      // body
      line((-x, -y), (x, -y), (x, y), (-x, y), stroke: body-stroke)
      line((length*x, -0.8*y), (length*x, 0.8*y), stroke: body-stroke)
    } else if name == "mass" {
      let box-ratio = 40/55
      rect((-x, -box-ratio*y), (rel:(2*box-ratio*y, 2*box-ratio*y)), stroke: body-stroke, fill: style.fill)
      body-stroke.cap = "square"
      line((-x, y), (x, y), (x, -box-ratio*y), stroke: body-stroke)
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
    ),
    style,
  ),
  ..inputs
)

#let damper(..inputs) = mechanicals("damper", (width: 0.4, height: 0.35), inputs)
#let inerter(..inputs) = mechanicals("inerter", (width: 0.175, height: 0.7), inputs)
#let spring(..inputs) = mechanicals("spring", (width: 0.5, height: 0.5), inputs)
#let viscoe(..inputs) = mechanicals("viscoe", (width: 0.4, height: 0.35), inputs)
#let mass(..inputs) = mechanicals("mass", (width: 0.5, height: 0.55), inputs)