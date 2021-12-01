function find_inc(numbers::Array{Int, 1}, gap::Int)
    @views return sum(numbers[gap+1:end] .> numbers[1:end-gap])
end

open(ARGS[1]) do file
    numbers = parse.(Int, readlines(file))
    @info @time find_inc(numbers, 1)
    @info @time find_inc(numbers, 3)
end