with Ada.Text_IO;use Ada.Text_IO;

-- Reused from SAPRK_Live_Lecture

package body Stack is

   procedure Init(S : out Stack) is
   begin
      S.size := 0;
      S.storage := (others => Default_Item);
   end Init;

   procedure Push(S : in out Stack; I : in Item) is
   begin
      if S.size >= Max_Size then
         Put_Line("Stack is full!");
         return;
      end if;
      S.size := S.size + 1;
      S.storage(S.size) := I;
   end Push;

   procedure Pop(S : in out Stack; I : out Item) is
   begin
      if S.size = 0 then
         Put_Line("Stack is Empty");
         I := Default_Item;
         return;
      end if;
      I := S.storage(S.size);
      S.size := S.size - 1;
   end Pop;

   function Storage(S : in Stack; Pos : in Integer) return Item is
   begin
      if Pos < 1 or else Pos > S.size or else S.storage(Pos) = Default_Item then
         return Default_Item;
      end if;
      return S.storage(Pos);
   end Storage;

end Stack;
