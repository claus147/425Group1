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
--	- J_type    Helton: The type should not be handled by this reg unit but the controller, this controller will only take R type.
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
		Rs, Rt, Rd					: in std_ulogic_vector(4 downto 0);
		WB_data						: in std_ulogic_vector(31 downto 0);
		WB							: in std_logic;
		A,B							: out std_ulogic_vector(31 downto 0)
	);
end entity REG;

architecture RTL of REG is
TYPE StorageT IS ARRAY(0 TO 4) OF std_ulogic_vector(31 DOWNTO 0); --Array for register storage
SIGNAL registerfile : StorageT; --Register file
begin
	process(rst,clk)
	begin
		IF rst = '1' THEN
			FOR i IN 0 TO 31 LOOP
				registerfile(i) <= (OTHERS => '0');
			END LOOP;
		ELSIF rising_edge(clk) THEN			-- WRITE on rising edge!
			IF WB = '1' THEN
				registerfile(to_integer(unsigned(Rd))) <= WB_data;
			END IF;
		END IF;
	end process;
	registerfile(0)<= (OTHERS => '0');
	A <= registerfile(to_integer(unsigned(Rs)));
	B <= registerfile(to_integer(unsigned(Rt)));
end architecture RTL;
