with PIN;
with Stack;
with MemoryStore;
with StringToInteger;

package Calculator with SPARK_MODE is

   package SS is new Stack(512, Integer, 0);

   type Calculator is private;

   procedure Init(Cal : out Calculator);

   procedure Set_MasterPIN(Cal : in out Calculator; Master_PIN : in String);

   procedure Check_Locked(Cal : in Calculator);

   procedure Unlock(Cal : in out Calculator; Input_PIN : in String);

   procedure Lock(Cal : in out Calculator; New_PIN : in String);

   procedure Push(Cal : in out Calculator; Number : in String);

   procedure Pop(Cal : in out Calculator);

   procedure Arithmetic_Operation(Cal : in out Calculator; First_Token : in String);

   procedure StoreTo(Cal : in out Calculator; Loc : in String);

   procedure List(Cal : in Calculator);

   procedure LoadFrom(Cal : in out Calculator; Loc : in String);

   procedure Remove(Cal: in out Calculator; Loc : in String);

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
