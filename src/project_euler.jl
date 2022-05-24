module project_euler

export pe1

function pe_1(from = 1, to = 999)
    println("Problem 1")
    println("Direct calculation:")
    @time res1 = pe_1_direct(from, to)
    println("Result = ", res1)

    println("Sum of ranges:")
    @time res1 = pe_1_sum_ranges(from, to)
    println("Result = ", res1)
end

function pe_1_direct(from = 1, to = 999)
    result = 0
    for x in from:to
        if x % 3 == 0 || x % 5 == 0
            result += x
        end
    end
    result
end

function pe_1_sum_ranges(from = 1, to = 999)
    start3  = (from %  3 == 0) ? from : (from +  3 - from %  3)
    start5  = (from %  5 == 0) ? from : (from +  5 - from %  5)
    start15 = (from % 15 == 0) ? from : (from + 15 - from % 15)
    sum(start3 : 3 : to) + sum(start5 : 5 : to) - sum(start15 : 15 : to)
end

end # module
