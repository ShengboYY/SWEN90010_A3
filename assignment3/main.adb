pragma SPARK_Mode (On);

with MyCommandLine;
with MyString;
with MyStringTokeniser;
with StringToInteger;
with PIN;
with MemoryStore;
with Calculator;

with Ada.Text_IO;use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Long_Long_Integer_Text_IO;


procedure Main is
   
   package Lines is new MyString (Max_MyString_Length => 2048);
   S    : Lines.MyString;
   Cal : Calculator.Calculator;
   
begin
   Calculator.Init(Cal);
   -- Set master PIN from command line
   if MyCommandLine.Argument_Count /= 1 then
      Put("I was invoked with "); Put(MyCommandLine.Argument_Count,0); Put_Line(" arguments.");
      Put_Line("Invalid Command!");
   else 
      Calculator.Set_MasterPIN(Cal, MyCommandLine.Argument(1));
      Put("locked> "); 
      
      -- Interact with the calculator
      loop 
         Lines.Get_Line(S);  
         -- Each input should not exceed 2048 characters
         if Lines.Length(S) > 2048 or Lines.Length(S) <= 0 then
            Put_Line("Invalid command!");
            exit;
         end if;
         declare
            T : MyStringTokeniser.TokenArray(1..5) := (others => (Start => 1, Length => 0));
            NumTokens : Natural; 
            locked : Boolean := Calculator.Get_State(Cal);
         begin
            -- Split command into tokens  
            MyStringTokeniser.Tokenise(Lines.To_String(S),T,NumTokens);
            if NumTokens > 3 then
               Put_Line("You entered too many tokens");
               exit;
            elsif NumTokens <= 0 then
               Put_Line("Empty command!");
               exit;
            else
               -- Check All Tokens
               declare
                  Valid : Boolean := True;
               begin
                  for I in 1 .. NumTokens loop
                     declare
                        Start_Pos : Positive := T(I).Start;
                        End_Pos   : Positive := T(I).Start + T(I).Length - 1;
                     begin
                        if Start_Pos < 1 or else 
                          End_Pos < Start_Pos or else 
                          End_Pos > Lines.Length(S) 
                        then
                           Valid := False;
                           exit;
                        end if;
                     end;
                  end loop;

                  if not Valid then
                     Put_Line("Invalid token positions detected!");
                     exit;  
                  end if;      
               end;
               declare
                  First_Token : String := Lines.To_String(Lines.Substring(S,T(1).Start,T(1).Start+T(1).Length-1));
               begin
                  if locked then  
                     -- If the calculator is locked, the user should unlock it before entring other commands
                     if First_Token /= "unlock" then
                        -- If the command is "lock <NUMBER>", nothing happens
                        if First_Token /= "lock" then
                           Put_Line("The Calculator is locked!");
                           exit;
                        end if;
                     else
                        -- If the command is "unlock <NUMBER>", the NumTokens should be 2. Otherewise, it's invalid
                        if NumTokens = 2 then
                           Calculator.Unlock(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                        else 
                           Put_Line("Invalid command!");                          
                           exit;
                        end if;
                     end if;
               
                  else
                     -- When the calculator is unlocked
                     -- If the command is "unlock <NUMBER>", nothing happens
                     if First_Token /= "unlock" then
                        if NumTokens = 1 then
                           if First_Token = "+" or First_Token = "-" or First_Token = "*" or First_Token = "/"  then
                              Calculator.Arithmetic_Operation(Cal, First_Token);
                           elsif First_Token = "list" then
                              Calculator.List(Cal);
                           elsif First_Token = "pop" then
                              Calculator.Pop(Cal);
                           else
                              Put_Line("Invalid command!");                          
                              exit;
                           end if;
                        elsif NumTokens = 2 then
                           if First_Token = "lock" then
                              Calculator.Lock(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                           elsif First_Token = "push1" then
                              Calculator.Push(Cal,Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                           elsif First_Token = "storeTo" then
                              Calculator.StoreTo(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                           elsif First_Token = "loadFrom" then
                              Calculator.LoadFrom(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                           elsif First_Token = "remove" then
                              Calculator.Remove(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                           else
                              Put_Line("Invalid command!");                          
                              exit;
                           end if;
                        elsif NumTokens = 3 then
                           if First_Token = "push2" then
                              Calculator.Push(Cal, Lines.To_String(Lines.Substring(S,T(2).Start,T(2).Start+T(2).Length-1)));
                              Calculator.Push(Cal, Lines.To_String(Lines.Substring(S,T(3).Start,T(3).Start+T(3).Length-1)));
                           else
                              Put_Line("Invalid command!");                          
                              exit;
                           end if;     
                        -- The command should only have two or three tokens. Otherwise, it's invalid
                        else
                           Put_Line("Invalid command!");                          
                           exit;
                        end if;
                     end if;
                  end if;   
               end;  
            end if;
         end;
         Calculator.Check_Locked(Cal); 
      end loop;
   end if;
end Main;

