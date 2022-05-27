module project_euler

export pe_1, pe_2

function pe_1(from = 1, to = 999; timeout::UInt64 = UInt64(5_000_000_000))
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
    result
end

function pe_1_direct(from = 1, to = 999; timeout::UInt64 = UInt64(5_000_000_000))
    startTime = time_ns()
    result = 0
    for x ∈ from:to
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

function pe_1_sum_ranges(from = 1, to = 999)
    start3  = (from %  3 == 0) ? from : (from +  3 - from %  3)
    start5  = (from %  5 == 0) ? from : (from +  5 - from %  5)
    start15 = (from % 15 == 0) ? from : (from + 15 - from % 15)
    sum(start3 : 3 : to) + sum(start5 : 5 : to) - sum(start15 : 15 : to)
end

function pe_1_analytical(from = 1, to = 999)
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

function pe_2(to = 4_000_000)
    println("Problem 2")
    type = typeof(to)
    if type != BigInt && to > typemax(type) ÷ 3 # overflow possible
        types   = (Int8, Int16, Int32, Int64, Int128, BigInt)
        i = findfirst(t -> t == type, types)
        if i isa Nothing
            types = (UInt8, UInt16, UInt32, UInt64, UInt128, BigInt)
            i = findfirst(t -> t == type, types)
        end
        type = types[i + 1]
    end
    a, b = type(1), type(2)
    result = type(0)
    @time while a < to
        if !Bool(a & 1)
            result += a
        end
        a, b = b, a + b
    end
    println(result)
    result
end

function pe_3(number = 600851475143)
    divisor = typeof(number)(2)
    while (number & 1) == 0
        number ÷= 2
    end
    divisor += 1
    while divisor < number
        while (number % divisor) == 0
            number ÷= divisor
        end
        if number == 1
            return divisor
        end
        divisor += 2
    end
    return number
end

function pe_4(n_digits = 3)
    from, to = 10^(n_digits - 1), 10^n_digits - 1
    _x, _y, _product = (0, 0, 0)
    @time for x ∈ to:-1:from
        if x * to < _product
            break
        end

        for y ∈ to:-1:x
            x_y = x * y
            if x_y < _product
                @goto next_x
            end

            num = string(x_y)
            if num == reverse(num) && x_y > _product
                _x, _y, _product = x, y, x_y
            end
        end
        @label next_x
    end
    println("$_x ∘ $_y = $_product")
    _x, _y
end

end # module
