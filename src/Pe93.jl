module Pe93

using Combinatorics

export pe_93

function pe_93()
    max_seq_len, values = 0, (0, 0, 0, 0)
    operators = [(+),  (+),  (+),
                 (*),  (*),  (*),
                 (-),  (-),  (-),
                 (//), (//), (//)]
    for numbers ∈ combinations([1, 2, 3, 4, 5, 6, 7, 8, 9], 4)
        res = Set{Int}()
        for ops             ∈ combinations(operators, 3),
            (a, b, c, d)    ∈ permutations(numbers),
            (op1, op2, op3) ∈ permutations(ops)

            value1 = op1(a, op2(b, op3(c, d)))
            value2 = op1(op2(op3(a, b), c), d)
            value3 = op1(op2(a, b), op3(c, d))

            (value1 > 0 && denominator(value1) == 1) && push!(res, numerator(value1))
            (value2 > 0 && denominator(value2) == 1) && push!(res, numerator(value2))
            (value3 > 0 && denominator(value3) == 1) && push!(res, numerator(value3))

        end
        i = 1
        while i ∈ res
            i += 1
        end
        i -= 1
        if max_seq_len < i
            max_seq_len, values = i, numbers
            println("$i ⇐ $numbers")
        end
    end
    println("$(max_seq_len) ⇐ $values")
    max_seq_len, values
end

end
