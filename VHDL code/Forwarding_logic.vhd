----------------------------------------------------------------------------------------
-- This module is used to handle forwarding
-- 
-- Inputs:
-- - IF_ID_Rs 5 bit operand (second instruction Rs)
-- - IF_ID_Rt 5 bit operand (second instruction Rt)
-- - EX_MEM_Rd 5 bit operand (first instruction Rd)
-- - MEM_WB_Rd 5 bit operand (first instruction Rd - if stalled, load)
-- - stall 1 bit control
--
-- Outputs:						
-- - forward_A 2 bit control
-- - forward_B 2 bit control
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
entity Forwarding_logic is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
    IF_ID_Rs : in std_ulogic_vector(4 downto 0);
    IF_ID_Rt : in std_ulogic_vector(4 downto 0);
    EX_MEM_Rd: in std_ulogic_vector(4 downto 0);
    MEM_WB_Rd : in std_ulogic_vector(4 downto 0);
    stall : in std_logic;
    forward_A : out std_ulogic_vector(1 downto 0);
	  forward_B : out std_ulogic_vector(1 downto 0)
	);
end entity Forwarding_logic;
--------------------------------------------------------------
architecture RTL of Forwarding_logic is

begin
    
  forward_A <= "10" when (IF_ID_Rs = EX_MEM_Rd and stall = '0') else
             "11" when (IF_ID_Rs = MEM_WB_Rd and stall = '1') else
             "00";
            
  forward_B <= "10" when (IF_ID_Rt = EX_MEM_Rd and stall = '0') else
             "11" when (IF_ID_Rt = MEM_WB_Rd and stall = '1') else
             "00";            

end architecture RTL;



