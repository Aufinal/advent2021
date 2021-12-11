open(ARGS[1]) do file
    octopi = hcat([[parse(Int, char) for char in line] for line in eachline(file)]...)
    m, n = size(octopi)
    has_flashed = falses(m, n)
    step = 0
    n_flashes = 0

    while !all(has_flashed)
        step += 1
        has_flashed = falses(m, n)
        flashes = Array{Tuple{Int,Int},1}()
        for x = 1:m, y = 1:n
            octopi[x, y] += 1
            if octopi[x, y] == 10
                push!(flashes, (x, y))
            end
        end

        while !isempty(flashes)
            x, y = pop!(flashes)
            has_flashed[x, y] && continue
            n_flashes += 1
            has_flashed[x, y] = true
            for i = -1:1, j = -1:1
                checkbounds(Bool, octopi, x + i, y + j) || continue
                octopi[x+i, y+j] += 1
                if octopi[x+i, y+j] == 10
                    push!(flashes, (x + i, y + j))
                end
            end
        end

        octopi[has_flashed] .= 0
        step == 100 && println(n_flashes)
    end

    println(step)
end