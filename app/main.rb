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
    args.state.gravity_countdown = 5
    args.state.score = 0
    args.state.game_state = :play
end

def calc_score r
  scale = ((r - 32).abs() / 30) ** 2
  return (1 +(9)*scale).floor()
end

def tick args
    if args.tick_count == 0
        init args
    end

    if args.state.game_state == :play
      play_tick args
    elsif args.state.game_state == :explode
      args.lowrez.background_color = [255, 255, 255]
      args.state.red = 0
      over_tick args
    elsif args.state.game_state == :collapse
      args.lowrez.background_color = [0,0,0]
      args.state.red = 80
      over_tick args
    end
end

def over_tick args
      args.lowrez.labels << { x: 0, y: 46, text: "GAME",
                    size_enum: LOWREZ_FONT_LG,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
      args.lowrez.labels << { x: 12, y: 32, text: "OVER",
                    size_enum: LOWREZ_FONT_LG,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
      args.lowrez.labels << { x: 0, y: 8, text: "Score: #{args.state.score}",
                    size_enum: LOWREZ_FONT_MD,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
end

def play_tick args
    args.lowrez.background_color = [64, 64, 64]

    if args.inputs.keyboard.space or args.inputs.mouse.button_left
        args.state.star.w += 1
        args.state.star.h = args.state.star.w
    end

    if args.tick_count % 30 == 0
      args.state.score += calc_score(args.state.star.w)
    end

    args.state.gravity_countdown -= 1
    if args.state.gravity_countdown <= 0
        args.state.gravity_countdown = 5

        args.state.star.w -= 2
        args.state.star.h = args.state.star.w

        c = star_color(args.state.star.w)
        args.state.star.g = c.g
        args.state.star.b = c.b
    end

    if args.state.star.w <= 4
      args.state.game_state = :collapse
    elsif args.state.star.w >= 63
      args.state.game_state = :explode
    end

    args.lowrez.sprites << args.state.star

    args.lowrez.labels << { x: 0, y: 3, text: "Score: #{args.state.score}",
                        size_enum: LOWREZ_FONT_SM,
                        r: 0, g: 0, b: 0, a: 255,
                        font: LOWREZ_FONT_PATH }
end


