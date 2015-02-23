----------------------------------------------------------------------------------------
-- This module is implements the Control
-- 
-- Inputs:
--
--	- Opcode	6-bit operand
--
-- Outputs:
--	
--  - RegDst    1-bit control
--  - Jump      1-bit control
--  - Branch    1-bit control
--  - MemRead   1-bit control
--  - MemToReg  1-bit control
--  - ALUOp     4-bit control
--  - MemWrite  1-bit control
--  - ALUSrc    1-bit control
--  - RegWrite  1-bit control
--		
-- Control:
-- 	- clk		clock
-- 
-- The results of this module used to control the ALU, registers and some logic gates
--
----------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control is
	port (
	clk 			: in std_logic;
	rst 			: in std_logic;
        Opcode                  : in std_logic_vector(5 downto 0);
        
        RegDst                  : out std_logic;
        Jump                    : out std_logic;
        Branch                  : out std_logic;
        MemRead                 : out std_logic;
        MemToReg                : out std_logic;
        ALUOp			: out std_ulogic_vector(3 downto 0);
        MemWrite                : out std_logic;
        ALUSrc                  : out std_logic;
	RegWrite                : out std_logic
	);
end entity Control;

architecture RTL of Control is

signal out_vec: std_logic_vector(11 downto 0);

begin 

    RegDst      <= out_vec(11);
    Jump        <= out_vec(10);
    Branch      <= out_vec(9);
    MemRead     <= out_vec(8);
    MemToReg    <= out_vec(7);
    ALUOp       <= out_vec(6 downto 3);
    MemWrite    <= out_vec(2);
    ALUSrc      <= out_vec(1);
    RegWrite    <= out_vec(0);

process(clk)
	
begin

	if(rising_edge(clk)) then
		
		case Opcode is
		
			when "000000" => -- R Instruction
            
                		out_vec <= "100000000001";
				
			when "000010" => -- j
            
                		-- TODO: Assign don't cares, possibly make the same as jal
                		out_vec <= "d100d10010d0";
				
			when "000011" => -- jal
            
                		-- TODO: Not Sure How we implement assigning R[31], maybe compile side
                		out_vec <= "?100?10000?0";
				
			when "000100" => -- beq
            
                		out_vec <= "001000010000";
				
			when "000101" => -- bne
            
                		-- TODO: beq logic defined in book, but bne. Solve bne
                		out_vec <= "001000010000";
				
			when "001000" => -- addi
            
                		out_vec <= "000000001011";
				
			when "001010" => -- slti
            
                		out_vec <= "000000011011";
				
			when "001100" => -- andi
            
                		out_vec <= "000000100011";
				
			when "001101" => -- ori
             
                		out_vec <= "000000101011";
            
			when "001110" => -- xori
            
                		out_vec <= "000000110011";
            
            		when "001111" => -- lui
            
                		out_vec <= "000000111011";
				
			when "100000" => -- lb
            
                		out_vec <= "000110001011";
				
			when "100011" => -- lw
             
                		out_vec <= "000110001011";
            
			when "101000" => -- sb
            
                		out_vec <= "000010001110";
            
            		when "101011" => -- sw
            
                		out_vec <= "000010001110";
		
			end case;
		
	end if;

end process;
end architecture RTL;
