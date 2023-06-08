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

: between ( val min max -- valBetween )
  ( inclusive between on min and max )
  rot dup -rot ( min val max val)
  >=
  -rot <=
  and
;

: inBounds? ( row col -- inBounds? )
  0 2 between
  swap
  0 2 between
  and
;

: isEmpty? ( row col -- inBounds? )
  get empty =
;

: isValidMove? ( row col -- is-valid? )
  2dup
  inBounds? ( row col inBounds? )
  -rot ( inBounds? row col )
  isEmpty?
  and
;

: getColumnValues ( column -- v1 v2 v3 )
  3 0 do
    dup i swap get swap ( val column )
  loop
  drop
;

: getRowValues ( row -- v1 v2 v3 )
  3 0 do
    dup i get swap ( val row )
  loop
  drop
;

: 3= ( v1 v2 v3 -- all-same? )
  dup -rot ( v1 v3 v2 v3 )
  = -rot ( v2=v3 v1 v3 )
  = and
;

: lastThreeAreSamePlayer ( v1 v2 v3 -- samePlayer? )
  dup empty =
  if
    drop drop drop false
  else
    ( we know v3 is a player )
    3=
  then
;

: anyColumnWin? ( -- a-column-has-won? )
  3 0 do
    i getColumnValues lastThreeAreSamePlayer
  loop
  or or
;

: anyRowWin? ( -- a-row-has-won? )
  3 0 do
    i getRowValues lastThreeAreSamePlayer
  loop
  or or
;

: anyDiagonalWin? ( -- a-row-has-won? )
  3 0 do
    i i get
  loop

  lastThreeAreSamePlayer

  3 0 do
    i i 2 swap - get
  loop
  lastThreeAreSamePlayer

  or
;

: anyoneHasWon? ( -- anyone-has-won? )
  anyColumnWin?
  anyRowWin?
  anyDiagonalWin?

  or or
;

: go ( row col -- )
  2dup isValidMove?
  if
    currentPlayer @
    set
    anyoneHasWon?
    printBoard
    if
      ." You won!"
    else
      switchCurrentPlayer
    then
  else
    48 +
    swap
    48 +
    cr
    ." Sorry, ("
    emit
    ." , "
    emit
    ." ) is not a valid move. Try again!"
  then
;
