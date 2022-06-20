"""
Let p(n) represent the number of different ways in which n coins can be separated into piles. For example, five coins can be separated into piles in exactly seven different ways, so p(5)=7.
OOOOO
OOOO  O
OOO   OO
OOO   O  O
OO    OO O
OO    O  O O
O     O  O O O

Find the least value of n for which p(n) is divisible by one million.
"""
module Pe78

export pe_78, get_pn

let p_n = Int[1], previous_mod = nothing
    global function gen_next(mod_)
        n = length(p_n) + 1
        S = 0
        J = n - 1
        k = 2
        while 0 ≤ J
            T = J == 0 ? 1 : p_n[J]
            S =  isodd(k÷2) ? S+T : S-T
            J -= isodd(k)   ? k   : k÷2
            k += 1
        end
        !isa(mod_, Nothing) && (S %= mod_)
        push!(p_n, S)
    end

    global function pe_78(mod_ = 1_000_000)
        mod ≠ previous_mod && (p_n = Int[1])
        while p_n[end] ≠ 0
            gen_next(mod_)
        end
        println("p($(length(p_n))) mod $mod_ = $(p_n[end])")
        length(p_n)
    end

    global get_pn() = p_n
end

end
