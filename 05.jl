function parse_line(line)
    a, b = split(line, " -> ")
    return parse.(Int, [split(a, ',')..., split(b, ',')...])
end

function line(x1, y1, x2, y2, part2 = false)
    stepx = sign(x2 - x1)
    stepy = sign(y2 - y1)
    if !part2 && x1 == x2
        return [(x1, y) for y = y1:stepy:y2]
    elseif !part2 && y1 == y2
        return [(x, y1) for x = x1:stepx:x2]
    elseif part2 && abs(x2 - x1) == abs(y2 - y1)
        return zip(x1:stepx:x2, y1:stepy:y2)
    else
        return []
    end
end

open(ARGS[1]) do file
    vents = parse_line.(readlines(file))
    board = zeros(Int, 1000, 1000, 2)
    count1 = 0
    count2 = 0

    @time for vent in vents
        l1 = line(vent...)
        l2 = line(vent..., true)
        for (x, y) in l1
            board[x, y, 1] += 1
            count1 += board[x, y, 1] == 2
            board[x, y, 2] += 1
            count2 += board[x, y, 2] == 2
        end
        for (x, y) in l2
            board[x, y, 2] += 1
            count2 += board[x, y, 2] == 2
        end
    end

    println("$count1 $count2")

end