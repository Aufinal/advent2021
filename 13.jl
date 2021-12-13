@time open(ARGS[1]) do file
    dots = Set{Tuple{Int,Int}}()
    for line in eachline(file)
        isempty(line) && break
        x, y = parse.(Int, split(line, ','))
        push!(dots, (x, y))
    end

    first = true
    for fold in eachline(file)
        type, value = split(fold, '=')
        value = parse(Int, value)
        if type[end] == 'x'
            for (x, y) in dots
                if x > value
                    delete!(dots, (x, y))
                    push!(dots, (2 * value - x, y))
                end
            end
        else
            for (x, y) in dots
                if y > value
                    delete!(dots, (x, y))
                    push!(dots, (x, 2 * value - y))
                end
            end
        end

        if first
            println(length(dots))
            first = false
        end
    end

    mx = 0
    my = 0
    for (x, y) in dots
        mx = max(mx, x)
        my = max(my, y)
    end


    drawing = falses(mx + 1, my + 1)
    for (x, y) in dots
        drawing[x+1, y+1] = true
    end

    for y = 1:my+1
        for x = 1:mx+1
            print(drawing[x, y] ? '\u2588' : ' ')
        end
        println()
    end
end