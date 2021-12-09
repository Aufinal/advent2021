using DataStructures
directions = [(1, 0), (0, 1), (-1, 0), (0, -1)]

is_min(board, x, y) = all(board[x+δx, y+δy] > board[x, y] for (δx, δy) in directions if checkbounds(Bool, board, x + δx, y + δy))

open(ARGS[1]) do file
    str = read(file, String)
    n_lines = countlines(IOBuffer(str))
    board = [parse(Int, c) for c in str if c != '\n']
    board = reshape(board, (:, n_lines))
    m, n = size(board)
    root = fill((0, 0), m, n)
    part_1 = 0
    visited = falses(m, n)
    cluster_size = Dict{Tuple{Int,Int},Int}()

    for i = 1:m, j = 1:n

        if board[i, j] == 9 || visited[i, j] || !is_min(board, i, j)
            continue
        end
        part_1 += 1 + board[i, j]

        s = Stack{Tuple{Int,Int}}()
        push!(s, (i, j))

        while !isempty(s)
            (x, y) = pop!(s)
            visited[x, y] && continue

            visited[x, y] = true
            root[x, y] = (i, j)
            cluster_size[(i, j)] = get(cluster_size, (i, j), 0) + 1
            for (δx, δy) in directions
                if checkbounds(Bool, board, x + δx, y + δy) && board[x+δx, y+δy] != 9
                    push!(s, (x + δx, y + δy))
                end
            end
        end
    end

    println(part_1)
    sizes = sort(collect(values(cluster_size)))
    println(prod(sizes[end-2:end]))

end