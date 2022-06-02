module Pe75

export pe_75

function pe_75(limit = 1_500_000)
    type = typeof(limit)
    result = Dict{type, Set{Tuple{type, type, type}}}()
    for m ∈ 1:limit
        m^2-1 + 2m + m^2 > limit && break
        for n ∈ 1:(m - 1)
            x = m^2 - n^2
            y = 2*m*n
            z = m^2 + n^2
            if x < y
                x, y = y, x
            end
            l = x + y + z
            l > limit && @goto next_m
            for k ∈ 1:limit
                kl = k*l
                kl > limit && break
                kl ∉ keys(result) && (result[kl] = Set{Tuple{type, type, type}}())
                push!(result[kl], (k*x, k*y, k*z))
            end
        end
        @label next_m
    end
    length(filter(r -> length(r[2]) == 1, result))
end

end
