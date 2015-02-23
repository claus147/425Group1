----------------------------------------------------------------------------------------
-- This module is used to combine individual components 
-- This module takes as input a series of instructions stored in the Instruction Memory
-- The unpipelined RISC processor is composed of:
-- 		- PC					26-bit address initialized to 0x0		
--		- 32-bit registers		R0 wired to 0x0000						SETUP need a table that maps address to data
--		- IR					breakdown the instruction				SETUP
--		- ALU															IN PROGRESS
--		- Multiplexers			4 32-bit MUX							DONE!
--		- Adder					increment PC							DONE!
--		- Control module		translate opcode to control bits		SETUP
--
-- The results of this module is stored in Data Memory
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unpipelined_RISC is
	port (
		clk 			: in std_logic;
		rst 			: in std_logic
	);
end entity unpipelined_RISC;

architecture RTL of unpipelined_RISC is
	
signal instruction 		: std_ulogic_vector (31 downto 0);
signal PC_out			: std_ulogic_vector (31 downto 0);
signal MUX_J_out		: std_ulogic_vector (31 downto 0);
signal MUX_B_out		: std_ulogic_vector (31 downto 0);
signal next_PC_out		: std_ulogic_vector (31 downto 0);
signal ALU_branch_out	: std_ulogic_vector (31 downto 0);
signal ALU_in_A			: std_ulogic_vector (31 downto 0);
signal ALU_in_B			: std_ulogic_vector (31 downto 0);
signal reg_out_B		: std_ulogic_vector (31 downto 0);
signal MUX_reg_out		: std_ulogic_vector (31 downto 0);
signal ALU_control_out	: std_ulogic_vector (31 downto 0);
signal ALU_out			: std_ulogic_vector (31 downto 0);
signal Mux_data_out		: std_ulogic_vector (31 downto 0);
signal sign_extend_out	: std_ulogic_vector (31 downto 0);

signal reg_dst_c 		:std_logic;
signal jump_c 			:std_logic;
signal branch_c 		:std_logic;
signal mem_read_c 		:std_logic;
signal mem_to_reg_c 	:std_logic;
signal ALU_op_c			:std_ulogic_vector(5 downto 0);
signal mem_write_c		:std_logic;
signal ALU_src_c 		:std_logic;
signal reg_write_c 		:std_logic;

component ALU
	port (
		clk 			: in std_logic;
		rst 			: in std_logic;
		A, B			: in signed(31 downto 0);
		Op				: in unsigned(4 downto 0);
		R				: out signed(31 downto 0);
		C_out			: out std_logic
	);
end component;

component ALUControl 
	port (
		clk 			: in std_logic;
		rst 			: in std_logic;
		ALUOp			: in unsigned(3 downto 0);
		Funct			: in unsigned(5 downto 0);
		Op				: out unsigned(5 downto 0)
	);
end component;	

component BranchAdder
	port (
		clk       		: in std_logic;
		rst				: in std_logic;
		PC	      		: in signed(31 downto 0);
        Offset    		: in signed(31 downto 0);
		NPC       		: out signed(31 downto 0)
	);
end component;	

component Control 
	port (
		clk 			: in std_logic;
		rst 			: in std_logic;
	    Opcode          : in std_logic_vector(5 downto 0);
	    RegDst          : out std_logic;
	    Jump            : out std_logic;
	    Branch          : out std_logic;
	    MemRead         : out std_logic;
	    MemToReg        : out std_logic;
	    ALUOp			: out std_logic_vector(3 downto 0);
	    MemWrite        : out std_logic;
	    ALUSrc          : out std_logic;
		RegWrite        : out std_logic
	);
end component;

component INSTR
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		Ins					: in unsigned(31 downto 0);
		Op_code, Funct		: out unsigned(5 downto 0);
		Rs, Rt, Rd, Shamt	: out unsigned(4 downto 0);
		Imm					: out unsigned(15 downto 0);
		Addr				: out unsigned(25 downto 0)
	);
end component;

component JumpShifter 
  port (
		clk         	: in std_logic;
		rst				: in std_logic;
		Unshifted   	: in signed(25 downto 0);
		Shifted    		: out signed(27 downto 0)
	);
end component;
	
component MUX 
	port (
		clk : in std_logic;
		rst : in std_logic;
		A, B: in signed(31 downto 0);
		Op	: in std_logic;
		R	: out signed(31 downto 0)
	);
end component;	

component PC_add 
	port (
		clk : in std_logic;
		rst : in std_logic;
		PC	: in unsigned(25 downto 0);
		NPC : out unsigned(25 downto 0)
	);
end component;

component REG 
	port (
		clk 			: in std_logic;
		rst 			: in std_logic;
		Rs, Rt, Rd		: in std_ulogic_vector(4 downto 0);
		WB_data			: in std_ulogic_vector(31 downto 0);
		WB				: in std_logic;
		A,B				: out std_ulogic_vector(31 downto 0)
	);
end component;

component SignExtender 
  	port (
		clk         	: in std_logic;
		rst		      	: in std_logic;
		Immediate  	 	: in signed(15 downto 0);
		Extended    	: out signed(31 downto 0)
	);
end component;

begin

end architecture RTL;
