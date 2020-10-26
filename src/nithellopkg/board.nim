##[
  board.nim

  module to hold data about the playing board.
]##

import strformat

import player
import moves
import util

from util import printChar

type
  Board* = object
    player*: Player
    bot*:    Player
    board*:  array[64, Color]
    gameOver*: bool


# include moves


proc setup*(c: Color): Board =
  var
    player = initPlayer(c, true)
    bot = initPlayer(-c, false)

  var brd: array[64, Color]
  brd[27] = White
  brd[28] = Black
  brd[35] = Black
  brd[36] = White

  result = Board(
    player: player,
    bot: bot,
    board: brd,
    gameOver: false
  )


proc apply*(b: var Board, color: Color, cell: int, debug: bool) =
  if b.board[cell] == None:
    if debug:
      echo fmt"applying move at cell: {cell}"
      echo fmt"cell was originally: {b.board[cell]}"

    b.board[cell] = color

    if debug:
      echo fmt"cell is now: {b.board[cell]}"


proc flipDiscs*(b: var Board, color: Color, dir, cell: int, debug: bool) =
  var temp = cell

  while temp >= 0 and cell < 64:
    temp = temp + dir

    if debug:
      echo fmt"cell is now: {temp}"
    
    if temp < 64:
      if b.board[temp] == color:
        break
      else:
        b.board[temp] = color


proc getLegalMove*(b: Board, index, dir: int, color: Color): Move =
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
      for d in Directions:
        var m: Move = getLegalMove(b, i, d, c)
        if m.numFlips != 0 and not checkBorder(m):
          result.add(m)


proc print*(b: Board, moveset: seq[Move]) =
  ## print out the board in an easy to read 2D format
  let cells = getCells(moveset)

  echo fmt"bot is {b.bot.color} | player is {b.player.color}"
  echo "  ._a_b_c_d_e_f_g_h_"

  for i, c in b.board:
    if i mod 8 == 0:
      stdout.write fmt"{getRow(i)} |"
    if cells.contains(i):
      printChar i, "+"
      continue
    else:
      printColor i, c


proc isGameOver*(b: Board): bool =
  result = b.player.passing and b.bot.passing

