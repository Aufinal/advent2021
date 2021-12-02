function parse_line(line)
    directions = Dict("forward" => 1, "up" => -im, "down" => im,)
    dir, n = split(line)
    return directions[dir] *  parse(Int, n)
end

open(ARGS[1]) do file
    pos1 = 0
    pos2 = 0
    for dir in map(parse_line, eachline(file))
        pos1 += dir
        pos2 += real(dir) * (1 + imag(pos1) * im)
    end

    println(real(pos1) * imag(pos1))
    println(real(pos2) * imag(pos2))
end