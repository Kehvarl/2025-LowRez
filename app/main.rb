require 'app/lowrez.rb'

def star_color(w)
  w = w.clamp(2, 64)

  if w < 28
    t = (30 - w) / 29.0
    g = 255
    b = (255 * t).clamp(0, 255).to_i
  elsif w > 36
    t = (63 - w) / 29.0
    g = (255 * t).clamp(0, 255).to_i
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
                       path: 'sprites/sun_sprite_64.png',
                       r: 255, g: 255, b: 0
                      }
    args.state.p1 = {x: 48, y: 48, w: 16, h: 16,
                     path: 'sprites/p1.png',
                     source_y: 0, source_x: 16, source_w: 16, source_h: 16,
                     fade_in: 30, a: 0
                    }
    args.state.p2 = {x: 48, y: 32, w: 16, h: 16,
                     path: 'sprites/p2.png',
                     source_y: 0, source_x: 16, source_w: 16, source_h: 16,
                     fade_in: 30, a: 0
                    }
    args.state.p3 = {x: 48, y: 16, w: 16, h: 16,
                     path: 'sprites/p3.png',
                     source_y: 0, source_x: 16, source_w: 16, source_h: 16,
                     fade_in: 30, a: 0
                    }
    args.state.gravity_countdown = 5
    args.state.game_over_countdown = 30
    args.state.score = 0
    args.state.show_planets = false
    args.state.show_countdown = 600
    args.state.game_state = :play
end

def calc_score args
  scale = ((args.state.star.w - 32).abs() / 30) ** 2
  score = (1 +(9)*scale).floor()
  if args.state.show_planets
    if args.state.p1.source_x == 16
      score += 5
    end
    if args.state.p2.source_x == 16
      score += 5
    end
    if args.state.p3.source_x == 16
      score += 5
    end
  end
  return score
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
      args.state.red = 128
      over_tick args
    end
end

def over_tick args
      args.state.game_over_countdown -=1
      args.lowrez.labels << { x: 0, y: 46, text: "GAME",
                    size_enum: LOWREZ_FONT_LG,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
      args.lowrez.labels << { x: 10, y: 32, text: "OVER",
                    size_enum: LOWREZ_FONT_LG,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
      args.lowrez.labels << { x: 0, y: 3, text: "Score: #{args.state.score}",
                    size_enum: LOWREZ_FONT_SM,
                    r: args.state.red, g: 0, b: 0, a: 255,
                    font: LOWREZ_FONT_PATH }
      if args.state.game_over_countdown <= 0 and
          (args.inputs.keyboard.space or args.inputs.mouse.button_left)
        init args
      end
end

def calc_planets args
  if args.state.p1.fade_in > 0
    args.state.p1.fade_in -=1
    args.state.p1.a = (32 - args.state.p1.fade_in) * 4
  end
  if args.state.p2.fade_in > 0
    args.state.p2.fade_in -=1
    args.state.p2.a = (32 - args.state.p2.fade_in) * 4
  end
  if args.state.p3.fade_in > 0
    args.state.p3.fade_in -=1
    args.state.p3.a = (32 - args.state.p3.fade_in) * 4
  end
  if args.state.star.w < 16
    args.state.p1.source_x = 32
    args.state.p2.source_x = 32
    args.state.p3.source_x = 32
  elsif args.state.star.w < 28
    args.state.p1.source_x = 16
    args.state.p2.source_x = 16
    args.state.p3.source_x = 32
  elsif args.state.star.w < 36
    args.state.p1.source_x = 0
    args.state.p2.source_x = 16
    args.state.p3.source_x = 32
  elsif args.state.star.w < 40
    args.state.p1.source_x = 0
    args.state.p2.source_x = 16
    args.state.p3.source_x = 16
  elsif args.state.star.w < 48
    args.state.p1.source_x = 0
    args.state.p2.source_x = 0
    args.state.p3.source_x = 16
  else
    args.state.p1.source_x = 0
    args.state.p2.source_x = 0
    args.state.p3.source_x = 0
  end

end

def play_tick args
    args.lowrez.background_color = [64, 64, 64]

    if args.inputs.keyboard.space or args.inputs.mouse.button_left
        args.state.star.w += 1
        args.state.star.h = args.state.star.w
    end

    if args.tick_count % 30 == 0
      args.state.score += calc_score(args)
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

    if not args.state.show_planets and args.state.star.w > 16 and args.state.star.w < 48
      args.state.show_countdown -=1
      if args.state.show_countdown <= 0
        args.state.show_planets = true
      end
    end

    args.lowrez.sprites << args.state.star

    if args.state.show_planets
      calc_planets args
      args.lowrez.sprites << args.state.p1
      args.lowrez.sprites << args.state.p2
      args.lowrez.sprites << args.state.p3
    end


    args.lowrez.labels << { x: 0, y: 3, text: "Score: #{args.state.score}",
                        size_enum: LOWREZ_FONT_SM,
                        r: 0, g: 0, b: 0, a: 255,
                        font: LOWREZ_FONT_PATH }
end


