with Ada.Text_IO; use Ada.Text_IO;
with PIN;
with Stack;
with MemoryStore;
with StringToInteger;

package body Calculator is

   procedure Init(Cal : out Calculator) is
   begin
      Cal.Master_PIN := PIN.From_String ("0000");
      Cal.locked := True;
      SS.Init(Cal.stack);
      MemoryStore.Init(Cal.memeory);
   end Init;

   -- The input PIN should be the 4-digit string from 0000 to 9999
   function Check_PIN_Validation(PIN : in String) return Boolean is
      PIN_Integer : Integer := StringToInteger.From_String(PIN);
   begin
      if PIN'Length = 4 and PIN_Integer > 0 and PIN_Integer < 9999 then
         return True;
      else
         return False;
      end if;
   end Check_PIN_Validation;

   procedure Set_MasterPIN(Cal : in out Calculator; Master_PIN : in String) is
      Input_PIN : PIN.PIN := PIN.From_String(Master_PIN);
   begin
      if Check_PIN_Validation(Master_PIN) then
         Cal.Master_PIN := Input_PIN;
      else
         Put_Line("Invalid PIN");
         return;
      end if;
   end Set_MasterPIN;

   procedure Check_Locked(Cal : in Calculator) is
   begin
      if Cal.locked then
         Put("locked> ");
      else
         Put("unlocked> ");
      end if;
   end Check_Locked;

   -- Command: unlock
   procedure Unlock(Cal : in out Calculator; Input_PIN : in String) is
   begin
      if Check_PIN_Validation(Input_PIN) then
         if PIN."="(Cal.Master_PIN, PIN.From_String(Input_PIN)) then
            Cal.locked := False;
         end if;
      else
         Put_Line("Invalid PIN");
         return;
      end if;
   end Unlock;

   -- Command: lock
   procedure Lock(Cal : in out Calculator; New_PIN : in String) is
   begin
      if Check_PIN_Validation(New_PIN) then
         Cal.locked := True;
         Cal.Master_PIN := PIN.From_String(New_PIN);
      else
         Put_Line("Invalid PIN");
         return;
      end if;
   end Lock;

   -- Command: push1, push2
   procedure Push(Cal : in out Calculator; Number : in String) is
      Input_Number : Integer := StringToInteger.From_String(Number);
   begin
      SS.Push(Cal.stack, Input_Number);
   end Push;

   -- Command: pop
   procedure Pop(Cal : in out Calculator) is
      Number : Integer;
   begin
      SS.Pop(Cal.stack, Number);
   end Pop;

   -- Command:+, -, *, /
   procedure Arithmetic_Operation(Cal : in out Calculator; First_Token : in String) is
      Number1 : Integer;
      Number2 : Integer;
      Long1 : Long_Long_Integer;
      Long2 : Long_Long_Integer;
      Outcome : Long_Long_Integer;
   begin
      -- More than 2 elements in the stack is necessary for arithmetic operation
      if SS.Size(Cal.stack) < 2 then
         Put_Line("Operation failed!");
         return;
      end if;

      SS.Pop(Cal.stack, Number1);
      SS.Pop(Cal.stack, Number2);

      -- Prevent Integer Overflow
      Long1 := Long_Long_Integer(Number1);
      Long2 := Long_Long_Integer(Number2);

      if First_Token = "+" then
         Outcome := Long1 + Long2;
      elsif First_Token = "-" then
         Outcome := Long1 - Long2;
      elsif First_Token = "*" then
         Outcome := Long1 * Long2;
      elsif First_Token = "/" then
         if Long2 /= 0 then
            Outcome := Long1 / Long2;
         else
            Put_Line("Division by zero is not allowed!");
            return;
         end if;
      else
         Put_Line("Invalid Arithmetic Operand!");
      end if;

      -- If the outcome is outside the range -2_147_483_648 .. 2_147_483_647,
      -- the operation will not be performed
      if Outcome <= 2_147_483_647 and Outcome >= -2_147_483_648 then
         SS.Push(Cal.stack,Integer(Outcome));
      else
         Put_Line("Operation failed! Result Overflow!");
         SS.Push(Cal.stack, Number2);
         SS.Push(Cal.stack, Number1);
      end if;

   end Arithmetic_Operation;

   -- Command: storeTo
   procedure StoreTo(Cal : in out Calculator; Loc : in String) is
      Number : Integer;
      Int32_Number : MemoryStore.Int32;
   begin
      SS.Pop(Cal.stack, Number);
      Int32_Number := MemoryStore.Int32(Number);
      -- Check Input Memory Location
      if (StringToInteger.From_String(Loc) in 1..MemoryStore.Max_Locations) then
         MemoryStore.Put(Cal.memeory, StringToInteger.From_String(Loc), Int32_Number);
      else
         Put_Line("Invalid location!");
      end if;
   end StoreTo;

   -- Command: list
   procedure List(Cal : in Calculator) is
   begin
      MemoryStore.Print(Cal.memeory);
   end List;

   -- Command: loadFrom
   procedure LoadFrom(Cal : in out Calculator; Loc : in String) is
      Location : MemoryStore.Location_Index;
      Number : Integer;
      Int32_Number : MemoryStore.Int32;
   begin
      -- Check Input Memory Location
      if (StringToInteger.From_String(Loc) not in 1..MemoryStore.Max_Locations) then
         Put_Line("Invalid location!");
         return;
      end if;

      Location := MemoryStore.Location_Index(StringToInteger.From_String(Loc));
      if MemoryStore.Has(Cal.memeory, Location) then
         Int32_Number := MemoryStore.Get(Cal.memeory, Location);
         Number := Integer(Int32_Number);
         SS.push(Cal.stack, Number);
      else
         Put_Line("Invalid location!");
      end if;
   end LoadFrom;

   -- Command: remove
   procedure Remove(Cal: in out Calculator; Loc : in String) is
      Location : MemoryStore.Location_Index;
   begin
      -- Check Input Memory Location
      if (StringToInteger.From_String(Loc) not in 1..MemoryStore.Max_Locations) then
         Put_Line("Invalid location!");
         return;
      end if;

      Location := MemoryStore.Location_Index(StringToInteger.From_String(Loc));
      if MemoryStore.Has(Cal.memeory, Location) then
         MemoryStore.Remove(Cal.memeory, Location);
      else
         Put_Line("Invalid location!");
      end if;
   end Remove;


end Calculator;
