----------------------------------------------------------------------------------------
-- This module is used hold values inbetween EX_MEM (Buffer)
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
entity Reg_EX_MEM is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ALUE    : in signed(31 downto 0);
		ALUM    : out signed(31 downto 0);
	  MemReadE, MemWriteE, MemtoRegE,RegWriteE, DumpE, ResetE, InitMemE,WordByteE	: in std_logic;
	  MemReadM, MemWriteM, MemtoRegM,RegWriteM, DumpM, ResetM, InitMemM,WordByteM	: out std_logic
	);
end entity Reg_EX_MEM;
--------------------------------------------------------------
architecture RTL of Reg_EX_MEM is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk)) then 
	  ALUM <= ALUE;
	  MemReadM <= MemReadE; 
	  MemWriteM <= MemWriteE;
	  MemtoRegM <= MemtoRegE; 
	  RegWriteM <= RegWriteE;
	  DumpM <= DumpE; 
	  ResetM <= ResetE;
	  InitMemM <= InitMemE; 
	  WordByteM <= WordByteE;
	 end if;
	end process;   

end architecture RTL;


