module Pe77

export pe_77

function generatePrimes!(primes = [], limit = 50000)
    (primes == [] || primes == [2]) && (primes = [2, 3, 5, 7, 11, 13, 17])

    for x ∈ last(primes)+2:2:limit
        is_prime = true
        for p ∈ primes
            # no need to check bigger divisors
            p^2 > x && break
            # not a prime
            (p^2 == x || x % p == 0) && (is_prime = false ; break)
        end
        is_prime && append!(primes, [x])
    end
    primes
end

function counterWays(target, leftPrimesList)
    (isempty(leftPrimesList)     || target < leftPrimesList[1]) && return 0
    (target == leftPrimesList[1] || target == 0)                && return 1

    return (counterWays(target - leftPrimesList[1], leftPrimesList) +
            counterWays(target,                     leftPrimesList[2:end]))
end

function pe_77(min_ways = 5000)
    primesList = generatePrimes!([], max(min_ways, 100))
    result = 0
    x = 9
    while result ≤ min_ways
        x += 1
        result = counterWays(x, primesList)
        println("$x ⇒ $result")
    end
    x
end

end
