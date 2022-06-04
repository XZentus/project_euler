module Pe93

export pe_93

function pe_93(numbers_limit = 9)
    max_seq_len, values = 0, (0, 0, 0, 0)
    operators = [(+),  (-),  (*), (//)]
    for n1 ∈ 1:9,
        n2 ∈ (n1 + 1):numbers_limit,
        n3 ∈ (n2 + 1):numbers_limit,
        n4 ∈ (n3 + 1):numbers_limit

        res = Set{Int}()
        ns = [n1, n2, n3, n4]
        for op1 ∈ operators,
            op2 ∈ operators,
            op3 ∈ operators,
            a ∈ ns, b ∈ ns, c ∈ ns, d ∈ ns
            (a == b || a == c || a == d ||
             b == c || b == d ||
             c == d) && continue

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
            max_seq_len, values = i, [n1 n2 n3 n4]
            println("$i ⇐ $values")
        end
    end
    println("$(max_seq_len) ⇐ $values")
    max_seq_len, values
end

end
