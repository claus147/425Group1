----------------------------------------------------------------------------------------
-- This module is used to handle hazard detection and control
-- 
-- Inputs:
--	- ID_EX_Rd 5 bit operand (first instruction Rd)
-- - IF_ID_Rs 5 bit operand (second instruction Rs)
-- - IF_ID_Rt 5 bit operand (second instruction Rt)
-- - ID_EX_MemRead 1 bit control
--
-- Outputs:						
-- - stall 1 bit control
--	
-- Control:
-- 	- clk		clock
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------
entity Hazard_control is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		ID_EX_Rd: in std_ulogic_vector(4 downto 0);
    IF_ID_Rs : in std_ulogic_vector(4 downto 0);
    IF_ID_Rt : in std_ulogic_vector(4 downto 0);
    ID_EX_MemRead : in std_logic;
    stall : out std_logic
	);
end entity Hazard_control;
--------------------------------------------------------------
architecture RTL of Hazard_control is

  signal RdRs_equal : std_logic;
  signal RdRt_equal : std_logic;

begin
  RdRs_equal <= '1' when ID_EX_Rd = IF_ID_Rs else '0';
  RdRt_equal <= '1' when ID_EX_Rd = IF_ID_Rt else '0';

  stall <= (RdRs_equal or RdRt_equal) and ID_EX_MemRead;

end architecture RTL;


