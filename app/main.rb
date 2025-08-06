require 'app/lowrez.rb'

def init args
    args.state.star = {
        x: 32,
        y: 32,
        w: 20,
        h: 20,
        anchor_x: 0.5,
        anchor_y: 0.5,
        path: 'sprites/circle/yellow.png'
        }

end

def tick args
    if args.tick_count == 0
        init args
    end
    args.lowrez.background_color = [64, 64, 64]

    if args.inputs.keyboard.space
        args.state.star.w += 1
        args.state.star.h += 1
    end

    args.state.star.w -= 0.5
    args.state.star.h -= 0.5

    #a: Kernel.tick_count % 255,
    #angle: Kernel.tick_count % 360

    args.lowrez.sprites << args.state.star
end


