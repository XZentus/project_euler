module Pe169

export pe_169, pe_169_bruteforce

"""
Define f(0)=1 and f(n) to be the number of different ways n can be expressed as a sum of integer powers of 2 using each power no more than twice.

For example, f(10)=5 since there are five different ways to express 10:

1 + 1 + 8
1 + 1 + 4 + 4
1 + 1 + 2 + 2 + 4
2 + 4 + 4
2 + 8

What is f(10^25)?
"""
function pe_169_bruteforce(n::Signed)
    f_bruteforce(n, 1 |> typeof(n))
end

function f_bruteforce(n::T, x::T) where T <: Signed
    n == 0 && return 1
    n < x  && return 0

    return  ( f_bruteforce(n,      2x)
            + f_bruteforce(n -  x, 2x)
            + f_bruteforce(n - 2x, 2x))
end

function pe_169(n::Integer = big"10"^25)
    n < 2 && return n

    while n % 2 != 0
        n ÷= 2
    end

    zeros = 0
    zeros_blocks = Int[]
    for c ∈ string(n, base=2)[2:end]
        if c == '1'
            push!(zeros_blocks, zeros)
            zeros = 0
            continue
        end
        zeros += 1
    end
    push!(zeros_blocks, zeros)

    ans = 1
    mid_sum = 1
    for z_block ∈ zeros_blocks
        ans += z_block * mid_sum
        mid_sum += ans
    end
    ans
end

end
