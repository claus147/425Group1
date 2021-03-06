----------------------------------------------------------------------------------------
-- This module is used to implement a FSM to control the overall processor
-- 
-- Inputs:
--	- op		6-bit operand used to control states
-- 
-- Output:
-- 	- Series of control signals used for different modules
--
-- Control:
-- 	- MemReadReady	to know when memory is ready to read
--	- MemWriteDone	to know when memory finished writing
-- 	- clk		clock
--	- rst		reset
-- 
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_control is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		MemReadReady, MemWriteDone	: in std_logic;
		op				: in std_ulogic_vector(5 downto 0);
		PCWriteCond, PCWriteCondN, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, Dump, Reset, InitMem,WordByte,IOMux	: out std_logic;
		PCSource, ALUSrcB, RegDst	: out std_ulogic_vector(1 downto 0);
		ALUOp				: out std_ulogic_vector(3 downto 0)
	);
end entity FSM_control;

architecture RTL of FSM_control is
	
	type state_type is (A, A_WAIT, B, C, D, E, F, G, H, I, J, K, INIT, FIN, Addi, Andi, Ori, Xori, Slti, Lui, Icomp,JAL,JALCMP,SB,LB);
	signal current_state, next_state : state_type;
	signal temp_out : std_ulogic_vector(18 downto 0);
	
begin 

process (op, current_state, MemReadReady, MemWriteDone)

begin
	
	case current_state is
		
			when A =>
--			  if (memReadReady='1') then
--				  next_state  <=  B;
--				else 
				  next_state <= A_WAIT;      
--				end if;
				
			when A_WAIT =>
			  -- wait for memory to complete read and increment PC
			   if (memReadReady='1') then
				    next_state  <=  B;
				 end if;
				
			when B =>
				case Op is 
					when "000000" => 		-- R-type
					 	next_state <=  G;
					when "001000" => 		-- addi
						next_state <= Addi;
					when "001100" => 		-- andi
						next_state <= Andi;
					when "001101" => 		-- ori
						next_state <= Ori;
					when "001110" =>  		-- xori
						next_state <= Xori;
					when "001010" => 		-- slti
						next_state <= Slti;
					when "001111" => 		-- lui
						next_state <= Lui;
					when "100000" => 		-- lb
						next_state <= C;
					when "100011" =>  		-- lw
						next_state <= C;
					when "101000" => 		-- sb
						next_state <= C;
					when "101011" => 		-- sw
						next_state <= C;
					when "000100" => 		-- beq
						next_state <= I;
					when "000101" => 		-- bne
						next_state <= K;
					when "000010" => 		-- j
						next_state <= J;
					when "000011" => 		-- jal
						next_state <= JAL;
					when others => 			-- invalid
						null;
				end case;
			when C =>
				case Op is 
					when "100000" => 		-- lb
						if (memReadReady='1') then
							next_state  <=  LB;
						end if;
					when "100011" =>  		-- lw
						if (memReadReady='1') then
							next_state  <=  D;
						end if;
					when "101000" => 		-- sb
						
						next_state  <=  SB;
						
					when "101011" =>			--sw

						
						next_state  <=  F;
						
					when others => 			-- others are not affected
						null;
				end case;
			when D =>
				next_state <= E;
			when LB =>
				next_state <= E;
			when E =>
				if (memReadReady='1') then
					next_state  <=  A;
				end if;
			when F =>
				if (memWriteDone='1') then
					next_state <= A;
				end if;
			when SB =>
				if (memReadReady='1') then
					next_state  <=  A;
				end if;
			when G =>
				next_state <= H;
			when H =>
				
					next_state  <=  A;
				
			when I =>
				
					next_state  <=  A;
				
			when J =>
				
					next_state  <=  A;
				
			when K => 
				
					next_state  <=  A;
				
			when INIT =>
				if (memReadReady='1') then
					next_state <= A;
				else
					next_state <= INIT;
				end if;
			when FIN =>
				next_state <= FIN;
			when Addi => 
				next_state <= Icomp;
			when Andi => 
				next_state <= Icomp;
			when Ori => 
				next_state <= Icomp;
			when Xori => 
				next_state <= Icomp;
			when Slti => 
				next_state <= Icomp;
			when Lui => 
				next_state <= Icomp;
			when Icomp => 
				--if (memReadReady='1') then
					next_state  <=  A;
				--end if;
			when JAL =>
				next_state <= JALCMP;
			when JALCMP =>
				if (memReadReady='1') then
					next_state  <=  A;
				end if;
			when others => 
				null;
		end case;
	
end process;

process (rst, clk)
begin
	if (rst='1')then
		current_state <= INIT;
	elsif (rising_edge(clk)) then
		current_state <= next_state;
	end if;
	
end process;

with current_state select
	MemRead <= 	'1' when A,
	    '1' when A_WAIT,
			'0' when B,
			'1' when D,
			'1' when LB,
			'1' when init,
			'0' when others;
					
with current_state select
	IorD <= 	'0' when A,
			'1' when D,
			'1' when F,
			'1' when LB,
			'1' when SB,
			'0' when others;				

with current_state select
	MemWrite <= 	'0' when A,
			'1' when F,
			'1' when SB,
			'0' when others;
			
with current_state select
	IOMux <= 	'0' when A,
			'1' when C,
			'1' when F,
			'1' when SB,
			'0' when others;			

with current_state select
	IRWrite <= 	'1' when A,
	    '1' when A_WAIT,
			'0' when B,
			'0' when others;					

with current_state select
	ALUSrcA <= 	'0' when A,
			'0' when B,
			'0' when JAL,
			'1' when C,
			'1' when G,
			'1' when I,
			'1' when K,
			'1' when Addi,
			'1' when Andi,
			'1' when Ori,
			'1' when Xori,
			'1' when Slti,
			'1' when Lui,
			'0' when others;
				
with current_state select
	ALUSrcB <= 	"01" when A,
			"01" when JAL,
			"11" when B,
			"10" when C,
			"00" when G,
			"00" when I,
			"00" when K,
			"10" when Addi,
			"10" when Andi,
			"10" when Ori,
			"10" when Xori,
			"10" when Slti,
			"10" when Lui,
			"00" when others;

with current_state select
	ALUOp <= 	"0001" when A,
			"0001" when B,
			"0001" when C,
			"0001" when JAL,
			"0000" when G,
			"0010" when I,
			"0010" when K,
			"0001" when INIT,
			"0001" when FIN,
			"0001" when Addi,
			"0010" when Andi,
			"0101" when Ori,
			"0110" when Xori,
			"0011" when Slti,
			"0111" when Lui,
			"0000" when others;

with current_state select
	PCWrite <= 	'1' when A_WAIT,
	--		'1' when B,
			'1' when J,
			'0' when others;

with current_state select
	PCSource <= 	"00" when A,
			"01" when I,
			"10" when J,
			"01" when K,
			"00" when others;

with current_state select
	PCWriteCond <= 	'0' when A,
			'1' when I,
			'0' when K,
			'0' when others;

with current_state select
	PCWriteCondN <= '0' when I,
			'1' when K,
			'0' when others;

with current_state select
	RegDst <= 	"00" when E,
			"01" when H,
			"10" when JALCMP,
			"00" when others;

with current_state select
	RegWrite <= 	'0' when A,
			'1' when E,
			'1' when H,
			'1' when JALCMP,
			'1' when IComp,
			'0' when others;
					
with current_state select
	MemtoReg <= 	'1' when E,
			'0' when H,
			'0' when JALCMP,
			'0' when others;

with current_state select
	Dump <= 	'0' when A,
			'1' when FIN,
			'0' when others;	

with current_state select
	Reset <= 	'0' when A,
			'1' when INIT,
			'0' when others;	

with current_state select
	InitMem <= 	'0' when A,
			'1' when INIT,
			'0' when others;
			
with current_state select
	WordByte <= 	'1' when A,
			'0' when LB,
			'0' when SB,
			'1' when others;
				
end architecture RTL;
