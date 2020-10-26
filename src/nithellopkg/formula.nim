##[
  formula.nim
  ===========

  (not called algorithm.nim to prevent confusion while developing)
  module to contain various search algorithms for the othello game.
]##

import strformat
import random

import board
import moves

from evaluate import Scores, calculateScores
from player import Color, `-`#[, Player]#
from util import MaxDepth, MaxInt, MinInt, BoardSize


proc alphaBeta*(b: Board, alpha, beta: var float64, player: Color, depth: int, maxing, debug: bool): int =
  var
    moveCount = b.generateMoves(player).len
    bestMove = 0
    moveset: seq[Move]

  if debug:
    echo fmt"moves available: {moveCount} | depth = {depth}"

  if depth == MaxDepth:
    if debug:
      echo fmt"hit max depth ({MaxDepth})"
    
    var scores = b.calculateScores
    bestMove = scores.score

    if debug:
      print b

  elif depth < MaxDepth:
    if maxing:
      bestMove = MinInt
      moveset = b.generateMoves(player)

      for m in moveset:
        if debug:
          echo fmt"legal cell = {m.cell}"

        var temp = b
        temp.apply(player, m.cell, debug)
        temp.flipDiscs(player, -m.direction, m.cell, debug)

        var val = temp.alphaBeta(alpha, beta, -player, depth+1, not maxing, debug)

        bestMove = max(bestMove, val)
        alpha = max(alpha, bestMove.float64)

        if alpha >= beta:
          break

    elif not maxing:
      bestMove = MaxInt
      moveset = b.generateMoves(player)

      for m in moveset:
        if debug:
          echo fmt"legal cell = {m.cell}"

        var temp = b
        temp.apply(player, m.cell, debug)
        temp.flipDiscs(player, -m.direction, m.cell, debug)

        var val = temp.alphaBeta(alpha, beta, -player, depth+1, not maxing, debug)

        bestMove = min(bestMove, val)
        beta = min(beta, bestMove.float64)

        if alpha >= beta:
          break

  result = bestMove


proc negamax*(b: Board, alpha, beta: var float64, player: Color, depth: int, debug: bool): int =
  var
    moveset = b.generateMoves(player)
    moveCount = moveset.len
    bestMove = MinInt
    swap = -alpha

  alpha = -beta # swapping alpha and beta, otherwise a compile error happens
  beta = swap

  if debug:
    echo fmt"moves available: {moveCount} | depth = {depth}"
  
  if depth == 0:
    result = player.int * b.calculateScores.score

  for m in moveset:
    if debug:
      echo fmt"legal cell = {m.cell}"

    var temp = b
    temp.apply(player, m.cell, debug)
    temp.flipDiscs(player, -m.direction, m.cell, debug)

    bestMove = max(bestMove, -temp.negamax(beta, alpha, -player, depth-1, debug))
    alpha = max(alpha, bestMove.float64)

    if alpha >= beta:
      break

  result = bestMove


proc rngMove*(moveset: seq[Move], debug: bool): int =
  randomize() # need this to make rng "believable"

  var
    cells = getCells moveset
    m = rand(BoardSize)

  if debug:
    echo fmt"cell list: {cells}"

  while not cells.contains(m):
    m = rand(BoardSize)

  result = m