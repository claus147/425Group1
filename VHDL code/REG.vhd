----------------------------------------------------------------------------------------
-- This module is used to implement the 32-bit register
-- This module writes data on rising edge and reads data on falling edge
-- This implementation allows "simultaneous" read-write 
--
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
--  - rst       reset
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
		clk 				: in std_logic;
		rst 				: in std_logic;
		Rs, Rt, Rd			: in std_ulogic_vector(4 downto 0);
		WB_data				: in signed(31 downto 0);
		WB				: in std_logic;
		A,B				: out signed(31 downto 0)
	);
end entity REG;

architecture RTL of REG is
TYPE StorageT IS ARRAY(0 TO 31) OF signed(31 DOWNTO 0); 				--Array for register storage
SIGNAL registerfile : StorageT; 							--Register file
begin
	process(rst,clk,WB)
	begin
		IF rst = '1' THEN 
			FOR i IN 0 TO 31 LOOP
				registerfile(i) <= (OTHERS => '0');			-- Reset all the registers to 0 when rst is high
			END LOOP;
		ELSIF rising_edge(clk) THEN						-- WRITE on rising edge!
			IF WB = '1' THEN
				registerfile(to_integer(unsigned(Rd))) <= WB_data; 	-- Write the WB_data into the Rd register
			END IF;
		END IF;
		registerfile(0)<= (OTHERS => '0'); 						-- Hard wire the register 0 to be 0
	end process;
	A <= registerfile(to_integer(unsigned(Rs))); 					-- output the data in the register address Rs and Rt
	B <= registerfile(to_integer(unsigned(Rt)));
end architecture RTL;
