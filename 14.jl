using DataStructures

function reduce(pairs::AbstractDict{Tuple{Char,Char},Int}, rules::Dict{Tuple{Char,Char},Char})
    new_pairs = DefaultDict{Tuple{Char,Char},Int}(0)
    for ((c1, c2), n) in pairs
        if haskey(rules, (c1, c2))
            c3 = rules[(c1, c2)]
            new_pairs[(c1, c3)] += n
            new_pairs[(c3, c2)] += n
        else
            new_pairs[(c1, c2)] += n
        end
    end

    return new_pairs
end

function count_chars(pairs, first, last)
    counts = DefaultDict{Char,Int}(0)
    for ((c1, c2), n) in pairs
        counts[c1] += n
        counts[c2] += n
    end

    for c in keys(counts)
        counts[c] += (c == first || c == last)
        counts[c] ÷= 2
    end

    (min, max) = extrema(values(counts))
    return max - min
end

open(ARGS[1]) do file
    polymer = readuntil(file, "\n\n")

    rules = Dict{Tuple{Char,Char},Char}()
    for line in eachline(file)
        rules[(line[1], line[2])] = line[end]
    end

    pairs = DefaultDict{Tuple{Char,Char},Int}(0)
    for i = 1:length(polymer)-1
        pairs[(polymer[i], polymer[i+1])] += 1
    end
    first, last = polymer[1], polymer[end]

    for _ = 1:40
        pairs = reduce(pairs, rules)
    end

    println(count_chars(pairs, first, last))
end