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
		rst 			: in std_logic;
		PC				: in std_logic
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
	

	signal PC_write_cond_c 	:std_logic;
	signal PC_write_c 		:std_logic;
	signal I_or_D_c			:std_logic;
	signal mem_read_c 		:std_logic;
	signal mem_write_c		:std_logic;
	signal mem_to_reg_c 	:std_logic;
	signal IR_write_c		:std_logic;
	signal PC_souce_c		:std_logic;
	signal ALU_op_c			:std_ulogic_vector(5 downto 0);
	signal ALU_src_A_c 		:std_logic;
	signal ALU_src_B_c 		:std_logic;
	signal reg_write_c 		:std_logic;
	signal reg_dst_c 		:std_logic;
	
	
	component ALU
		port (
			clk 			: in std_logic;
			rst 			: in std_logic;
			A, B			: in signed(31 downto 0);
			Op			: in std_ulogic_vector(5 downto 0);
			R			: out signed(31 downto 0);
			zero			: out std_logic
		);
	end component;
	
	component ALUControl 
		port (
			clk 			: in std_logic;
			rst 			: in std_logic;
			ALUOp			: in std_ulogic_vector(3 downto 0);
			Funct			: in std_ulogic_vector(5 downto 0);
			Op			: out std_ulogic_vector(5 downto 0)
		);
	end component;	
	
	component BranchAdder
		port (
			PC	      		: in signed(31 downto 0);
	        	Offset    		: in signed(31 downto 0);
			NPC       		: out signed(31 downto 0)
		);
	end component;	
	
	component Control 
		port (
			clk 			: in std_logic;
			rst 			: in std_logic;
		    Opcode          : in std_ulogic_vector(5 downto 0);
		    
		    RegDst          : out std_logic;
		    Jump            : out std_logic;
		    Branch          : out std_logic;
		    MemRead         : out std_logic;
		    MemToReg        : out std_logic;
		    ALUOp			: out std_ulogic_vector(3 downto 0);
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
			Unshifted   	: in signed(25 downto 0);
			Shifted    	: out signed(27 downto 0)
		);
	end component;
		
	component MUX 
		port (
			clk 	: in std_logic;
			rst 	: in std_logic;
			A, B	: in signed(31 downto 0);
			Op	: in std_logic;
			R	: out signed(31 downto 0)
		);
	end component;	
	
	component PC_add 
		port (
			clk 	: in std_logic;
			rst 	: in std_logic;
			PC	: in unsigned(25 downto 0);
			NPC 	: out unsigned(25 downto 0)
		);
	end component;
	
	component REG 
		port (
			clk 			: in std_logic;
			rst 			: in std_logic;
			Rs, Rt, Rd		: in std_ulogic_vector(4 downto 0);
			WB_data			: in std_ulogic_vector(31 downto 0);
			WB			: in std_logic;
			A,B			: out std_ulogic_vector(31 downto 0)
		);
	end component;
	
	component SignExtender 
	  	port (
			Immediate  	 	: in signed(15 downto 0);
			Extended    		: out signed(31 downto 0)
		);
	end component;
	
	component Main_Memory
	  	port (
			clk 		: in std_logic;
			address 	: in integer;
			Word_Byte	: in std_logic; -- when '1' you are interacting with the memory in word otherwise in byte
			we 			: in std_logic;
			wr_done		: out std_logic; --indicates that the write operation has been done.
			re 			: in std_logic;
			rd_ready	: out std_logic; --indicates that the read data is ready at the output.
			data 		: inout std_logic_vector((Num_Bytes_in_Word*Num_Bits_in_Byte)-1 downto 0);        
			initialize	: in std_logic;
			dump		: in std_logic
		);
	end component;
	-----------------------------------------BEGIN--------------------------------------------
	begin
		controler :control --will need to change, not updated
		port map( clk => clk,			
			rst => rst,			
		    Opcode => instruction(31 downto26),        
		    RegDst => reg_dst_c,
		    Jump => jump_c,
		    Branch => branch_c,
		    MemRead => mem_read_c,
		    MemToReg => mem_to_reg_c,
		    ALUOp => ALU_op_c,
		    MemWrite => mem_write_c,
		    ALUSrc => ALU_src,
		    RegWrite =>reg_write_c
		);
		
		regist :reg
		port map (clk => clk, 
			rst => rst, 
			Rs => instruction(25 downto 21), 
			Rt => instruction(20 downto 16),
			Rd => MUX_reg_out,
			WB_data => MUX_data_out,
			WB => reg_write_c,
			A => ALU_in_A,
			B => ALU_in_B
				
		);
		
		sign : SignExtender
		port map (clk => clk, 
			rst => rst, 
			Immediate => signed(instruction(15 downto 0)),
			Extended => signed(sign_extend_out)
		);
		
		
		
		--convert : g35_binary_to_BCD
		--port map ( clock => clock, bin => unsigned_bin, BCD => conversion_memory);
		

end architecture RTL;
