using Statistics

open(ARGS[1]) do file
    crabs = parse.(Int, split(readline(file), ','))
    m = trunc(Int, median(crabs))
    println(sum(@. abs(crabs - m)))

    m2 = trunc(Int, mean(crabs))
    println(minimum(sum(@. abs(crabs - x) * (abs(crabs - x) + 1) ÷ 2) for x = m2-1:m2+1))
end