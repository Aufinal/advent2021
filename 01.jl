function find_inc(numbers, gap)
    return sum(numbers[gap+1:end] .> numbers[1:end-gap])
end

open(ARGS[1]) do file
    numbers = parse.(Int, readlines(file))
    println(find_inc(numbers, 1))
    println(find_inc(numbers, 3))
end