
-- Reused from SAPRK_Live_Lecture

generic
   Max_Size : Positive;
   type Item is private;
   Default_Item : Item;

package Stack with SPARK_Mode is

   type Stack is private;

   -- Check if it is initialised
   procedure Init(S : out Stack) with
     Post => Size(S) = 0;

   -- Check if the item is pushed into the stack
   procedure Push(S : in out Stack; I : in Item) with
     Pre => Size(S) < Max_Size,
     Post => Size(S) = Size(S'Old) + 1 and Storage(S, Size(S)) = I;

   -- Check if the top item is popped out
   procedure Pop(S : in out Stack; I : out Item) with
     Pre => Size(S) > 0,
     Post => Size(S) = Size(S'Old) - 1 and I = Storage(S'Old, Size(S'Old));

   function Size(S : in Stack) return Integer;

   -- Check if the S.storage(Pos) is defined
   function Storage(S : in Stack; Pos : in Integer) return Item with
     Pre => Pos > 0 and Pos <= Size(S);

private
   type Storage_Array is array(1..Max_Size) of Item;

   type Stack is record
      size : Integer range 0..Max_Size;
      storage : Storage_Array;
   end record;

   function Size(S : in Stack) return Integer is
     (S.size);

   function Storage(S : in Stack; Pos : in Integer) return Item is
      (S.storage(Pos));

end Stack;
