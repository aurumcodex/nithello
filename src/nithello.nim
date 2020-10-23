##[
  nithello.nim

  main application file; runs othello game.
]##

# import nithellopkg/modules
import nithellopkg/player
import nithellopkg/board

# const blk = Black

proc nithello() =
  ## Main function to run the Othello game.
  var game: Board
  game = setup(Black)
  echo game
  echo "henlo"

when isMainModule:
  import cligen
  dispatch nithello
