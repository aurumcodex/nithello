##[
  bot.nim
  =======

  file to be included into player.nim for bot related functions.
]##

# import random

import board
import moves
import player

from util import MaxInt, MinInt

type
  MoveType {.pure.} = enum
    Rng
    AlphaBeta
    Negamax
    MTDf


proc makeMove*(p: Player, moveset: seq[Move], game: Board, turnCount: int, debug: bool): int =
  # randomize()
  var
    depth = 0
    maxing = true
    alpha = MinInt.float64
    beta = MaxInt.float64
    color = p.color

  var moveType: MoveType
  case turnCount:
    of 0..4:
      moveType = Rng
    of 5..9:
      moveType = AlphaBeta
    of 10..14:
      moveType = Negamax
    of 15..19:
      moveType = MTDf
    else:
      moveType = Rng
  
  case moveType:
    of Rng:
      echo "bot is using an rng move"
      result = rngMove(moveset, debug)
    of AlphaBeta:
      echo "bot is using an move generated from alphaBeta"
      result = rngMove(moveset, debug)
      # for 
      # # var temp = game
      # # temp.applyMove(color, m.cell)

      # result = 
    else:
      echo "(the bot shruged)"
      result = rngMove(moveset, debug)

  result = -1