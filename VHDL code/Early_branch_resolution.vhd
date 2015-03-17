----------------------------------------------------------------------------------------
-- This module is used to handle Early_branch_resolution
-- 
-- Inputs:
--	- 
--
-- Outputs:						
-- - 
--	
-- Control:
-- 	- clk		clock
-- 
-- add BNE as WELL!!!!!!!!!!
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------
entity Early_branch_resolution is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
		branchD : in std_logic;
		A       : in signed(31 downto 0);
		B       : in signed(31 downto 0);
		imm     : in signed(31 downto 0);
		PC4     : in signed(31 downto 0);
		forward_A, forward_B : in std_ulogic_vector(1 downto 0);
		
		ALU_out : in signed(31 downto 0);
		branch : out std_logic;
		targetPC : out signed(31 downto 0)
		
	);
end entity Early_branch_resolution;
--------------------------------------------------------------
architecture RTL of Early_branch_resolution is

  signal comp_A : signed(31 downto 0);
  signal comp_B : signed(31 downto 0);
  signal forwarding_A, forwarding_B : std_logic;


begin
  targetPC <= imm + PC4;
  forwarding_A <= '1' when forward_A = "10" else
            '0';
  forwarding_B <= '1' when forward_B = "10" else
            '0';
  comp_A <= A when forwarding_A = '0' else
            ALU_out;  
  comp_B <= B when forwarding_B = '0' else
            ALU_out; 
            
  branch <= '1' when (comp_A = comp_B and branchD = '1') else
            '0';           
end architecture RTL;



