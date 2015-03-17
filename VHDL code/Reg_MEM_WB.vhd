----------------------------------------------------------------------------------------
-- This module is used hold values inbetween MEM_WB (Buffer)
-- 
-- Inputs:
-- - A 32 bit operand
-- - B 32 bit operand
-- - Rs 5 bit operand
-- - Rt 5 bit operand
-- - Rd 5 bit operand
-- - RegWriteD 1 bit
-- - flush 1 bit control (stall)
--
-- Outputs:						
-- - A_out 32 bit operand
-- - B_out 32 bit operand
-- - Rs_out 5 bit operand
-- - Rt_out 5 bit operand
-- - Rd_out 5 bit operand
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
entity Reg_MEM_WB is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUM, MEMM    : in signed(31 downto 0);
		ALUW, MEMW    : out signed(31 downto 0);
		MemtoRegM, RegWriteM	: in std_logic;
	  MemtoRegW, RegWriteW	: out std_logic
	);
end entity Reg_MEM_WB;
--------------------------------------------------------------
architecture RTL of Reg_MEM_WB is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk)) then 
	  ALUW <= ALUM;
	  MEMW <= MEMM;
	  MemtoRegW <= MemtoRegM;
	  RegWriteW <= RegWriteM; 
	 end if;
	end process;   

end architecture RTL;




