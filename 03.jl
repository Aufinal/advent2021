function parse_line(line)
    return parse.(Int, split(line, ""))
end

function undigits(d, base)
    s = 0
    mult = 1
    for val in reverse(d)
        s += val * mult
        mult *= base
    end

    return s
end

function rating(d_array, cmp, mask, mask_size, i)
    if mask_size == 1
        idx = findfirst(isequal(1), mask)
        return undigits(d_array[idx], 2)
    end

    d_sum = sum(m * x[i] for (x, m) in zip(d_array, mask))
    d = cmp(d_sum, mask_size / 2)

    mask = mask .& (getindex.(d_array, i) .== d)
    mask_size = cmp(d_sum, mask_size - d_sum) ? d_sum : mask_size - d_sum
    return rating(d_array, cmp, mask, mask_size, i + 1)
end


open(ARGS[1]) do file
    diagnostic_report = map(parse_line, readlines(file))
    n_lines = length(diagnostic_report)

    majority = sum(diagnostic_report) .≥ n_lines / 2
    gamma_rate = undigits(majority, 2)
    epsilon_rate = undigits(.!majority, 2)
    println(gamma_rate * epsilon_rate)


    o2_rating = rating(diagnostic_report, ≥, trues(n_lines), n_lines, 1)
    co2_rating = rating(diagnostic_report, <, trues(n_lines), n_lines, 1)
    println(o2_rating * co2_rating)
end