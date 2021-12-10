opening = ['(', '[', '{', '<']
closing = [')', ']', '}', '>']
scores = Dict(closing .=> [3, 57, 1197, 25137])
matches = Dict(opening .=> closing)


open(ARGS[1]) do file
    errors = 0
    closes = Array{Int,1}()
    for line in eachline(file)
        chunks = Array{Char,1}()
        error = false
        for char in line
            if char ∈ opening
                push!(chunks, char)
            elseif (error = matches[pop!(chunks)] != char)
                errors += scores[char]
                break
            end
        end
        error && continue
        push!(closes, sum(5^(k - 1) * findfirst(isequal(c), opening) for (k, c) in enumerate(chunks)))
    end

    println(errors)
    println(sort(closes)[length(closes)÷2+1])
end