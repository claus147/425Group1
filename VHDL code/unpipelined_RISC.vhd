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
	signal MUX_J_B_out		: std_ulogic_vector (31 downto 0);
	signal next_PC_out		: std_ulogic_vector (31 downto 0);
	signal A			: std_ulogic_vector (31 downto 0);
	signal B			: std_ulogic_vector (31 downto 0);
	signal ALU_in_A: std_ulogic_vector (31 downto 0);
	signal ALU_in_B: std_ulogic_vector (31 downto 0);
	signal reg_out_B		: std_ulogic_vector (31 downto 0);
	signal MUX_reg_addr_out		: std_ulogic_vector (31 downto 0);
	signal MUX_reg_data_out		: std_ulogic_vector (31 downto 0);
	signal ALU_control_out	: std_ulogic_vector (31 downto 0);
	signal ALU_out			: std_ulogic_vector (31 downto 0);
	signal ALU_out_out		: std_ulogic_vector (31 downto 0);
	signal MUX_mem_out		: std_ulogic_vector (31 downto 0);
	signal mem_out			: std_ulogic_vector (31 downto 0);
	signal mem_reg_out		: std_ulogic_vector (31 downto 0);
	signal sign_extend_out	: std_ulogic_vector (31 downto 0);
	signal ALU_zero			:std_logic;
	

	signal PC_write_cond_c 	:std_logic;
	signal PC_write_c 		:std_logic;
	signal I_or_D_c			:std_logic;
	signal mem_read_c 		:std_logic;
	signal mem_write_c		:std_logic;
	signal mem_to_reg_c 	:std_logic;
	signal IR_write_c		:std_logic;
	signal PC_source_c		:std_logic_vector(1 downto 0);
	signal ALU_op_c			:std_ulogic_vector(5 downto 0);
	signal ALU_src_A_c 		:std_logic;
	signal ALU_src_B_c 		:std_logic_vector(1 downto 0);
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
			A, B: in signed(31 downto 0);
			Op	: in std_logic;
			R	: out signed(31 downto 0)
		);
	end component;	
	
	component MUX_3to1
		port (
			A,B,C: in signed(31 downto 0);
			Op	: in std_ulogic_vector(1 downto 0);
			R	: out signed(31 downto 0)
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
			A,B: in signed(4 downto 0);
			Op	: in std_logic;
			R	: out signed(4 downto 0)
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
	
	component SingleREG is
		port (
			clk 				: in std_logic;
			rst 				: in std_logic;
			reg_in				: in unsigned(31 downto 0);
			reg_out				: out unsigned(31 downto 0)
		);
	end component;
	-----------------------------------------BEGIN--------------------------------------------
	begin
		PC : SingleREG
		port map ( clk => (ALU_zero & PC_write_cond_c)|PC_write_c,
			rst => rst,
			reg_in => MUX_J_B_out,
			reg_out => PC_out
		);
		
		mem_data_reg : SingleREG
		port map ( clk => clk,
			rst => rst,
			reg_in => mem_out,
			reg_out => mem_reg_out
		);
		
		A : SingleREG
		port map ( clk => clk,
			rst => rst,
			reg_in => ALU_in_A,
			reg_out => PC_out
		);		
		
		B : SingleREG
		port map ( clk => clk,
			rst => rst,
			reg_in => MUX_J_B_out,
			reg_out => PC_out
		);		
		
		ALU_out_REG : SingleREG
		port map ( clk => clk,
			rst => rst,
			reg_in => MUX_J_B_out,
			reg_out => PC_out
		);
		
		MUX_reg_addr : MUX_5bit
		port (
			A => instruction(20 downto 16),
			B => instruction(15 downto 11),
			Op => reg_dst_c,
			R => MUX_reg_addr_out	
		);
		
		MUX_reg_data : MUX
		port (
			A => MUX_mem_out,
			B => mem_out,
			Op => mem_to_reg_c,
			R => MUX_reg_data_out	
		);
		
		MUX_A : MUX
		port (
			A => PC_out,
			B => A,
			Op => ALU_src_A_c,
			R => ALU_in_A	
		);
		
		MUX_B : MUX_4to1
		port (
			A => B,
			B => x"4",
			C => sign_extend_out,
			D => sign_extend_out << 2,
			Op => ALU_src_B_c,
			R => ALU_in_B	
		);
		
		MUX_J_B : MUX_3to1
		port (
			A => ALU_out,
			B => ALU_out
			C => (instruction(25 downto 0)<<2) & PC_out(31 downto 28),
			Op => PC_source_c,
			R => MUX_J_B_out	
		);
		
		mem : Main_memory
		port (
			clk => clk,
			address => B,
			Word_Byte => '0',
			we => mem_write_c,
			wr_done => '0',	
			re => mem_read_c,
			rd_ready => '0',
			data => mem_out,     
			initialize => '0',
			dump => '0'
		);
		
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
		
		instr :INSTR
		port (
			clk => clk,
			rst => rst,
			Ins	=> mem_out,
			ins_out => 
		);
		
		regist :reg
		port map (clk => clk, 
			rst => rst, 
			Rs => instruction(25 downto 21), 
			Rt => instruction(20 downto 16),
			Rd => MUX_reg_addr_out,
			WB_data => MUX_reg_data_out,
			WB => reg_write_c,
			A => A,
			B => B
				
		);

		ALU : ALU
		port (
			clk => clk,
			rst => rst,
			A => ALU_in_A,
			B => ALU_in_B,
			Op	=> ALU_control_out,
			R => ALU_out,
			zero => ALU_zero
		);
		
		ALU_control : ALUControl
		port (
			clk => clk,
			rst => rst,
			ALUOp =>ALU_op_c,
			Funct => instruction (5 downto 0),
			Op => ALU_control_out
		);
		
		sign : SignExtender
		port map (clk => clk, 
			rst => rst, 
			Immediate => signed(instruction(15 downto 0)),
			Extended => signed(sign_extend_out)
		);
		
		

end architecture RTL;
