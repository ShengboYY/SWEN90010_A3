with PIN;
with Stack;
with MemoryStore;
with StringToInteger;

package Calculator with SPARK_MODE is

   package SS is new Stack(512, Integer, 0);

   type Calculator is private;

   -- Check if successfully initialised
   procedure Init(Cal : out Calculator) with
     Post => Get_State(Cal) = True and PIN."="(Get_MasterPIN(Cal), PIN.From_String("0000"));

   -- Check if successfully setted
   procedure Set_MasterPIN(Cal : in out Calculator; Master_PIN : in String) with
     Post => PIN."="(Get_MasterPIN(Cal), PIN.From_String(Master_PIN)) ;

   procedure Check_Locked(Cal : in Calculator);

   -- Check if it is in locked state and only unlocked when the input PIN is right
   procedure Unlock(Cal : in out Calculator; Input_PIN : in String) with
     Pre => Get_State(Cal) = True,
     Post => (if PIN."="(Get_MasterPIN(Cal), PIN.From_String(Input_PIN)) then Get_State(Cal) = False
        else Get_State(Cal) = True);

   -- Check if it is in unlocked state and locked with the new PIN
   procedure Lock(Cal : in out Calculator; New_PIN : in String) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = True and PIN."="(Get_MasterPIN(Cal), PIN.From_String(New_PIN));

   procedure Push(Cal : in out Calculator; Number : in String);

   procedure Pop(Cal : in out Calculator);

   -- Check if it is unlocked
   procedure Arithmetic_Operation(Cal : in out Calculator; First_Token : in String) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = Get_State(Cal)'Old;

   -- Check if it is unlocked
   procedure StoreTo(Cal : in out Calculator; Loc : in String) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = Get_State(Cal)'Old;

   -- Check if it is unlocked
   procedure List(Cal : in Calculator) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = Get_State(Cal)'Old;

   -- Check if it is unlocked
   procedure LoadFrom(Cal : in out Calculator; Loc : in String) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = Get_State(Cal)'Old;

   -- Check if it is unlocked
   procedure Remove(Cal: in out Calculator; Loc : in String) with
     Pre => Get_State(Cal) = False,
     Post => Get_State(Cal) = Get_State(Cal)'Old;

   function Get_MasterPIN(Cal : in Calculator) return PIN.PIN;

   function Get_State(Cal : in Calculator) return Boolean;

   function Check_PIN_Validation(PIN : in String) return Boolean;

private

   type Calculator is record
      Master_PIN : PIN.PIN;
      locked : Boolean;
      stack : SS.Stack;
      memeory : MemoryStore.Database;
   end record;

   function Get_MasterPIN (Cal : in Calculator) return PIN.PIN is
     (Cal.Master_PIN);

   function Get_State (Cal : in Calculator) return Boolean is
     (Cal.locked);

end Calculator;
