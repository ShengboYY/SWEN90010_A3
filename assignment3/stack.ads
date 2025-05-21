
-- Reused from SAPRK_Live_Lecture

generic
   Max_Size : Positive;
   type Item is private;
   Default_Item : Item;

package Stack with SPARK_Mode is

   type Stack is private;

   procedure Init(S : out Stack);

   procedure Push(S : in out Stack; I : in Item);

   procedure Pop(S : in out Stack; I : out Item);

   function Size(S : in Stack) return Integer;

   function Storage(S : in Stack; Pos : in Integer) return Item;

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
