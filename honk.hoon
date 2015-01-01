:: honk: nock in hoon, an exercise in futility
|%
++  noun                  :: A noun is an atom or a cell.
  $|  @                   :: An atom is a natural number.
      [noun noun]         :: A cell is an ordered pair of nouns.
::
:: no implementation      :: [a b c]          [a [b c]]
::
++  cell-test
  |=  a=noun
  ^-  noun
  ?@  a
    1                     :: ?a               1
  0                       :: ?[a b]           0
::
++  increment
  |=  a=noun
  ^-  noun
  ?@  a
    +(a)                  :: +a               1 + a
  !!                      :: +[a b]           +[a b]
::
++  equalness
  |=  a=noun
  ^-  noun
  ?@  a
    !!                    :: =a               =a
  ?:  =(-.a +.a)
    0                     :: =[a a]           0
  1                       :: =[a b]           1
::
++  treedress
  |=  a=noun
  ^-  noun
  ?@  a
    !!                    :: /a               /a
  ?.  ?=(@ -.a)
    !!                    :: /a               /a
  =+  h=(div -.a 2)
  ?:  =(-.a 1)
    +.a                   :: /[1 a]           a
  ?:  =(-.a 2)
    +<.a                  :: /[2 a b]         a
  ?:  =(-.a 3)
    +>.a                  :: /[3 a b]         b
  ?:  =(-.a (add h h))
    $(a [2 $(a [h +.a])]) :: /[(a + a) b]     /[2 /[a b]]
  ?:  =(-.a :(add h h 1))
    $(a [3 $(a [h +.a])]) :: /[(a + a + 1) b] /[3 /[a b]]
  !!                      :: /a               /a
::
++  honk
  |=  a=noun
  ^-  noun
  ?@  a
    !!                    :: *a               *a
  ?.  ?=(@ +<.a)
    :-  $(a [-.a +<.a])   :: *[a [b c] d]     [*[a b c] *[a d]]
        $(a [-.a +>.a])
  =+  sbj=-.a   :: a in [a n b c d]
  =+  frm=+.a   :: [n b c d] in [a n b c d]
  =+  fpl=+.frm :: [b c d] in [a n b c d]
  ?+  -.frm  !! :: *a               *a
    0 :: *[a 0 b]         /[b a]
      (treedress [fpl sbj])
    1 :: *[a 1 b]         b
      fpl
    2 :: *[a 2 b c]       *[*[a b] *[a c]]
      $(a [$(a [sbj -.fpl]) $(a [sbj +.fpl])])
    3 :: *[a 3 b]         ?*[a b]
      %:  cell-test  $(a [sbj fpl])
    4 :: *[a 4 b]         +*[a b]
      %:  increment  $(a [sbj fpl])
    5 :: *[a 5 b]         =*[a b]
      %:  equalness  $(a [sbj fpl])
    6 :: *[a 6 b c d]     *[a 2 [0 1] 2 [1 c d] [1 0] 2 [1 2 3] [1 0] 4 4 b]
      $(a [sbj 2 [0 1] 2 [1 +<.fpl +>.fpl] [1 0] 2 [1 2 3] [1 0] 4 4 -.fpl])
    7 :: *[a 7 b c]       *[a 2 b 1 c]
      $(a [sbj 2 -.fpl 1 +.fpl])
    8 :: *[a 8 b c]       *[a 7 [[7 [0 1] b] 0 1] c]
      $(a [sbj 7 [[7 [0 1] -.fpl] 0 1] +.fpl])
    9 :: *[a 9 b c]       *[a 7 c 2 [0 1] 0 b]
      $(a [sbj 7 +.fpl 2 [0 1] 0 -.fpl])
    10
      ?@  -.fpl
        $(a [sbj +.fpl]) :: *[a 10 b c]      *[a c]
      $(a [sbj 8 ->.fpl 7 [0 3] +.fpl])   :: *[a 10 [b c] d]  *[a 8 c 7 [0 3] d]
  ==
--