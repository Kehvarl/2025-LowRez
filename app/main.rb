require 'app/lowrez.rb'

def tick args
    # How to set the background color
    args.lowrez.background_color = [64, 64, 64]

    args.lowrez.solids  << { x: 0, y: 64, w: 10, h: 10, r: 255 }

    args.lowrez.labels  << {
    x: 32,
    y: 63,
    text: "lowrezjam 2025",
    size_enum: LOWREZ_FONT_SM,
    alignment_enum: 1,
    r: 0,
    g: 0,
    b: 0,
    a: 255,
    font: LOWREZ_FONT_PATH
    }

    args.lowrez.sprites << {
    x: 32 - 10,
    y: 32 - 10,
    w: 20,
    h: 20,
    path: 'sprites/lowrez-ship-blue.png',
    a: Kernel.tick_count % 255,
    angle: Kernel.tick_count % 360
    }

    args.lowrez.lines << { x: 0, y: 0, x2: 63, y2:  0, r: 255 }
end


