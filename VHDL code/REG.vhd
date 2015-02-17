----------------------------------------------------------------------------------------
-- This module is used to implement the 32-bit register
-- This module writes data on rising edge and reads data on falling edge
-- This implementation allows "simultaneous" read-write 
--
--
-- We need a register file!!!
--
-- Inputs:
--	- Rs 		5-bit operand
--	- Rt		5-bit operand 
-- 	- Rd		5-bit operand
--	- WB_data	32-bit operand (data to be written back in register)
--
-- Outputs:
-- 	- A			32-bit data
--	- B			32-bit data
--
-- Control:
-- 	- clk		clock
--	- WB		writing data to register
--	- R_type	the inputs should be interpreted differently depending on the type of instruction
--	- I_type		ie, dismiss Rd if I-Type and dismiss all if J-type (not accessing registers)
--	- J_type
--
-- The results of this module is sent to the ALU
--
-- Special note: R0 is hard wired to 0x0000
--
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is
	port (
		clk 						: in std_logic;
		rst 						: in std_logic;
		Rs, Rt, Rd					: in unsigned(4 downto 0);
		WB_data						: in signed(31 downto 0);
		WB, R_type, I_type, J_type	: in std_logic;
		A,B							: out signed(31 downto 0)
	);
end entity REG;

architecture RTL of REG is

begin process(clk)
	
begin

	if(rising_edge(clk)) then		-- WRITE on rising edge!
		
		
	end if;
	
	if(falling_edge(clk)) then 		-- READ on falling edge!
		
	end if;

end process;
end architecture RTL;
