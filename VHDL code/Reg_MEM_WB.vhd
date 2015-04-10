----------------------------------------------------------------------------------------
-- This module is used hold values inbetween MEM_WB (Buffer)
-- 
-- Inputs:
-- - ALUM
-- - MEMM
-- - RdtM 5 bit operand
-- - RegWriteM 1 bit, will be forced to 0 if stall signal detected (dirty WB)
-- - MemtoRegM 1 bit, also must check if dirty or not
--
-- Outputs:		
-- - ALUW	
-- - MEMW			
-- - RdtW 5 bit operand
--	- RegWriteW 1 bit
-- - MemtoRegW 1 bit
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
		ALUM : in signed(31 downto 0);
		ALUW : out signed(31 downto 0);
		MEMM : in std_logic_vector(31 downto 0);
		MEMW  : out std_logic_vector(31 downto 0);     
		RdtM    : in std_ulogic_vector(4 downto 0);
		RdtW    : out std_ulogic_vector(4 downto 0);
		MemtoRegM, RegWriteM	: in std_logic;
	  MemtoRegW, RegWriteW	: out std_logic
	);
end entity Reg_MEM_WB;
--------------------------------------------------------------
architecture RTL of Reg_MEM_WB is
  
begin
  process(clk)
  begin
   if (rst = '1') then
    ALUW <= (OTHERS => '0');
	  MEMW <= (OTHERS => '0');
	  MemtoRegW <= '0';
	  RegWriteW <= '0';
	  RdtW <= (OTHERS => '0');
	 elsif(rising_edge(clk)) then 
	  ALUW <= ALUM;
	  MEMW <= MEMM;
	  MemtoRegW <= MemtoRegM;
	  RegWriteW <= RegWriteM;
	  RdtW <= RdtM;
	   
	 end if;
	end process;   

end architecture RTL;




