variable board
9 cells allot
variable currentPlayer
1 cells allot

0 constant empty
1 constant circle
2 constant cross

: get-cell-address ( row col -- value )
  swap 3 * + cells board +
;

: get ( row col -- value )
  get-cell-address @
;

: set ( row col value -- )
  -rot get-cell-address !
;

: init ( -- )
  3 0 do 
    3 0 do
      j i empty set
    loop
  loop
  circle currentPlayer !
;

: switchCurrentPlayer ( currentPlayer --- nextPlayer )
  currentPlayer @
  circle
  =
  if 
  cross currentPlayer !
  else
  circle currentPlayer !
  then
;

: printValue ( number -- )
  case
  cross
  of ." X "
  endof
  circle
  of ." O "
  endof
  empty
  of ." - "
  endof
  endcase
;

: printBoard
  page
  3 0 do
    3 0 do
      j i get printValue
    loop
    cr
  loop
;

: go ( row col -- ) 
  currentPlayer @ 
  set
  switchCurrentPlayer
  printBoard
;