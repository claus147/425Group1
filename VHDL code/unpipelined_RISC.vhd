----------------------------------------------------------------------------------------
-- This module is used to combine individual components 
-- This module takes as input a series of instructions stored in the Instruction Memory
-- The unpipelined RISC processor is composed of:
-- 		- PC					26-bit address initialized to 0x0		
--		- 32-bit registers		R0 wired to 0x0000						
--		- IR					breakdown the instruction															
--		- ALU					arithmetic logic unit
--		- ALUControl			translate ALU opcode and funct for ALU
--		- BranchAdder			adder for branch
--		- FSM_control			translate opcode to control bits
--		- INSTR					breakdown the instruction	
--		- JumpShifter			to shift and concatenate the address for jump address
--		- MUX_unsigned			unsigned 2 to 1 mux
--		- MUX					signed 2 to 1 mux
--		- MUX_3to1				unsigned 3 to 1 mux
--		- MUX_4to1				signed 4 to 1 mux
--		- MUX_5bit				std_ulogic_vector 2 to 1 mux (5 bit)
--		- PC_add				increment PC
--		- REG					32-bit registers (R0 wired to 0x0000)	
--		- SignExtender			extends the value from 16 bit to 32 bit with the sign
--		- Main_Memory			Main memory module that stores the 
--		- SingleREG				register to hold a single value
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
		rst_external 	: in std_logic
	);
end entity unpipelined_RISC;

architecture RTL of unpipelined_RISC is
	
	signal rst 				: std_logic;
	signal instruction 		: std_ulogic_vector (31 downto 0);
	signal PC_out			: unsigned (31 downto 0);
	signal MUX_J_B_out		: unsigned (31 downto 0);
	signal A				: signed (31 downto 0);
	signal B				: signed (31 downto 0);
	signal ALU_in_A			: signed(31 downto 0);
	signal ALU_in_B			: signed(31 downto 0);
	signal reg_out_B		: std_ulogic_vector (31 downto 0);
	signal MUX_reg_addr_out	: std_ulogic_vector (4 downto 0);
	signal MUX_reg_data_out	: signed (31 downto 0);
	signal ALU_control_out	: std_ulogic_vector (5 downto 0);
	signal ALU_out			: signed (31 downto 0);
	signal mem_out			: std_logic_vector (31 downto 0);
	signal sign_extend_out	: signed (31 downto 0);
	signal ALU_zero			: std_logic;
	signal shift_j_out		: unsigned (27 downto 0);
	signal MUX_J_B_in		: unsigned (31 downto 0);
	signal MUX_PC_out		: unsigned (31 downto 0);
	signal sign_extend_out_shifted : signed (31 downto 0);

	signal PC_write_cond_c 	:std_logic;
	signal PC_write_c 		:std_logic;
	signal I_or_D_c			:std_logic;
	signal mem_read_c 		:std_logic;
	signal mem_write_c		:std_logic;
	signal mem_to_reg_c 	:std_logic;
	signal IR_write_c		:std_logic;
	signal PC_source_c		:std_ulogic_vector(1 downto 0);
	signal ALU_op_c			:std_ulogic_vector(3 downto 0);
	signal ALU_src_A_c 		:std_logic;
	signal ALU_src_B_c 		:std_ulogic_vector(1 downto 0);
	signal reg_write_c 		:std_logic;
	signal reg_dst_c 		:std_ulogic_vector(1 downto 0);
	
	signal PC_Write_Cond_N_c :std_logic;
	
	signal word_byte 		:std_logic;
	signal wr_done	 		:std_logic;
	signal rd_ready			:std_logic;
	signal initialize		:std_logic;
	signal dump 			:std_logic;
	
	signal write_pc			:std_logic;
	signal pc_next :  unsigned (31 downto 0);
	signal IO_mux_out  :unsigned(31 downto 0);

	
	component ALU
		port (
			clk 			: in std_logic;
			rst 			: in std_logic;
			A, B			: in signed(31 downto 0);
			Op				: in std_ulogic_vector(5 downto 0);
			R				: out signed(31 downto 0);
			zero			: out std_logic
		);
	end component;
	
	component IO_MUX
	  port ( 
	    dat  	: in signed(31 downto 0);
		  sel   : in std_logic;
		  inst  : out unsigned(31 downto 0);
		  memIO : inout std_logic_vector(31 downto 0)
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
	
	component FSM_control
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		MemReadReady, MemWriteDone	: in std_logic;
		op					: in std_ulogic_vector(5 downto 0);
		PCWriteCond, PCWriteCondN, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, Dump, Reset, InitMem,WordByte	: out std_logic;
		PCSource, ALUSrcB, RegDst	: out std_ulogic_vector(1 downto 0);
		ALUOp				: out std_ulogic_vector(3 downto 0)
	);
	end component;
	
	component INSTR
		port (
			clk 				: in std_logic;
			rst 				: in std_logic;
			IRwrite				: in std_logic;
			Ins					: in unsigned(31 downto 0);
			ins_out				:out std_ulogic_vector(31 downto 0)
		);
	end component;
	
	component JumpShifter 
	  port (
			Unshifted   	: in unsigned(25 downto 0);
			Shifted    		: out unsigned(27 downto 0)
		);
	end component;
	
	component MUX_unsigned 
		port (
			A, B: in unsigned(31 downto 0);
			Op	: in std_logic;
			R	: out unsigned(31 downto 0)
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
			A,B,C: in unsigned(31 downto 0);
			Op	: in std_ulogic_vector(1 downto 0);
			R	: out unsigned(31 downto 0)
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
	
	component PC_add 
		port (
			clk 	: in std_logic;
			rst 	: in std_logic;
			PC		: in unsigned(31 downto 0);
			NPC 	: out unsigned(31 downto 0)
		);
	end component;
	
	component REG 
		port (
			clk 						: in std_logic;
			rst 						: in std_logic;
			Rs, Rt, Rd					: in std_ulogic_vector(4 downto 0);
			WB_data						: in signed(31 downto 0);
			WB							: in std_logic;
			A,B							: out signed(31 downto 0)
		);
	end component;
	
	component SignExtender 
	  	port (
			Immediate  	 	: in signed(15 downto 0);
			Extended    	: out signed(31 downto 0)
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
			write_pc			: in std_logic;
			reg_in				: in unsigned(31 downto 0);
			reg_out				: out unsigned(31 downto 0)
		);
	end component;
	
	-----------------------------------------BEGIN--------------------------------------------
	begin
		write_pc <= PC_write_c or ((pc_write_cond_c and not PC_write_cond_N_c and ALU_zero) or (not PC_write_cond_C and PC_write_cond_N_c and not ALU_zero));
		MUX_J_B_in <= PC_out(31 downto 28) & shift_j_out;
		sign_extend_out_shifted <= shift_left(sign_extend_out,2);
		
		PC1 : SingleREG
		port map(
			clk => clk,
			rst =>rst_external,
			write_pc => write_pc,
			reg_in	=> MUX_J_B_out,
			reg_out	=>PC_out
		);
		
		IO_mux1 : IO_MUX
		port map(			
			dat  	=> B,
		  sel   => mem_write_c,
		  inst  => IO_mux_out,
		  memIO => mem_out
		);
		
		MUX_pc : MUX_unsigned
		port map(			
			A => PC_out,
			B => unsigned(ALU_out),
			Op => I_or_D_c,
			R => MUX_pc_out	
		);
		
		PC_adder : PC_add
		port map(			
			clk 	=> clk,
			rst 	=> rst,
			PC		=> PC_out,
			NPC 	=> 	pc_next
		);
		
		MUX_reg_addr : MUX_5bit
		port map (
			A => instruction(20 downto 16),
			B => instruction(15 downto 11),
			Op => reg_dst_c,
			R => MUX_reg_addr_out	
		);
		
		MUX_reg_data : MUX
		port map (
			A => signed(ALU_out),
			B => signed(mem_out),
			Op => mem_to_reg_c,
			R => MUX_reg_data_out	
		);
		
		MUX_A : MUX
		port map(
			A => signed(PC_out),
			B => signed(A),
			Op => ALU_src_A_c,
			R => ALU_in_A	
		);
		
		MUX_B : MUX_4to1
		port map (
			A => signed(B),
			B => to_signed(4,32),
			C => signed(sign_extend_out),
			D => sign_extend_out_shifted,
			Op => ALU_src_B_c,
			R => ALU_in_B	
		);
		
		MUX_J_B : MUX_3to1
		port map(
			A => pc_next,
			B => unsigned(ALU_out),
			C => unsigned(MUX_J_B_in),
			Op => PC_source_c,
			R => MUX_J_B_out	
		);
		
		mem : Main_memory
		port map(
			clk => clk,
			address => to_integer(MUX_PC_out),
			Word_Byte => word_byte,
			we => mem_write_c,
			wr_done => wr_done,	
			re => mem_read_c,
			rd_ready => rd_ready,
			data => mem_out,     
			initialize => initialize,
			dump => dump
		);
		
		controler :FSM_control
		port map(
			clk =>clk,
			rst=>rst_external,
			MemReadReady =>rd_ready, 
			MemWriteDone =>wr_done,
			op => instruction (31 downto 26),
			PCWriteCond =>PC_write_cond_c, 
			PCWriteCondN =>PC_Write_Cond_N_c, 
			PCWrite =>PC_write_c, 
			IorD => I_or_D_c, 
			MemRead => mem_read_c, 
			MemWrite => mem_write_c, 
			MemtoReg => mem_to_reg_c, 
			IRWrite => IR_write_c, 
			ALUSrcA => ALU_src_A_c, 
			RegWrite =>reg_write_c, 
			Dump => dump, 
			Reset => rst, 
			InitMem => initialize,
			WordByte => word_byte,
			PCSource => PC_source_c, 
			ALUSrcB => ALU_src_B_c, 
			RegDst	=> reg_dst_c,
			ALUOp =>ALU_op_c
		);
		
		instruct :INSTR
		port map(
			clk => clk,
			rst => rst,
			IRwrite => IR_write_c,
			Ins	=> IO_mux_out,
			ins_out => instruction
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

		ALU1 : ALU
		port map(
			clk => clk,
			rst => rst_external,
			A => ALU_in_A,
			B => ALU_in_B,
			Op	=> ALU_control_out,
			R => ALU_out,
			zero => ALU_zero
		);
		
		ALU_control : ALUControl
		port map(
			clk => clk,
			rst => rst,
			ALUOp =>ALU_op_c,
			Funct => instruction (5 downto 0),
			Op => ALU_control_out
		);
		
		sign : SignExtender
		port map (
			Immediate => signed(instruction(15 downto 0)),
			Extended => sign_extend_out
		);
		
		shift_j : JumpShifter
		port map (
			--clk         	: in std_logic;
			--rst		: in std_logic;
			Unshifted => unsigned(instruction (25 downto 0)),
			Shifted => shift_j_out
		);
		

end architecture RTL;


