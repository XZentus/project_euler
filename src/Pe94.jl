
"""
Incomplete calculation of perimeter with Heron's formula. Sides are: x, x, x+1.
To complete calculation it should be: √(S(x)÷16) = (√S(x))÷4
"""
Sp1(x) = (3x + 1)*(x + 1)*(x^2 - 1)

"""
Incomplete calculation of perimeter with Heron's formula. Sides are: x, x, x-1.
To complete calculation it should be: √(S(x)÷16) = (√S(x))÷4
"""
Sm1(x) = (3x - 1)*(x - 1)*(x^2 - 1)

"""
Perimeter of a triangle with sides x, x, x+1
"""
pp1(x) = 3x + 1

"""
Perimeter of a triangle with sides x, x, x-1
"""
pm1(x) = 3x - 1

function pe_94(limit)
    # Tringle with sides 1, 1, 2 has area = 0. Starting with sides 3, 3, 4
    x = oftype(limit, 3)
    p_x = pm1(x)
    ans = oftype(limit, 0)
    while p_x < limit
        # Sides x,x,x+1
        sp = Sp1(x)
        i = isqrt(sp)
        if i^2 == sp
            println("Δ($x, $x, $(x+1)): S(Δ)=$(i÷4)")
            ans += p_x
        end

        # Sidex x,x,x-1
        sm = Sm1(x)
        i = isqrt(sm)
        if i^2 == sm
            println("Δ($x, $x, $(x-1)): S(Δ)=$(i÷4)")
            ans += pm1(x)
        end

        x += 2
        p_x = pp1(x)
    end
    ans
end
