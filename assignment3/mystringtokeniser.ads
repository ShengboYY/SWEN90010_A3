with Ada.Characters.Latin_1;

package MyStringTokeniser with SPARK_Mode is

   type TokenExtent is record
      Start : Positive;
      Length : Natural;
   end record;

   type TokenArray is array(Positive range <>) of TokenExtent;

   function Is_Whitespace(Ch : Character) return Boolean is
     (Ch = ' ' or Ch = Ada.Characters.Latin_1.LF or
        Ch = Ada.Characters.Latin_1.HT);

   procedure Tokenise(S : in String; Tokens : in out TokenArray; Count : out Natural) with
     Pre => (if S'Length > 0 then S'First <= S'Last) and Tokens'First <= Tokens'Last,
     Post => Count <= Tokens'Length and
     (for all Index in Tokens'First..Tokens'First+(Count-1) =>
          (Tokens(Index).Start >= S'First and
          Tokens(Index).Length > 0) and then
            Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start);

   -- Task 1.1
   -- Count <= Tokens'Length
     -- This postcondition means the number of tokens after tokenisation should not exceed the length of TokenArray.
     -- When we removed this postcondition, we found that the 'array index check might fail',
     -- which means without this, the number of tokens may exceed array's capacity and the out-of-bound exception may arise.
     -- For example, given an TokenArray(1..5), but the sixth token is written into the TokenArray(6).
     -- Therefore, it's necessary to have it in the postcondition.
     -- If not, the SPARK can not prove the calculator is free of array index check failure.

   -- (for all Index in Tokens'First..Tokens'First+(Count-1) => ...
     -- This postcondition means taht
       --  1. the start index of every token should not be smaller than first index of string S.
       --     For example, if the S'range = 2..10 and the start index of the first token is 1, then it's an invalid tokenisation.
       --  2. the length of token should be positive, which means the empty token is invalid.
       --  3. the last index of every token should not exceed the last index of the string S.
     -- If these condition can not be satisfied, the tokenisation and the token would be invalid.
     -- When we removed this postcondition, we found that the 'overflow check might fail' and 'range check might fail' would occur.
     -- The 'overflow check might fail' may because the start index, length index ior the last index of the token is too big or samll,
     -- causing that the computation which calls the start or length of the token would exceed the valid range of relevant type.
     -- The 'range check might fail' may because the length of token is larger than the string S.
     -- Therefore, without this postcondition, the SPARK can not prove the implementation is free of overflow or range check failure.




end MyStringTokeniser;
