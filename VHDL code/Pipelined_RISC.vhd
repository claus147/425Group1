---------------------------------------------------------------------------
-- Pipelined implementation - Phase 2
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------------------------
entity Pipelined_RISC is
	port (
		clk 			: in std_logic;
		rst_external 	: in std_logic
	);
end entity Pipelined_RISC;

---------------------------------------------------------------------------
architecture RTL of Pipelined_RISC is


---------------------------------------------------------------------------
-------------------------------- COMPONENTS -------------------------------
---------------------------------------------------------------------------

-- Component Contents
-- - 1 PIPELINED REGISTERS
-- -- SingleReg
-- -- Reg_IF_ID
-- -- Reg_ID_EX
-- -- Reg_EX_MEM
-- -- Reg_MEM_WB
-- - 2 PIPELINED ADDITIONAL (NEW STUFF)
-- -- Hazard_control
-- -- Forwarding_logic
-- -- Early_branch_resolution
-- - 3 MUX'S
-- -- MUX
-- -- MUX_3to1
-- -- MUX_4to1
-- -- MUX5bit
-- -- MUX_unsigned
-- - 4 CONTROLLERS
-- -- OPCODE
-- -- FSM_control
-- -- ALUControl
-- - 5 ALU's
-- -- ALU
-- -- BranchAdder
-- -- PC_Add
-- - 6 OTHER
-- -- INSTR
-- -- SignExtender
-- -- JumpShifter
-- -- REG
-- -- Main_Memory

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------- PIPELINE REGISTERS ---------------------------

component SingleREG
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		write_pc			: in std_logic;
		reg_in				: in unsigned(31 downto 0);
		reg_out				: out unsigned(31 downto 0)
	);
end component;


component Reg_IF_ID
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		stall, dirtyF, flush   :in std_logic;
    dirtyD   :out std_logic;
    instr : in std_ulogic_vector(31 downto 0);
	  instr_out : out std_ulogic_vector(31 downto 0);
	  PC4F : in unsigned(31 downto 0);
	  PC4D : out unsigned(31 downto 0)
	);
end component;

component Reg_ID_EX 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
    AD      : in signed(31 downto 0);
	  BD      : in signed(31 downto 0);
	  RsD     : in std_ulogic_vector(4 downto 0);
	  RtD     : in std_ulogic_vector(4 downto 0);
	  RdD     : in std_ulogic_vector(4 downto 0);
	  PCWriteCondD, PCWriteCondND, PCWriteD, IorDD, MemReadD, MemWriteD, MemtoRegD, IRWriteD, ALUSrcAD, RegWriteD, DumpD, ResetD, InitMemD,WordByteD, ALUSrcBD	: in std_logic;
		PCSourceD, RegDstD	: in std_ulogic_vector(1 downto 0);
	  PCWriteCondE, PCWriteCondNE, PCWriteE, IorDE, MemReadE, MemWriteE, MemtoRegE, IRWriteE, ALUSrcAE, RegWriteE, DumpE, ResetE, InitMemE,WordByteE, ALUSrcBE	: out std_logic;
		PCSourceE, RegDstE	: out std_ulogic_vector(1 downto 0);
	  RsE : out std_ulogic_vector(4 downto 0);
	  RtE : out std_ulogic_vector(4 downto 0);
	  RdE : out std_ulogic_vector(4 downto 0);	  
	  AE  : out signed(31 downto 0);
	  BE  : out signed(31 downto 0);
	  flush  : in std_logic;
	  opD : in std_ulogic_vector(5 downto 0);
	  opE: out std_ulogic_vector(5 downto 0)
	);
end component;

component Reg_EX_MEM 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUE    : in signed(31 downto 0);
		ALUM    : out signed(31 downto 0);
	  RdtE    : in std_ulogic_vector(4 downto 0);
		RdtM    : out std_ulogic_vector(4 downto 0);
    MemReadE, MemWriteE, MemtoRegE,RegWriteE, DumpE, ResetE, InitMemE,WordByteE	: in std_logic;
	  MemReadM, MemWriteM, MemtoRegM,RegWriteM, DumpM, ResetM, InitMemM,WordByteM	: out std_logic
	);
end component;

component Reg_MEM_WB 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUM : in signed(31 downto 0);
		ALUW : out signed(31 downto 0);
		MEMM : in std_logic_vector(31 downto 0);
		MEMW  : out std_logic_vector(31 downto 0);     
		RdtM    : in std_ulogic_vector(4 downto 0);
		RdtW    : out std_ulogic_vector(4 downto 0);
		MemtoRegM, RegWriteM	: in std_logic;
	  MemtoRegW, RegWriteW	: out std_logic
	);
end component;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--------------------- PIPELINED ADDITIONAL (NEW STUFF) --------------------

component Hazard_control
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ID_EX_Rd: in std_ulogic_vector(4 downto 0);
    IF_ID_Rs : in std_ulogic_vector(4 downto 0);
    IF_ID_Rt : in std_ulogic_vector(4 downto 0);
    ID_EX_MemRead : in std_logic;
    stall : out std_logic
	);
end component;

component Forwarding_logic 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
    IF_ID_Rs : in std_ulogic_vector(4 downto 0);
    IF_ID_Rt : in std_ulogic_vector(4 downto 0);
    EX_MEM_Rd: in std_ulogic_vector(4 downto 0);
    MEM_WB_Rd : in std_ulogic_vector(4 downto 0);
    stall : in std_logic;
    forward_A : out std_ulogic_vector(1 downto 0);
	  forward_B : out std_ulogic_vector(1 downto 0);
	  forward_AD : out std_logic;
	  forward_BD : out std_logic
	);
end component;

component Early_branch_resolution
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		branchD,flush : in std_logic;
		isBNE   : in std_logic;
		A       : in signed(31 downto 0);
		B       : in signed(31 downto 0);
		imm     : in signed(31 downto 0);
		PC4     : in signed(31 downto 0);
		forward_A, forward_B : in std_ulogic_vector(1 downto 0);
		ALU_out : in signed(31 downto 0);
		branch : out std_logic;
		targetPC : out signed(31 downto 0)
	);
end component;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--------------------------------- MUX'S -----------------------------------

component MUX
	port (
		A, B: in signed(31 downto 0);
		Op	: in std_logic;
		R	: out signed(31 downto 0)
	);
end component;

component MUX_3to1 
	port (
		A,B,C	: in unsigned(31 downto 0);
		Op		: in std_ulogic_vector(1 downto 0);
		R		: out unsigned(31 downto 0)
	);
end component;

component MUX_4to1 
	port (
		A,B,C,D: in signed(31 downto 0);
		Op	: in std_ulogic_vector(1 downto 0);
		R	: out signed(31 downto 0)
	);
end component;

component MUX_5bit
	port (
		A,B	: in std_ulogic_vector(4 downto 0);
		Op	: in std_ulogic_vector(1 downto 0);
		R	: out std_ulogic_vector(4 downto 0)
	);
end component;

component MUX_unsigned
	port (
		A, B: in unsigned(31 downto 0);
		Op	: in std_logic;
		R	: out unsigned(31 downto 0)
	);
end component;

component MUX_3to1_signed
	port (
		A,B,C	: in signed(31 downto 0);
		Op		: in std_ulogic_vector(1 downto 0);
		R		: out signed(31 downto 0)
	);
end component;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
-------------------------------- CONTROLLERS ------------------------------

component OPCODE 
	port (
		clk 					: in std_logic;
		rst 					: in std_logic;
		OP_code					: in STD_LOGIC_VECTOR(5 downto 0); --we need both opcode (6 MSBs)
		funct					: in STD_LOGIC_VECTOR(5 downto 0); --and funct (6 LSBs) from instr to determine what we are actually executing
		ALU_op					: out unsigned(4 downto 0);
		R_type, I_type, J_type	: out std_logic 
	);
end component;

component FSM_control 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		MemReadReady, MemWriteDone	: in std_logic;
		op				: in std_ulogic_vector(5 downto 0);
		PCWriteCond, PCWriteCondN, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, Dump, Reset, InitMem,WordByte,IOMux	: out std_logic;
		PCSource, ALUSrcB, RegDst	: out std_ulogic_vector(1 downto 0);
		ALUOp				: out std_ulogic_vector(3 downto 0)
	);
end component;

component ALUControl 
	port (
		clk 					: in std_logic;
		rst 					: in std_logic;
		ALUOp					: in std_ulogic_vector(3 downto 0);
		Funct					: in std_ulogic_vector(5 downto 0);
		Op					: out std_ulogic_vector(5 downto 0)
	);
end component;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
----------------------------------- ALU'S ---------------------------------

component ALU
	port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		A, B		: in signed(31 downto 0);
		Op		: in std_ulogic_vector(5 downto 0);
		R		: out signed(31 downto 0);
		zero		: out std_logic
	);
end component;

component BranchAdder
	port (
		PC	      	: in signed(31 downto 0);
    Offset    	: in signed(31 downto 0);
		NPC       	: out signed(31 downto 0)
	);
end component;

component PC_add
	port (
		rst : in std_logic;
		PC	: in unsigned(31 downto 0);
		NPC : out unsigned(31 downto 0)
	);
end component;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------- OTHER ----------------------------------

component INSTR
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		IRwrite				: in std_logic;
		Ins					: in unsigned(31 downto 0);
		ins_out				:out std_ulogic_vector(31 downto 0)
	);
end component;

component SignExtender
  port (
    Immediate   : in signed(15 downto 0);
		Extended    : out signed(31 downto 0)
	);
end component;

component JumpShifter
  port (
		Unshifted   : in unsigned(25 downto 0);
		Shifted    	: out unsigned(27 downto 0)
	);
end component;

component REG
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		Rs, Rt, Rd			: in std_ulogic_vector(4 downto 0);
		WB_data				: in signed(31 downto 0);
		WB				: in std_logic;
		A,B				: out signed(31 downto 0)
	);
end component;

component Main_Memory
	  	generic (
			File_Address_Read : string :="Init.dat";
			File_Address_Write : string :="MemCon.dat";
			Mem_Size_in_Word : integer:=256;	
			Num_Bytes_in_Word: integer:=4;
			Num_Bits_in_Byte: integer := 8; 
			Read_Delay: integer:=0; 
			Write_Delay:integer:=0
		 );
	port (
			clk : in std_logic;
			address : in integer;
			Word_Byte: in std_logic; -- when '1' you are interacting with the memory in word otherwise in byte
			we : in std_logic;
			wr_done:out std_logic; --indicates that the write operation has been done.
			re :in std_logic;
			rd_ready: out std_logic; --indicates that the read data is ready at the output.
			data : inout std_logic_vector((Num_Bytes_in_Word*Num_Bits_in_Byte)-1 downto 0);        
			initialize: in std_logic;
			dump: in std_logic
		);
	end component;

---------------------------------------------------------------------------  
---------------------------------------------------------------------------  
---------------------------------------------------------------------------  
---------------------------------------------------------------------------  
-- not sure if we need: PCWriteCondN, IRWrite (assume not)
-- NO LONGER NEEDED: ALUSrcA,IorD
-- CHANGES: ALUSrcB from a 2 bit to a single signal
--          PCSource will be wired differently from before
-- PCWriteCond is now branch (the control)
-- PCWrite is not jump (the control)
-- RegDst seems to be different!!!!!!!!!!!!!!!!!!! (i dont know what it actually does in unpiped)
-- MemRead & MemWrite are sent through the pipeline (for store and loads , both 0 if not store and not load), basically does IorD job now (if either are 1)

--------------------------------------------------------------------------- 
---------------------------------SIGNALS-----------------------------------

----------------------------------- IF ------------------------------------
signal PC, PCF, PC4F: unsigned(31 downto 0);
signal instrF : std_ulogic_vector(31 downto 0);
signal to_jump_28: unsigned (27 downto 0); -- last 28 bits of the jump
signal to_jump : unsigned (31 downto 0); -- full for jump
signal choose_IorD :std_logic;
signal toMem : signed(31 downto 0);

----------------------------------- ID ------------------------------------
-- CONTROL
signal RegWriteD, MemtoRegD, MemWriteD, ALUSrcBD, jumpD, branchD, MemReadD,  
       DumpD, ResetD, InitMemD, WordByteD,	equalD: std_logic;
signal PCSourceD, RegDstD	: std_ulogic_vector(1 downto 0);
signal opD : std_ulogic_vector(5 downto 0);
-- DATA
signal AD1, BD1 :signed(31 downto 0);
signal AD2, BD2: signed(31 downto 0);
signal SignImmD : signed (31 downto 0);
-- REGISTER ADDRESS
signal InstrD : std_ulogic_vector(31 downto 0);
signal RsD, RtD, RdD : std_ulogic_vector(4 downto 0);
-- OTHER
signal PC4D : unsigned (31 downto 0); 
signal PCBranchD, to_branchadd : signed(31 downto 0);
signal dirtyD : std_logic;
signal to_flush : std_logic;
signal ALUOPD : std_ulogic_vector(3 downto 0);


----------------------------------- EX ------------------------------------
--CONTROL
-- -- branch, jump, PCsource are no longer here
signal RegWriteE, MemtoRegE, MemWriteE, ALUSrcBE, MemReadE,  
       DumpE, ResetE, InitMemE, WordByteE	: std_logic;
signal RegDstE	: std_ulogic_vector(1 downto 0);
signal opE : std_ulogic_vector(5 downto 0);
-- DATA
signal AE1, AE2, BE1, BE2, BE3, ALUE: signed(31 downto 0); -- BE2 is the one taken if address is given AKA WriteDataE
signal SignImmE : signed (31 downto 0);
-- REGISTER ADDRESS
signal RsE, RtE, RdE, WriteRegE : std_ulogic_vector(4 downto 0);

----------------------------------- MEM -----------------------------------
--CONTROL
-- -- Op, ALUsrc, RegDst no longer here
signal RegWriteM, MemtoRegM, MemWriteM, MemReadM,  
       DumpM, ResetM, InitMemM, WordByteM,	MemWriteMComp : std_logic;
-- DATA
signal ALUM, WriteDataM: signed(31 downto 0);
signal ReadDataM: std_logic_vector(31 downto 0);
-- REGISTER ADDRESS   
signal WriteRegM : std_ulogic_vector(4 downto 0);
    
----------------------------------- WB -----------------------------------
--CONTROL
-- -- MemWrite, MemRead, Dump, Reset, InitMem, WordByte no longer here
signal RegWriteW, MemtoRegW: std_logic;
-- DATA
signal ALUW: signed(31 downto 0);
signal ReadDataW : std_logic_vector(31 downto 0);
signal ResultW: signed(31 downto 0);
-- REGISTER ADDRESS
signal WriteRegW : std_ulogic_vector(4 downto 0);

----------------------- HAZARD AND FORWARD CTRL ---------------------------
signal StallF, StallD, ForwardAD, ForwardBD, FlushE: std_logic;
signal ForwardAE,ForwardBE : std_ulogic_vector(1 downto 0);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
------------------------------- End SIGNALS -------------------------------
---------------------------------------------------------------------------

begin
----------------------------------- IF ------------------------------------ 
-- actual instruction fetch handled in MEM
to_jump <= ((PC4D(31 downto 28)) & to_jump_28);
choose_IorD <= MemReadM or MemWriteM;

   MUX_PCsourceD : MUX_3to1
		port map(
			A => PC4F,
			B => unsigned(PCBranchD),
			C => to_jump,
			Op => PCsourceD,
			R => PC
	  );
		
	JS_jump : JumpShifter
		port map (
			Unshifted => unsigned(instrD (25 downto 0)),
			Shifted => to_jump_28
		);
		
	PC1 : SingleREG
		port map(
			clk => clk,
			rst =>rst_external,
			write_pc => choose_IorD,
			reg_in	=> PC,
			reg_out	=>PCF
		);
		
	PC_adder : PC_add
		port map(
			rst 	=> rst_external,
			PC		=> PCF,
			NPC 	=> 	pc4F
		);
	
	INSTR_OR_DATA_TO_ADDR: MUX
	port map(
		A => signed(PCF), 
		B => ALUM,
		Op	=> choose_IorD, --load or store, then dont read
		R	=> toMEM
	);
	
		
----------------------------------- ID ------------------------------------ 
PCsourceD <= jumpD & (branchD and equalD);

RsD <= instrD(25 downto 21);
RtD <= instrD(20 downto 16);
RdD <= instrD(15 downto 11);

EqualD <= '1' when AD2 = BD2 else '0';

to_flush <= PCSourceD(1) or PCSourceD(0);
to_branchADD <= shift_left(signimmD,2);

REG_IFID : Reg_IF_ID
	port map(
		clk => clk,
		rst => rst_external,
		stall => stallD, 
		dirtyF => stallD, 
		flush => to_flush,
    dirtyD => dirtyD,
    PC4F => PC4F,
    PC4D=> PC4D,
    instr => instrF,
	  instr_out => instrD
	);

regist :reg
		port map (clk => clk, 
			rst => rst_external, 
			Rs => instrD(25 downto 21), 
			Rt => instrD(20 downto 16),
			Rd => WriteRegW,             --double checl
			WB_data => ResultW,
			WB => RegWriteW,
			A => AD1,
			B => BD1
				
		);
		
sign : SignExtender
		port map (
			Immediate => signed(instrD(15 downto 0)),
			Extended => signImmD
		);
		
		
BA :BranchAdder
	port map(
		PC	=> to_branchADD,
    Offset => signed(PC4D),
		NPC  => PCBranchD
	);
	
MUX_ForwardAD : MUX
		port map(
			A => signed(AD1),
			B => ALUM,
			Op => forwardAD,
			R => AD2
		);
		
MUX_ForwardBD : MUX
		port map(
			A => signed(BD1),
			B => ALUM,
			Op => forwardBD,
			R => BD2
		);
		
FSMCONTROL: FSM_control
	port map (
		clk => clk,
		rst =>rst_external,		
		MemReadReady => '0', --currently no signals or thing for it
		MemWriteDone => '0', --currently no signals or thing for it
		op	=> opD,
		PCWriteCond => branchd, 
		PCWriteCondN => open, 
		PCWrite => jumpD, 
		IorD => open, 
		MemRead => MemReadD, 
		MemWrite=> MemWriteD, 
		MemtoReg=> MemtoRegD, 
		IRWrite=> open, 
		ALUSrcA=> open, 
		RegWrite=> RegWriteD, 
		Dump=> DumpD, 
		Reset=> ResetD, 
		InitMem=> InitMemD,
		WordByte=> WordByteD,
		IOMux => open,
		PCSource=> open, 
		ALUSrcB=> open,--ALUSrcBD, this has incorrect bits so it doesnt work 
		RegDst=> RegDstD,
		ALUOp=> ALUopD
	);

ALUCONTR : ALUControl 
	port map(
		clk => clk,
		rst => rst_external,
		ALUOp	=>ALUOPD,
		Funct	=> instrD(5 downto 0),
		Op	=>OpD
	);



----------------------------------- EX ------------------------------------

REG_IDEX : Reg_ID_EX
	port map(
		clk => clk,
		rst =>rst_external,
    AD =>AD1,
	  BD => BD1,
	  RsD => RsD,
	  RtD => RtD,
	  RdD => RdD,
	  PCWriteCondD=>'0', 
	  PCWriteCondND=>'0', 
	  PCWriteD=>'0', 
	  IorDD=>'0', 
	  MemReadD=>MemReadD, 
	  MemWriteD=>MemWriteD, 
	  MemtoRegD=>MemtoRegD, 
	  IRWriteD=>'0', 
	  ALUSrcAD=>'0', 
	  RegWriteD=>RegWriteD, 
	  DumpD=>DumpD, 
	  ResetD=>ResetD, 
	  InitMemD=>InitMemD,
	  WordByteD=>WordByteD,
		PCSourceD=>"00", 
		ALUSrcBD=>ALUSrcBD, 
		RegDstD	=> RegDstD,
	  PCWriteCondE=>open, 
	  PCWriteCondNE=>open, 
	  PCWriteE=>open, 
	  IorDE=>open, 
	  MemReadE=>MemReadE, 
	  MemWriteE=>MemWriteE, 
	  MemtoRegE=>MemtoRegE, 
	  IRWriteE=>open, 
	  ALUSrcAE=>open, 
	  RegWriteE=>RegWriteE, 
	  DumpE=>DumpE, 
	  ResetE=>ResetE, 
	  InitMemE=>InitMemE,
	  WordByteE=>WordByteE,
		PCSourceE=>open, 
		ALUSrcBE=>ALUSrcBE, 
		RegDstE=>	RegDstE,
	  RsE=> RsE,
	  RtE=> RtE,
	  RdE=> RdE,	  
	  AE=>  AE1,
	  BE=>  BE1,
	  flush=> flushE,
	  opD=> opD,
	  opE=>opE
	);
	
	MUX_regdstE : MUX_5bit
		port map(
			A => RtE,
			B => RdE,
			Op => regdste,
			R => writeregE
		);
	
	MUX_forwardAE : MUX_3to1_signed
		port map(
			A => AE1,
			B => resultW,
			C => ALUM,
			Op => forwardAE,
			R => AE2
		);  
		
		MUX_forwardBE : MUX_3to1_signed
		port map(
			A => BE1,
			B => resultW,
			C => ALUM,
			Op => forwardBE,
			R => BE2
		); 
		
	AUSrcE_MUX: MUX
	port map(
		A => BE2, 
		B => SignImmE,
		Op	=>ALUSrcBE,
		R	=> BE3
	);
	
	myALU:ALU  
    port map (
		  clk =>clk,
		  rst =>rst_external,
		  A => AE2, B => BE3,
		  Op	=>opE,
		  R		=> ALUE,
		  zero	=>open
	 );		


----------------------------------- MEM -----------------------------------
  memWriteMComp <= not memWriteM;
  REG_EXMEM: Reg_EX_MEM
  port map (
		clk => clk,
		rst => rst_external,
		ALUE =>ALUE,
		ALUM =>ALUM,
	  RdtE => WriteRegE,
		RdtM => WriteRegM,
    MemReadE =>MemReadE, MemWriteE =>MemWriteE, MemtoRegE=>MemtoRegE,RegWriteE=>RegWriteE, DumpE=>DumpE, ResetE=>ResetE, InitMemE =>InitMemE,WordByteE=>WordByteE,
	  MemReadM =>MemReadM, MemWriteM=>MemWriteM, MemtoRegM=>MemtoRegM,RegWriteM=>RegWriteM, DumpM=>DumpM, ResetM=>ResetM, InitMemM=>InitMemM,WordByteM=>WordByteM
	);
  
  Mainmemory: MAIN_Memory
  port map (
    clk => clk,
	  address => to_integer(toMEM),
	  Word_Byte=>WordByteM, -- when '1' you are interacting with the memory in word otherwise in byte
	  we => memWriteM,
	  wr_done => open, --indicates that the write operation has been done.
	  re => memWriteMComp,
		rd_ready=> open, --indicates that the read data is ready at the output.
		data =>ReadDataM,       
		initialize=>initMemM,
		dump=>dumpM
	);			     
       
----------------------------------- WB -----------------------------------

  REG_MEMWB:Reg_MEM_WB
  port map(
		clk =>clk,
		rst => rst_external,
		ALUM => ALUM, 
		MEMM => ReadDataM,
		ALUW => ALUW, 
		MEMW => ReadDataW,
		RdtM => WriteRegM,
		RdtW => WriteRegW,
		MemtoRegM => MemtoRegM, 
		RegWriteM	=> RegWriteM,
	  MemtoRegW => MemtoRegW, 
	  RegWriteW	=>RegWriteW
	);
	
	MEMtoREGW_MUX: MUX
	port map(
		A => ALUW, 
		B => signed(readDataW),
		Op	=>MemtoRegW,
		R	=> ResultW
	);
--------------------------------------Forwarding Unit----------------------------------------
Forward:  Forwarding_logic 
	port map (
		clk => clk,
		rst => rst_external,
    IF_ID_Rs => RsD,
    IF_ID_Rt => RtD,
    EX_MEM_Rd => writeRegE,
    MEM_WB_Rd => WriteRegM,
    stall => stallD, -- we are missing a stall signal that propagates through the pipeline registers
    forward_A => forwardAE,
	  forward_B  => forwardBE,
	  forward_AD => forwardAD,
	  forward_BD => forwardBD
	);

------------------------------ Hazard_control--------------------------------
Hazard: Hazard_control
	port map (
		clk => clk,
		rst => rst_external,
		ID_EX_Rd => RdE,
    IF_ID_Rs => RsD,
    IF_ID_Rt => RtD,
    ID_EX_MemRead =>MemtoRegE,
    stall => stallD
	);



end architecture RTL;
