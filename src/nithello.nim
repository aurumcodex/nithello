##[
  nithello.nim

  main application file; runs othello game.
]##

import strformat

import nithellopkg/player
import nithellopkg/board


proc nithello() =
  ## Main function to run the Othello game.
  var game: Board
  game = setup Black
  var moveset = generateMoves(game, game.player.color)
  print game, moveset
  echo "henlo"

  # var counter = 0
  # for j in game.board:
  #   echo typeof counter
  #   echo fmt"{counter}: {j}"
  #   inc counter
    


when isMainModule:
  import cligen
  dispatch nithello
