function check_bingos(mask)
    lines = any(all(mask, dims = 2), dims = 1)
    cols = any(all(mask, dims = 1), dims = 2)

    return (lines.|cols)[1, 1, :]
end

score(cards, mask, number, idx) = number * sum(@. cards[:, :, idx] * !mask[:, :, idx])

open(ARGS[1]) do file
    called_numbers = parse.(Int, split(readline(file), ','))

    parsed_ints = parse.(Int, split(read(file, String)))
    n_boards = length(parsed_ints) ÷ 25
    cards = reshape(parsed_ints, 5, 5, n_boards)
    mask = falses(5, 5, n_boards)

    has_won = false
    bingos = falses(n_boards)

    for number in called_numbers
        @. mask |= cards == number
        prev_bingos = bingos
        bingos = check_bingos(mask)

        if !has_won
            idx = findfirst(bingos)
            if !isnothing(idx)
                has_won = true
                println(score(cards, mask, number, idx))
            end
        end

        if all(bingos)
            new_bingos = prev_bingos .⊻ bingos
            last = findfirst(new_bingos)
            println(score(cards, mask, number, last))
            break
        end
    end
end