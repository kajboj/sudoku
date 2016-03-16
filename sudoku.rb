require 'set'

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

COORDS = (0..8).to_a.repeated_permutation(2).to_a

PEERS_COORDS = COORDS.inject({}) do |h, (row, col)|
  h[[row, col]] = (row_coords(row) + col_coords(col) + block_coords(row, col)).uniq
  h
end

def f(board, coords)
  if coords.empty?
    true
  else
    row, col = coords.first

    return f(board, coords[1..-1]) if board[row][col]

    moves = find_moves(board, row, col)

    return false if moves.empty?

    moves.each do |move|
      board[row][col] = move

      if f(board, coords[1..-1])
        return true
      else
        board[row][col] = nil
      end
    end

    false
  end
end

def find_moves(board, row, col)
  (1..9).to_a - used_numbers(board, PEERS_COORDS[[row, col]])
end

def used_numbers(board, coords)
  (coords.map { |(row, col)| board[row][col] }).compact
end

def pretty(board)
  board.map do |row|
    row.map { |v| (v || '-').to_s.rjust(3) }.join
  end.join("\n")
end

def load_boards(filename)
  lines = File.read(filename)
  lines.split(/Grid.*\n/i).map do |grid|
    grid.split("\n").map do |row|
      row.split('').map(&:to_i).map do |d|
        d == 0 ? nil : d
      end
    end
  end.reject(&:empty?)
end

def verify_group(board, coords)
  numbers = coords.map { |(r, c)| board[r][c] }
  if numbers.sort != (1..9).to_a
    raise 'incorrect solution'
  end
end

def verify_board(board)
  (0..8).each do |i|
    verify_group(board, row_coords(i))
    verify_group(board, col_coords(i))
  end
  [0, 3, 6].repeated_permutation(2).each do |(row, col)|
    verify_group(board, block_coords(row, col))
  end
end

boards = load_boards('sudoku.txt')

boards.each.with_index do |board, i|
  puts i
  f(board, COORDS)
  puts pretty(board)
  puts
  verify_board(board)
end
