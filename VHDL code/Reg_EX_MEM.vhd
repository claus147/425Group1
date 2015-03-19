----------------------------------------------------------------------------------------
-- This module is used hold values inbetween EX_MEM (Buffer)
-- 
-- Inputs:
-- - ALUE, ALU output
-- - RdtE, register name (for forwarding)
-- - MemReadE
-- - MemWriteE
-- - MemtoRegE
-- - RegWriteE
-- - DumpE, Main_Memory line
-- - ResetE, Main_Memory line
-- - InitMemE, Main_Memory line
-- - WordByteE, Main_Memory line
--
-- Outputs:						
-- - ALUW, ALU output
-- - RdtW, register name (for forwarding)
-- - MemReadW
-- - MemWriteW
-- - MemtoRegW
-- - RegWriteW
-- - DumpW, Main_Memory line
-- - ResetW, Main_Memory line
-- - InitMemW, Main_Memory line
-- - WordByteW, Main_Memory line
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
	  RdtE    : in signed(4 downto 0);
		RdtM    : out signed(4 downto 0);
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
	  RdtM <= RdtE;
	 end if;
	end process;   

end architecture RTL;


