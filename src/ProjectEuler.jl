module ProjectEeuler

export pe_1, pe_2, pe_3, pe_4, pe_5, pe_6, pe_7, pe_8

"""
If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.
"""
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

"""
Each new term in the Fibonacci sequence is generated by adding the previous two terms. By starting with 1 and 2, the first 10 terms will be:

1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
"""
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

"""
The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?
"""
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

"""
A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.
"""
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

            # palindrome_test
            rev = 0
            num_bak = x_y
            while num_bak > 0
                num_bak, addition = divrem(num_bak, 10)
                rev = rev * 10 + addition
            end

            if rev == x_y && x_y > _product
                _x, _y, _product = x, y, x_y
            end
        end
        @label next_x
    end
    println("$_x ∘ $_y = $_product")
    _x, _y
end

"""
2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
"""
function pe_5(interval=1:20)
    type = eltype(interval)
    primes = [2 => 0]

    # fill dict with prime keys ≤ (x/2 + 1)
    for x ∈ 3:2:first(interval)÷2 + 1
        is_prime = true
        for (p, _) ∈ primes
            # no need to check bigger divisors
            p^2 > x && break
            # not a prime
            (p^2 == x || x % p == 0) && (is_prime = false ; break)
        end
        is_prime && append!(primes, [x => 0])
    end

    primes = Dict(primes)

    for x ∈ interval
        for (prime, count) ∈ primes
            counter = 0
            while x % prime == 0
                counter += 1
                x ÷= prime
            end

            counter > count && (primes[prime] = counter)
        end

        x != 1 && (primes[x] = 1)
    end
    result = big(1)
    for (base, power) in primes
        result *= base^power
    end

    (type == BigInt || result > typemax(type)) && return result
    return type(result)
end


"""
The sum of the squares of the first ten natural numbers is,

The square of the sum of the first ten natural numbers is,

Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is

1^2 + 2^2 + … + 10^2 = 385
(1 + 2 + … + 10)^2 = 55^2 = 3025

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
"""
function pe_6(n = 100)
    type = typeof(n)
    if type != BigInt && n ≥ typemax(type)^(1/5) # overflow possible
        types = (Int8, Int16, Int32, Int64, Int128, BigInt)
        i = findfirst(t -> t == type, types)
        if i isa Nothing
            types = (UInt8, UInt16, UInt32, UInt64, UInt128, BigInt)
            i = findfirst(t -> t == type, types)
        end
        type = types[i + 1]
    end
    n = type(n)
    (n*(n + 1) ÷ 2)^2 - n*(n + 1)*(2n + 1) ÷ 6
end

"""
By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10 001st prime number?
"""
function pe_7(n = 10_001)
    primes = [2]
    n_primes = 1
    x = 3

    while n_primes < n
        is_prime = true
        for p ∈ primes
            # no need to check bigger divisors
            p^2 > x && break
            # not a prime
            (p^2 == x || x % p == 0) && (is_prime = false ; break)
        end
        is_prime && (n_primes += 1; append!(primes, [x]))
        x += 2
    end

    last(primes)
end

"""
The four adjacent digits in the 1000-digit number that have the greatest product are 9 × 9 × 8 × 9 = 5832.

73167176531330624919225119674426574742355349194934
96983520312774506326239578318016984801869478851843
85861560789112949495459501737958331952853208805511
12540698747158523863050715693290963295227443043557
66896648950445244523161731856403098711121722383113
62229893423380308135336276614282806444486645238749
30358907296290491560440772390713810515859307960866
70172427121883998797908792274921901699720888093776
65727333001053367881220235421809751254540594752243
52584907711670556013604839586446706324415722155397
53697817977846174064955149290862569321978468622482
83972241375657056057490261407972968652414535100474
82166370484403199890008895243450658541227588666881
16427171479924442928230863465674813919123162824586
17866458359124566529476545682848912883142607690042
24219022671055626321111109370544217506941658960408
07198403850962455444362981230987879927244284909188
84580156166097919133875499200524063689912560717606
05886116467109405077541002256983155200055935729725
71636269561882670428252483600823257530420752963450

Find the thirteen adjacent digits in the 1000-digit number that have the greatest product. What is the value of this product?
"""
function pe_8(;custom_number = nothing, window_size = 13)
    default_number = """
        73167176531330624919225119674426574742355349194934
        96983520312774506326239578318016984801869478851843
        85861560789112949495459501737958331952853208805511
        12540698747158523863050715693290963295227443043557
        66896648950445244523161731856403098711121722383113
        62229893423380308135336276614282806444486645238749
        30358907296290491560440772390713810515859307960866
        70172427121883998797908792274921901699720888093776
        65727333001053367881220235421809751254540594752243
        52584907711670556013604839586446706324415722155397
        53697817977846174064955149290862569321978468622482
        83972241375657056057490261407972968652414535100474
        82166370484403199890008895243450658541227588666881
        16427171479924442928230863465674813919123162824586
        17866458359124566529476545682848912883142607690042
        24219022671055626321111109370544217506941658960408
        07198403850962455444362981230987879927244284909188
        84580156166097919133875499200524063689912560717606
        05886116467109405077541002256983155200055935729725
        71636269561882670428252483600823257530420752963450
        """
    num = replace(custom_number isa Nothing ? default_number : custom_number, r"\s*" => "")
    num = [parse(Int64, x) for x in num]
    max_prod = 0
    for i in 1:(length(num) - window_size + 1)
        p = prod(num[(i : i + window_size - 1)])
        max_prod = max(p, max_prod)
    end
    max_prod
end

end # module