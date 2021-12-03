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

function rating(d_array, cmp, i)
    n = length(d_array)
    if n == 1
        return undigits(d_array[1], 2)
    end

    s = sum(x[i] for x in d_array)
    d = cmp(s, n/2)

    new_array = filter(x -> x[i] == d, d_array)
    return rating(new_array, cmp, i+1)
end


open(ARGS[1]) do file
    diagnostic_report = map(parse_line, readlines(file))

    majority = sum(diagnostic_report) .≥ length(diagnostic_report)/2
    gamma_rate = undigits(majority, 2)
    epsilon_rate = undigits(.!majority, 2)
    println(gamma_rate * epsilon_rate)


    o2_rating = rating(diagnostic_report, ≥, 1)
    co2_rating = rating(diagnostic_report, <, 1)
    println(o2_rating * co2_rating)
end