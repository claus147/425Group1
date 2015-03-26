----------------------------------------------------------------------------------------
-- This module is used hold values inbetween IF_ID (Buffer)
-- 
-- Inputs:
-- - instr 32 bit operand
-- - stall 1 bit control
-- - flush 1 bit control (if branch is taken, must ignore what was fetched, ie stall due to branch) 
-- - dirtyF, this is the OR of MemReadE with MemWriteE
--
-- Outputs:						
-- - instr_out 32 bit operand
-- - dirtyD
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
		stall, dirtyF, flush   :in std_logic;
    dirtyD   :out std_logic;
    instr : in std_ulogic_vector(31 downto 0);
	  instr_out : out std_ulogic_vector(31 downto 0);
	  PC4F : in unsigned(31 downto 0);
	  PC4D : out unsigned(31 downto 0)
	);
end entity Reg_IF_ID;
--------------------------------------------------------------
architecture RTL of Reg_IF_ID is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk) and stall = '0' and flush = '0') then 
	   instr_out <= instr;
	   dirtyD<=dirtyF;
	   PC4D <= PC4F;
	 end if;
	end process;   

end architecture RTL;





