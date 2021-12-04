function check_bingos(marked)
    lines = any(all(marked, dims = 2), dims = 1)
    cols = any(all(marked, dims = 1), dims = 2)

    return (lines.|cols)[1, 1, :]
end

score(cards, marked, number, idx) = number * sum(cards[:, :, idx][.!marked[:, :, idx]])

open(ARGS[1]) do file
    draws = parse.(Int, split(readline(file), ','))
    parsed_ints = parse.(Int, split(read(file, String)))
    cards = reshape(parsed_ints, 5, 5, :)
    marked = falses(size(cards))
    has_won = false
    bingos = falses(size(cards, 3))

    for number in draws
        @. marked |= cards == number
        prev_bingos = bingos
        bingos = check_bingos(marked)

        if !has_won
            idx = findfirst(bingos)
            if !isnothing(idx)
                has_won = true
                println(score(cards, marked, number, idx))
            end
        end

        if all(bingos)
            new_bingos = prev_bingos .⊻ bingos
            last = findfirst(new_bingos)
            println(score(cards, marked, number, last))
            break
        end
    end
end