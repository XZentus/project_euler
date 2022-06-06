module Pe91

export pe_91

function pe_91(rows = 51, cols = 51)
    right_triangles = 0;

    for x ∈ 1:(cols - 1), y ∈ 1:x
        found = 0

        factor = gcd(x, y)
        Δx = x ÷ factor
        Δy = y ÷ factor

        found += min((rows - y - 1) ÷ Δx, x ÷ Δy)
        found += min((cols - x - 1) ÷ Δy, y ÷ Δx)
        (x ≠ y) && (found *= 2)

        right_triangles += found
    end
    
    # add triangles of form (0, 0) (x, y) (x, 0): x ≠ 0 ∧ y ≠ 0
    right_triangles += (rows - 1) * (cols - 1)
    
    # add triangles of form (0, 0) (0, y) (x, y): x ≠ 0 ∧ y ≠ 0
    right_triangles += (rows - 1) * (cols - 1)
    
    # add triangles of form (0, 0) (0, y) (x, 0): x ≠ 0 ∧ y ≠ 0
    right_triangles += (rows - 1) * (cols - 1)

    right_triangles
end

end
