function parse_line(line)
    input_str, output_str = split(line, " | ")
    return split(input_str), split(output_str)
end

digits = [
    [1, 2, 3, 5, 6, 7],
    [3, 6],
    [1, 3, 4, 5, 7],
    [1, 3, 4, 6, 7],
    [2, 3, 4, 6],
    [1, 2, 4, 6, 7],
    [1, 2, 4, 5, 6, 7],
    [1, 3, 6],
    [1, 2, 3, 4, 5, 6, 7],
    [1, 2, 3, 4, 6, 7]
]

function find_encoding(inputs)
    sort!(inputs, by = length)
    one = collect(inputs[1])
    four = collect(inputs[3])
    seven = collect(inputs[2])
    eight = collect(inputs[10])

    segments = repeat(['X'], 7)
    segments[1] = setdiff(seven, one)[1]
    for i = 7:9
        digit = collect(inputs[i])
        diff = setdiff(eight, digit)[1]
        if diff ∈ one
            segments[3] = diff
        elseif diff ∈ four
            segments[4] = diff
        else
            segments[5] = diff
        end
    end
    segments[6] = setdiff(one, [segments[3]])[1]
    segments[2] = setdiff(four, one, [segments[4]])[1]
    segments[7] = setdiff(eight, segments[1:6])[1]

    return Dict(sort(segments[d]) => i - 1 for (i, d) in enumerate(digits))
end

open(ARGS[1]) do file
    patterns = parse_line.(readlines(file))
    part_1 = 0
    part_2 = 0
    for (inputs, outputs) in patterns
        encoding = find_encoding(inputs)
        decoded = [encoding[sort(collect(x))] for x in outputs]

        part_1 += count(∈([1, 4, 7, 8]), decoded)
        part_2 += sum(10^(4 - i) * k for (i, k) in enumerate(decoded))
    end

    println(part_1)
    println(part_2)
end