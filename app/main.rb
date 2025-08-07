require 'app/lowrez.rb'

def star_color(w)
  w = w.clamp(8, 64)

  if w < 26
    t = (26 - w) / 18.0
    g = 255 - (100 * t)
    b = 100 + (155 * t)
  elsif w > 26
    t = (w - 26) / 38.0
    g = 255 - (255 * t)
    b = 0
  else
    g = 255
    b = 0
  end
  return {g: g, b: b}
end

def init args
    args.state.star = {x: 32, y: 32, w: 20, h: 20,
                       anchor_x: 0.5, anchor_y: 0.5,
                       path: 'sprites/circle/white.png',
                       r: 255, g: 255, b: 0
                      }
    args.state.gravity_countdown = 10
end

def tick args
    if args.tick_count == 0
        init args
    end
    args.lowrez.background_color = [64, 64, 64]

    if args.inputs.keyboard.space
        args.state.star.w += 0.1
        args.state.star.h += 0.1
    end

    args.state.gravity_countdown -= 1
    if args.state.gravity_countdown <= 0
        args.state.gravity_countdown = 10

        args.state.star.w -= 0.5
        args.state.star.h = args.state.star.w

        c = star_color(args.state.star.w)
        args.state.star.g = c.g
        args.state.star.b = c.b
    end

    #a: Kernel.tick_count % 255,
    #angle: Kernel.tick_count % 360

    args.lowrez.sprites << args.state.star
end


