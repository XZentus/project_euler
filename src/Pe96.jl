module Pe96

export get_default_sudoku, solver!, pe_96

"""
Return an example grid
"""
function get_default_sudoku()
    raw_string = """
        003020600
        900305001
        001806400
        008102900
        700000008
        006708200
        002609500
        800203009
        005010300
        """
    transpose(reshape([parse(Int32, d) for d in raw_string if '0' ≤ d ≤ '9'], (9, 9)))
end

"""
Solves sudoku starting from position [row, col]
Doesn't change previous cells 
"""
function solver!(matrix, row = 1, col = 1)
    rows, cols = size(matrix)

    col > cols && (row += 1; col = 1) # next row
    row > rows && return true

    matrix[row, col] ≠ 0 && return solver!(matrix, row, col + 1) # number exists
    
    allowed_numbers = Set([1 2 3 4 5 6 7 8 9])
    #remove number in row
    for r ∈ 1:9
        r == row && continue
        delete!(allowed_numbers, matrix[r, col])
    end

    #remove numbers in column
    for c ∈ 1:9
        c == col && continue
        delete!(allowed_numbers, matrix[row, c])
    end
    
    #remove numbers in square
    row_offset, col_offset = ((row - 1) ÷ 3) * 3, ((col - 1) ÷ 3) * 3
    for r ∈ (1:3) .+ row_offset, c ∈ (1:3) .+ col_offset
        (row == r && col == c) && continue
        delete!(allowed_numbers, matrix[r, c])
    end
    
    for n ∈ allowed_numbers
        matrix[row, col] = n
        solver!(matrix, row, col + 1) && return true
    end
    matrix[row, col] = 0
    return false
end

function pe_96(path = "p096_sudoku.txt")
    contents = readlines(path)
    current_line = 1
    ans = 0
    while current_line < length(contents)
        sudoku_raw = join(contents[(current_line + 1):(current_line + 9)])
        sudoku = transpose(reshape([parse(Int64, d) for d ∈ sudoku_raw if '0' ≤ d ≤ '9'], (9, 9)))
        solver!(sudoku)
        println(contents[current_line])
        for row ∈ 1:9
            println(sudoku[row, :])
        end
        ans += sum([sudoku[1, 1] * 100, sudoku[1, 2] * 10, sudoku[1, 3]])
        current_line += 10
    end
    ans
end

end
