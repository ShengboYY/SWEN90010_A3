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
      -- Prevent Stack Overflow
      if (S.size >= Max_Size) then
         Put_Line("Stack is full!");
         return;
      end if;
      S.size := S.size + 1;
      S.storage(S.size) := I;
   end Push;

   procedure Pop(S : in out Stack; I : out Item) is
   begin
      -- Prevent Stack Underflow
      if (S.size = 0) then
         I := Default_Item;
         Put_Line("Stack is empty");
         return;
      end if;
      I := S.storage(S.size);
      S.size := S.size - 1;
   end Pop;

end Stack;
