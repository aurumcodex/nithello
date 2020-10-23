##[
  player.nim

  module for the data that a player would need for the game.
]##

type
  Color* {.pure.} = enum
    White = (-1, "W")
    None  = (0, "-")
    Black = (1, "B")

type
  Player* = object
    color:    Color
    numDiscs: int
    human:    bool
    passing:  bool
    # score: int

proc initPlayer*(#[p: var Player]#c: Color, human: bool): Player =
  result = Player(color: c, numDiscs: 0, human: human, passing: false)