---------------------------------------------------------------------------
-- Pipelined implementation - Phase 2
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------------------------
entity Reg_IF_ID is
	port (
		clk 			: in std_logic;
		rst_external 	: in std_logic
	);
end entity Reg_IF_ID;

---------------------------------------------------------------------------
architecture RTL of Reg_IF_ID is


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

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------- PIPELINE REGISTERS ---------------------------

component SingleREG -- Reg_IF
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
		stall, dirtyF   :in std_logic;
    dirtyD   :out std_logic;
    instr : in std_ulogic_vector(31 downto 0);
	  instr_out : out std_ulogic_vector(31 downto 0)
	);
end component;

component Reg_ID_EX
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
    AD      : in std_ulogic_vector(31 downto 0);
	  BD      : in std_ulogic_vector(31 downto 0);
	  RsD     : in std_ulogic_vector(4 downto 0);
	  RtD     : in std_ulogic_vector(4 downto 0);
	  RdD     : in std_ulogic_vector(4 downto 0);
	  PCWriteCondD, PCWriteCondND, PCWriteD, IorDD, MemReadD, MemWriteD, MemtoRegD, IRWriteD, ALUSrcAD, RegWriteD, DumpD, ResetD, InitMemD,WordByteD	: in std_logic;
		PCSourceD, ALUSrcBD, RegDstD	: in std_ulogic_vector(1 downto 0);
	  PCWriteCondE, PCWriteCondNE, PCWriteE, IorDE, MemReadE, MemWriteE, MemtoRegE, IRWriteE, ALUSrcAE, RegWriteE, DumpE, ResetE, InitMemE,WordByteE	: out std_logic;
		PCSourceE, ALUSrcBE, RegDstE	: out std_ulogic_vector(1 downto 0);
	  RsE : out std_ulogic_vector(4 downto 0);
	  RtE : out std_ulogic_vector(4 downto 0);
	  RdE : out std_ulogic_vector(4 downto 0);	  
	  AE  : out std_ulogic_vector(31 downto 0);
	  BE  : out std_ulogic_vector(31 downto 0);
	  flush  : in std_logic
	);
end component;

component Reg_EX_MEM 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUE    : in signed(31 downto 0);
		ALUM    : out signed(31 downto 0);
	  RdtE    : in signed(4 downto 0);
		RdtM    : out signed(4 downto 0);
    MemReadE, MemWriteE, MemtoRegE,RegWriteE, DumpE, ResetE, InitMemE,WordByteE	: in std_logic;
	  MemReadM, MemWriteM, MemtoRegM,RegWriteM, DumpM, ResetM, InitMemM,WordByteM	: out std_logic
	);
end component;

component Reg_MEM_WB 
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUM, MEMM    : in signed(31 downto 0);
		ALUW, MEMW    : out signed(31 downto 0);
		RdtM    : in signed(4 downto 0);
		RdtW    : out signed(4 downto 0);
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
	  forward_B : out std_ulogic_vector(1 downto 0)
	);
end component;

component Early_branch_resolution
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		branchD : in std_logic;
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
		PCWriteCond, PCWriteCondN, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, Dump, Reset, InitMem,WordByte	: out std_logic;
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
		clk : in std_logic;
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


---------------------------------------------------------------------------  
begin


end architecture RTL;
