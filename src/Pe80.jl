module Pe80

export pe_80

function pe_80(limit = 100)
    result = 0
    type = typeof(result)
    setprecision(512) do
        for n in 2:limit
            (isqrt(n))^2 == n && continue
            digits = (string ∘ sqrt ∘ BigFloat)(n)[1:101]
            for char in digits
                char == '.' && continue
                result += type(char) - type('0')
            end
        end
    end
    result
end

end
