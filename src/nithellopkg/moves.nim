##[
  moves.nim

  module to contain data about moves in the game and procs for getting moves.
]##

from board import Board
from player import Color, `-`

import util


type
  Move* = object
    cell: int
    numFlips: int
    direction: int


proc checkDir(id, dir: int): bool =
  # need to think about refactoring this somehow
  if dir == East and RightBorder.contains(id):
    result = true
  elif dir == West and LeftBorder.contains(id):
    result = true
  elif dir == NEast and (RightBorder.contains(id) or TopBorder.contains(id)):
    result = true
  elif dir == NWest and (LeftBorder.contains(id) or TopBorder.contains(id)):
    result = true
  elif dir == SEast and (RightBorder.contains(id) or BottomBorder.contains(id)):
    result = true
  elif dir == SWest and (LeftBorder.contains(id) or BottomBorder.contains(id)):
    result = true
  else:
    result = false


proc checkBorder(m: Move): bool =
  if LeftBorder.contains(m.cell):
    if m.direction == -West or m.direction == -NWest or m.direction == -SWest:
      result = true
    else:
      result = false
  elif RightBorder.contains(m.cell):
    if m.direction == -East or m.direction == -NEast or m.direction == -SEast:
      result = true
    else:
      result = false
  else:
    result = false


proc getCells*(moveset: seq[Move]): seq[int] =
  for _, c in moveset:
    result.add(c.cell)


proc getWeight*(m: Move): int =
  result = CellWeights[m.cell]


proc getLegalMoves*(b: Board, index, dir: int, color: Color): Move =
  var
    flips = 0
    i = index
    # d = dir
    m = Move()
    wall = false

  # block checking:
  while i >= 0 and i < BoardSize and not wall:
    wall = checkDir(index, dir)
    i += dir

    if i >= 0 and i < BoardSize:
      if b.board[i] != -color:
        break #[checking]#
      else:
        inc flips
    else:
      flips = 0
      break #[checking]#

  if i >= 0 and i < BoardSize:
    if b.board[index] == None and flips != 0:
      m.cell = index
      m.numFlips = flips
      m.direction = dir

  result = m


proc generateMoves*(b: Board, c: Color): seq[Move] =
  for i, val in b.board:
    if val == c:
      for _, d in Directions:
        var m: Move = getLegalMoves(b, i, c, d)
        if m.numFlips != 0 and not checkBorder(m):
          result.add(m)
