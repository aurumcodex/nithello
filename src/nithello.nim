##[
  nithello.nim
  ============

  main application file; runs othello game.
]##

import strformat
import tables

import nithellopkg/player
import nithellopkg/board
import nithellopkg/util


proc nithello(human=true, threads=8, debug=false) =
  ## Main function to run the Othello game.
  var game: Board
  game = setup Black
  var movesetP = game.generateMoves(game.player.color)
  var movesetB = game.generateMoves(game.bot.color)
  print game, movesetP
  echo "henlo"
  echo fmt"MaxInt is: {MaxInt}"
  echo fmt"MinInt is: {MinInt}"
  var temp = game
  print temp
  echo ""
  echo game
  echo temp
  for d, j in Rows.pairs:
    echo fmt"{d} {j}"
  echo movesetP
  echo movesetB


when isMainModule:
  import cligen
  dispatch nithello
