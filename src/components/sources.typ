#import "/src/component.typ": component
#import "/src/components/arrows.typ": currarrow
#import "/src/dependencies.typ": cetz

#import cetz.draw: *

#let batteries(
  name,
  style,
  inputs,
) = component(
  ("batteries", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    let step-count = if name == "battery" {3} else {1}
    let step-width = style.width / step-count

    move-to((-x - step-width, y))
    for _ in range(0, calc.floor((step-count + 1)/2)) {
      line((rel:(step-width, -0.5*y)), (rel:(0, -y)), stroke: body-stroke.thickness * {if name in ("battery2", "solar") {3} else {1}})
      line((rel:(step-width, -0.5*y)), (rel:(0, 2*y)), stroke: body-stroke)
    }

    // Arrows
    if name == "solar" {
      line((1.8*x, 2*y), (-1.2*x, y), mark: style.mark, stroke: body-stroke)
      line((3.6*x, 1.8*y), (0.6*x, 0.8*y), mark: style.mark, stroke: body-stroke)
    }


  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.1,
      height: 0.6,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style,
  ),
  ..inputs
)

#let battery(..inputs) = batteries("battery", (width: 0.3), inputs)
#let battery1(..inputs) = batteries("battery1", (width: auto), inputs)
#let battery2(..inputs) = batteries("battery2", (width: auto), inputs)
#let solar(..inputs) = batteries("solar", (width: auto), inputs)

#let sources(
  name,
  style,
  inputs,
) = component(
  ("sources", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    let interupted-circle(angle) = {
      circle((0,0), radius: x, stroke: none, fill: style.fill) // To enable colouring of the circle
      arc((       - angle, x), radius: x, start:        - angle, delta: 2*angle, stroke: body-stroke)
      arc((180deg - angle, x), radius: x, start: 180deg - angle, delta: 2*angle, stroke: body-stroke)
    }

    let current-arrow() = {
      line((-0.7*x, 0), (0.7*x, 0), stroke: body-stroke)
      currarrow((0.5*x, 0))
    }

    if name in ("isourcesin", "dcisource") {
      interupted-circle(if name == "isourcesin" {style.isourcesin-angle} else {style.dcisource-angle})
    } else if name == "pvmodule" {
      rect((-x, -y), (x, y), stroke: body-stroke, fill: style.fill)
      line((x, y), (0.5*x, 0), (x, -y), stroke: body-stroke)
    } else if name in ("voosource", "ioosource") {
      let circle-offset = 0.35
      let circle-size = 0.65
      anchor("centerprim", (-circle-offset*x, 0))
      anchor("centersec", (circle-offset*x, 0))

      circle("centerprim", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
      circle("centersec", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
    } else if name == "oosourcetrans" {
      let circle-offset = 0.4
      let circle-size = 0.6
      anchor("centerprim", (-circle-offset*x, 0))
      anchor("centersec", (circle-offset*x, 0))
      anchor("symbolprim", (-circle-size*x, 0))
      anchor("symbolsec", (circle-size*x, 0))

      circle("centerprim", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
      circle("centersec", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
    } else if name == "ooosource"{
      let circle-offset = 0.45
      let circle-size = 0.55
      anchor("centerprim", (-circle-offset*x, 0))
      anchor("centersec", (60deg, circle-offset*x))
      anchor("centertert", (-60deg, circle-offset*x))
      anchor("symbolprim", (-0.6*x, 0))
      anchor("symbolsec", (60deg, 0.6*x))
      anchor("symboltert", (-60deg, 0.6*x))

      circle("centerprim", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
      circle("centersec", radius: circle-size*x, stroke: body-stroke, fill: style.fill)
      circle("centertert", radius: circle-size*x, stroke: body-stroke, fill: style.fill)

      // Connect right side
      anchor("right", ((circle-offset * calc.sin(30deg) + calc.sqrt(calc.pow(circle-size, 2) - calc.pow(circle-offset * calc.cos(30deg), 2))) * x, 0))
      line((x, 0), "right")
    } else if name == "nullator" {
      circle((0,0), radius: (x, y), stroke: body-stroke, fill: style.fill)
    } else if name == "norator" {
      let arc-center = x - y
      let angle = 45.5846914deg // messured in fusion 360
      merge-path({
        move-to((arc-center - calc.cos(angle) * y, calc.sin(angle) * y))
        arc((), start: 180deg-angle, stop: -180deg+angle, radius: y)
        line((), (-arc-center + calc.cos(angle) * y, calc.sin(angle) * y))
        arc((), start: angle, stop: 360deg-angle, radius: y)
      }, close: true, stroke: body-stroke, fill: style.fill)
    } else {
      circle((0,0), radius: x, stroke: body-stroke, fill: if name in ("vsourceN", "isourceN") {style.noise-fill-color} else {style.fill})
    }

    if name in ("vsource", "vsourceN") {
      if (style.style.voltage == "cute") or (name == "vsourceN") {
        body-stroke.thickness *= 3
        body-stroke.cap = "round"
        line((-0.6*x, 0), (0.6*x, 0), stroke: body-stroke)
      } else if style.style.voltage == "european" {
        line((-x, 0), (x, 0), stroke: body-stroke)
      } else if style.style.voltage == "american" {
        // Todo: Positioning of the + and - signs may need to be adjusted
        // Todo: Add the rotaion customisations for the + and - signs
        content((0.45*x,0), [$ + $], angle: 90deg)
        content((-0.45*x,0), [$ - $], angle: 90deg)
      }
    } else if name in ("isource", "isourceN") {
      if (style.style.current == "cute") or (name == "isourceN") {
        body-stroke.thickness *= 3
        body-stroke.cap = "round"
        line((0, -0.6*y), (0, 0.6*y), stroke: body-stroke)
      } else if style.style.current == "european" {
        line((0, -y), (0, y), stroke: body-stroke)
      } else if style.style.current == "american" {
        current-arrow()
      }
    } else if name in ("vsourcesin", "isourcesin") {
      let sin(start: (), amplitude, scale, interval: 2*calc.pi, samples: 100, angle: 0deg) = {
        rotate(angle, origin: start)
        line(..(for x in range(0, samples + 1) {
          let x = x / samples
          let p = interval * x
          ((rel:(x * scale, calc.sin(p) * amplitude), to: start),)
        }), fill: none, stroke: body-stroke)
        rotate(-angle, origin: start)
      }
      sin(start: (0, -0.5*y), 0.25*y, y, angle: 90deg)
    } else if name == "vsourcesquare" {
      line((0, -0.5*y), (-0.5*x, -0.5*y), (-0.5*x, 0), (0.5*x, 0), (0.5*x, 0.5*y), (0, 0.5*y), stroke: body-stroke)
    } else if name == "vsourcetri" {
      line((0, -0.5*y), (-0.375*x, -0.25*y), (0.375*x, 0.25*y), (0, 0.5*y), stroke: body-stroke)
    } else if name == "pvsource" {
      line((0.15*x, 0), (x, 0), stroke: body-stroke)
      line((-0.15*x, 0), (-x, 0), stroke: body-stroke)
      line((-0.15*x, 0.4*y), (-0.15*x, -0.4*y), stroke: body-stroke)
      line((0.15*x, 0.6*y), (0.15*x, -0.6*y), stroke:body-stroke)
      // Arrows
      line((rel: (-45deg, 2.2*y), to: (-0.3*x, 0)), (rel: (-45deg, 1.3*y), to: (-0.3*x, 0)), mark: style.mark, stroke: body-stroke)
      line((rel: (-45deg, 2.2*y), to: (0, 0.3*y)), (rel: (-45deg, 1.3*y), to: (0, 0.3*y)), mark: style.mark, stroke: body-stroke)
    } else if name == "dcvsource"{
      line((0.2*x, 0.5*y), (0.2*x, -0.5*y), stroke: body-stroke)
      line((-0.2*x, 0.5*y), (-0.2*x, -0.5*y), stroke: body-stroke)
    } else if name == "dcisource"{
      current-arrow()
    }

    if (name in ("vsourceN", "isourceN")) and (style.noise-dashed) {
      for angle in range(0, 8) {
        // Todo: Not even distributed
        line((45deg + 180deg/8 * angle, -y), (225deg - 180deg/8 * angle, y), stroke: style.stroke)
      }
    }

    if name in ("oosourcetrans", "ooosource") {
      // Winding Symbols
      let delta(pos, scale-factor: 1.0) = {
        group({
          scale(scale-factor * x)
          line((rel:(90deg, y), to: pos), (rel:(-30deg, y), to: pos), (rel:(-150deg, y), to: pos), close: true, stroke: body-stroke)
        })
      }

      let star(pos, scale-factor: 1.0) = {
        group({
          scale(scale-factor * x)
          line((rel: (0, -y), to: pos), pos, (rel: (-30deg, -y), to: pos), stroke: body-stroke)
          line(pos, (rel: (-150deg, -y), to: pos), stroke: body-stroke)
        })
      }

      let zigzag(pos, scale-factor: 1.0) = {
        group({
          scale(scale-factor * x)
          line(pos, (rel: (90deg, 0.5*y), to: pos), (rel: (60deg, y), to: pos), stroke: body-stroke)
          line(pos, (rel: (210deg, 0.5*y), to: pos), (rel: (180deg, y), to: pos), stroke: body-stroke)
          line(pos, (rel: (330deg, 0.5*y), to: pos), (rel: (-60deg, y), to: pos), stroke: body-stroke)
        })
      }

      if style.prim == "delta" {
        delta("symbolprim")
      } else if style.prim == "wye" {
        star("symbolprim")        
      } else if style.prim == "eyw" {
        group({
          rotate(180deg, origin: "symbolprim")
          star("symbolprim")
        })
      } else if style.prim == "zig" {
        zigzag("symbolprim")
      }

      if style.sec == "delta" {
        delta("symbolsec")
      } else if style.sec == "wye" {
        star("symbolsec")        
      } else if style.sec == "eyw" {
        group({
          rotate(180deg, origin: "symbolsec")
          star("symbolsec")
        })
      } else if style.sec == "zig" {
        zigzag("symbolsec")
      }

      if name == "ooosource" {
        if style.tert== "delta" {
          delta("symboltert")
        } else if style.tert == "wye" {
          star("symboltert")        
        } else if style.tert == "eyw" {
          group({
            rotate(180deg, origin: "symboltert")
            star("symboltert")
          })
        } else if style.tert == "zig" {
          zigzag("symboltert")
        }
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
      width: 0.6,
      height: 0.6,
      noise-fill-color: luma(50%),
      noise-dashed: false,
      mark: (end: "stealth", scale: 0.3, fill: black),  // Todo: Check size of the arrow head
    ),
    style,
  ),
  ..inputs
)

#let vsource(..inputs) = sources("vsource", (width: auto), inputs)
#let isource(..inputs) = sources("isource", (width: auto), inputs)
#let vsourcesin(..inputs) = sources("vsourcesin", (width: auto), inputs)
#let isourcesin(..inputs) = sources("isourcesin", (isourcesin-angle: 90deg), inputs)
#let vsourceN(..inputs) = sources("vsourceN", (width: auto), inputs)
#let isourceN(..inputs) = sources("isourceN", (width: auto), inputs)
#let vsourcesquare(..inputs) = sources("vsourcesquare", (width: auto), inputs)
#let vsourcetri(..inputs) = sources("vsourcetri", (width: auto), inputs)
#let esource(..inputs) = sources("esource", (width: auto), inputs)
#let pvsource(..inputs) = sources("pvsource", (width: auto), inputs)
#let pvmodule(..inputs) = sources("pvmodule", (width: 1.2), inputs)
#let voosource(..inputs) = sources("voosource", (height: 0.39), inputs)
#let ioosource(..inputs) = sources("ioosource", (height: 0.39), inputs)
#let oosourcetrans(..inputs) = sources("oosourcetrans", (height: 0.36, prim: none, sec: none), inputs)
#let ooosource(..inputs) = sources("ooosource", (height: 0.36, prim: none, sec: none, tert: none), inputs)
#let nullator(..inputs) = sources("nullator", (height: 0.3), inputs)
#let norator(..inputs) = sources("norator", (height: 0.25), inputs)
#let dcvsource(..inputs) = sources("dcvsource", (width: auto), inputs)
#let dcisource(..inputs) = sources("dcisource", (dcisource-angle: 80deg), inputs)

#let csources(
  name,
  style,
  inputs,
) = component(
  ("csources", name),
  style => {
    let x = style.width / 2
    let y = style.height / 2

    anchor("a", (-x, -y))
    anchor("b", (x, y))

    let body-stroke = style.stroke
    body-stroke.thickness *= style.thickness

    line((0, y), (x,0), (0,-y), (-x,0), close: true, stroke: body-stroke, fill: style.fill)

    if name == "cvsource" {
      if style.style.voltage == "european" {
        line((-x, 0), (x, 0), stroke: body-stroke)
      } else if style.style.voltage == "cute" {
        body-stroke.thickness *= 3
        body-stroke.cap = "round"
        line((-0.6*x, 0), (0.6*x, 0), stroke: body-stroke)
      } else if style.style.voltage == "american" {
        // Todo: Positioning of the + and - signs may need to be adjusted
        // Todo: Add the rotaion customisations for the + and - signs
        content((0.45*x,0), [$ + $], angle: 90deg)
        content((-0.45*x,0), [$ - $], angle: 90deg)
      }
    } else if name == "cisource" {
      if style.style.current == "european" {
        line((0, -y), (0, y), stroke: body-stroke)
      } else if style.style.current == "cute" {
        body-stroke.thickness *= 3
        body-stroke.cap = "round"
        line((0, -0.6*y), (0, 0.6*y), stroke: body-stroke)
      } else if style.style.current == "american" {
        line((-0.7*x, 0), (0.7*x, 0), stroke: body-stroke)
        currarrow((0.5*x, 0))
      }
    } else if name in ("cvsourcesin", "cisourcesin") {
      let sin(start: (), amplitude, scale, interval: 2*calc.pi, samples: 100, angle: 0deg) = {
        rotate(angle, origin: start)
        line(..(for x in range(0, samples + 1) {
          let x = x / samples
          let p = interval * x
          ((rel:(x * scale, calc.sin(p) * amplitude), to: start),)
        }), fill: none, stroke: body-stroke)
        rotate(-angle, origin: start)
      }
      sin(start: (0, -0.5*y), 0.25*y, y, angle: 90deg)
    }

  },
  (
    (
      style: auto,
      scale: auto,
      fill: auto,
      thickness: auto,
      stroke: auto,
      width: 0.7,
      height: 0.7,
    ),
    style,
  ),
  ..inputs
)

#let cvsource(..inputs) = csources("cvsource", (width: auto), inputs)
#let cisource(..inputs) = csources("cisource", (width: auto), inputs)
#let ecsource(..inputs) = csources("ecsource", (width: auto), inputs)
#let cvsourcesin(..inputs) = csources("cvsourcesin", (width: auto), inputs)
#let cisourcesin(..inputs) = csources("cisourcesin", (width: auto), inputs)