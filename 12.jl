function get_paths(node::String, neighbors::Dict{String,Array{String,1}}, visited::Dict{String,Bool}, twice::Bool)::Int
    node == "end" && return 1
    old = get(visited, node, false)
    visited[node] = true
    allowed_neighbors = filter(x -> all(isuppercase, x) || !get(visited, x, false), neighbors[node])
    res = mapreduce(new -> get_paths(new, neighbors, visited, twice), +, allowed_neighbors; init = 0)
    if twice
        twice_neighbors = filter(x -> all(islowercase, x) && x != "start" && get(visited, x, false), neighbors[node])
        res += mapreduce(new -> get_paths(new, neighbors, visited, false), +, twice_neighbors; init = 0)
    end
    visited[node] = old
    return res
end

open(ARGS[1]) do file
    neighbors = Dict{String,Array{String,1}}()
    for line in eachline(file)
        cave1, cave2 = split(line, '-')
        push!(get!(neighbors, cave1, []), cave2)
        push!(get!(neighbors, cave2, []), cave1)
    end

    visited = Dict{String,Bool}()
    println(get_paths("start", neighbors, visited, false))
    println(get_paths("start", neighbors, visited, true))
end