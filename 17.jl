function step(x, y, vx, vy)
    x += vx
    y += vy
    vx -= sign(vx)
    vy -= 1

    return x, y, vx, vy
end

function touches(vx, vy, xmin, xmax, ymin, ymax)
    x, y = 0, 0
    while x ≤ xmax && y ≥ ymin
        x, y, vx, vy = step(x, y, vx, vy)
        if xmin ≤ x ≤ xmax && ymin ≤ y ≤ ymax
            return true
        end
    end
    return false
end

function solve(xmin, xmax, ymin, ymax)
    res = 0
    for vx = isqrt(2xmin):xmax+1, vy = ymin-1:-ymin+1
        res += touches(vx, vy, xmin, xmax, ymin, ymax)
    end

    return res
end

@time res = solve(206, 250, -105, -57)
println(res)