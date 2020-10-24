##[
  board.nim

  module to hold data about the playing board.
]##

import player
# import util

type
  Board* = object
    player: Player
    bot:    Player
    board:  array[64, Color]
    gameOver: bool

proc setup*(c: Color): Board =
  var
    player = initPlayer(c, true)
    bot = initPlayer(c, false)

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
