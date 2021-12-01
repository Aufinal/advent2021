function find_inc(numbers, gap)
    return sum(numbers[i+gap] > numbers[i] for i in 1:length(numbers)-gap)
end

open(ARGS[1]) do file
    numbers = parse.(Int, readlines(file))
    println(find_inc(numbers, 1))
    println(find_inc(numbers, 3))
end