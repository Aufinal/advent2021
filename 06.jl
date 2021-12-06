function simulate!(population)
    buffer = population[1]
    for i = 1:8
        population[i] = population[i%9+1]
    end
    population[7] += buffer
    population[9] = buffer
end

open(ARGS[1]) do file
    ints = parse.(Int, split(readline(file), ','))
    population = zeros(Int, 9)
    for i in ints
        population[i+1] += 1
    end
    @time begin
        for _ = 1:80
            simulate!(population)
        end
        println(sum(population))

        for _ = 81:256
            simulate!(population)
        end
        println(sum(population))
    end
end