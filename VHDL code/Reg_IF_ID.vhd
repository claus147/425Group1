----------------------------------------------------------------------------------------
-- This module is used hold values inbetween IF_ID (Buffer)
-- 
-- Inputs:
-- - instr 32 bit operand
-- - stall 1 bit control
--
-- Outputs:						
-- - instr_out 32 bit operand
--	
-- Control:
-- 	- clk		clock
-- 
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------
entity Reg_IF_ID is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		stall   :in std_logic;
    instr : in std_ulogic_vector(31 downto 0);
	  instr_out : out std_ulogic_vector(31 downto 0)
	);
end entity Reg_IF_ID;
--------------------------------------------------------------
architecture RTL of Reg_IF_ID is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk) and stall = '0') then 
	   instr_out <= instr;
	 end if;
	end process;   

end architecture RTL;





