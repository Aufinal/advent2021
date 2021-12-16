using DataStructures

function getcave(cave, (x, y))
    m, n = size(cave)
    (xd, xr) = divrem(x - 1, m)
    (yd, yr) = divrem(y - 1, n)

    orig = cave[xr+1, yr+1]
    return 1 + (orig + xd + yd - 1) % 9
end

function dijkstra(cave::Array{Int,2}, n_wraps::Int)
    m, n = n_wraps .* size(cave)
    distances = fill(-1, m, n)
    bigcave = [getcave(cave, (i, j)) for i = 1:m, j = 1:n]
    heap = BinaryMinHeap{Tuple{Int,Tuple{Int,Int}}}()

    distances[1, 1] = 0
    push!(heap, (0, (1, 1)))
    while true
        (dist, node) = pop!(heap)
        dist == distances[node...] || continue

        for direction in [(0, 1), (1, 0), (0, -1), (-1, 0)]
            neighbor = node .+ direction
            checkbounds(Bool, distances, neighbor...) || continue
            old_dist = distances[neighbor...]
            new_dist = dist + bigcave[neighbor...]
            neighbor == (m, n) && return new_dist

            if old_dist == -1 || old_dist > new_dist
                distances[neighbor...] = new_dist
                push!(heap, (new_dist, neighbor))
            end
        end
    end
end

open(ARGS[1]) do file
    cave = hcat([parse.(Int, collect(line)) for line in eachline(file)]...)
    println(dijkstra(cave, 1))
    @time println(dijkstra(cave, 5))
end