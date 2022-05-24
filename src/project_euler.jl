module project_euler

export pe_1

function pe_1(from::T=1, to::T=999; timeout::UInt64=UInt64(5_000_000_000)) where T <: Integer
    println("Problem 1")
    println("Direct calculation:")
    @time result = pe_1_direct(from, to, timeout=timeout)
    println("Result = ", result)

    println("Sum of ranges:")
    @time result = pe_1_sum_ranges(from, to)
    println("Result = ", result)

    println("Analytical")
    @time result = pe_1_analytical(from, to)
    println("Result = ", result)
end

function pe_1_direct(from::T=1, to::T=999; timeout::UInt64=UInt64(5_000_000_000)) where T <: Integer
    startTime = time_ns()
    result = 0
    for x in from:to
        if (x % 3 == 0) || (x % 5 == 0)
            result += x
        end
        if (x & 0x100000 == 0) && (time_ns() - startTime > timeout)
            println("Time limit ($(timeout ÷ 1_000_000_000)s) exceeded")
            return 0
        end
    end
    result
end

function pe_1_sum_ranges(from=1, to=999)
    start3  = (from %  3 == 0) ? from : (from +  3 - from %  3)
    start5  = (from %  5 == 0) ? from : (from +  5 - from %  5)
    start15 = (from % 15 == 0) ? from : (from + 15 - from % 15)
    println("$start3 $start5 $start15")
    sum(start3 : 3 : to) + sum(start5 : 5 : to) - sum(start15 : 15 : to)
end

function pe_1_analytical(from=1, to=999)
    start3  = (from %  3 == 0) ? from : (from +  3 - from %  3)
    start5  = (from %  5 == 0) ? from : (from +  5 - from %  5)
    start15 = (from % 15 == 0) ? from : (from + 15 - from % 15)

    end3  = to - to %  3
    end5  = to - to %  5
    end15 = to - to % 15

    n3  = (end3  -  start3) ÷  3 + 1
    n5  = (end5  -  start5) ÷  5 + 1
    n15 = (end15 - start15) ÷ 15 + 1

    n3*(start3 + end3)÷2 + n5*(start5 + end5)÷2 - n15*(start15 + end15)÷2
end

end # module
