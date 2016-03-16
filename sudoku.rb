require 'set'

def f(board, row, col)
  puts pretty(board)
  puts

  if out_of_board?(row, col)
    true
  else
    if board[row][col]
      return f(board, *next_coords(row, col))
    end

    moves = find_moves(board, row, col)

    return false if moves.empty?

    moves.each do |move|
      board[row][col] = move

      if f(board, *next_coords(row, col))
        return true
      else
        board[row][col] = nil
      end
    end

    false
  end
end

def next_coords(row, col)
  if col == 8
    [row + 1, 0]
  else
    [row, col + 1]
  end
end

def new_board
  9.times.map { |row| [nil] * 9 }
end

def out_of_board?(row, col)
  row == 9
end

def find_moves(board, row, col)
  Set.new((1..9).to_a) -
    used_numbers(
      board,
      row_coords(row) + col_coords(col) + block_coords(row, col))
end

def row_coords(row)
  ([row]*9).zip(9.times.to_a)
end

def col_coords(col)
  (9.times.to_a).zip([col]*9)
end

def block_coords(row, col)
  base_row = row / 3
  base_col = col / 3

  [0, 1, 2].repeated_permutation(2).to_a.map do |(row_i, col_i)|
    [base_row*3 + row_i, base_col*3 + col_i]
  end
end

def used_numbers(board, coords)
  numbers = (coords.map { |(row, col)| board[row][col] }).compact
  Set.new(numbers)
end

def pretty(board)
  board.map do |row|
    row.map { |v| (v || '-').to_s.rjust(3) }.join
  end.join("\n")
end

def some_board
  [
    %w(- - - 7 2 - - - -),
    %w(3 - 6 - 1 - 2 - -),
    %w(- 5 - - 6 - - 7 -),
    %w(- - 2 - - 9 - 4 6),
    %w(4 - - - - - - - 7),
    %w(- 8 - - 7 - - - -),
    %w(- - 5 - - - - 8 -),
    %w(- 1 - 8 - - - 3 -),
    %w(- - - - - - 9 - -)
  ].map do |row|
    row.map do |v|
      v == '-' ? nil : v.to_i
    end
  end
end

board = some_board

f(board, 0, 0)
