----------------------------------------------------------------------------------------
-- This module is used hold values inbetween ID_EX (Buffer)
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
entity Reg_ID_EX is
	port (
		clk 				: in std_logic;
		rst 				: in std_logic;
    A      : in std_ulogic_vector(31 downto 0);
	  B      : in std_ulogic_vector(31 downto 0);
	  Rs     : in std_ulogic_vector(4 downto 0);
	  Rt     : in std_ulogic_vector(4 downto 0);
	  Rd     : in std_ulogic_vector(4 downto 0);
	  PCWriteCondD, PCWriteCondND, PCWriteD, IorDD, MemReadD, MemWriteD, MemtoRegD, IRWriteD, ALUSrcAD, RegWriteD, DumpD, ResetD, InitMemD,WordByteD	: in std_logic;
		PCSourceD, ALUSrcBD, RegDstD	: in std_ulogic_vector(1 downto 0);
	  PCWriteCondE, PCWriteCondNE, PCWriteE, IorDE, MemReadE, MemWriteE, MemtoRegE, IRWriteE, ALUSrcAE, RegWriteE, DumpE, ResetE, InitMemE,WordByteE	: out std_logic;
		PCSourceE, ALUSrcBE, RegDstE	: out std_ulogic_vector(1 downto 0);
	  Rs_out : out std_ulogic_vector(4 downto 0);
	  Rt_out : out std_ulogic_vector(4 downto 0);
	  Rd_out : out std_ulogic_vector(4 downto 0);	  
	  A_out  : out std_ulogic_vector(31 downto 0);
	  B_out  : out std_ulogic_vector(31 downto 0);
	  flush  : in std_logic
	);
end entity Reg_ID_EX;
--------------------------------------------------------------
architecture RTL of Reg_ID_EX is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk)  and flush = '0') then 
	  A_out <= A;
	  B_out <= B;
	  Rs_out <= Rs;
	  Rt_out <= Rt;
	  Rd_out <= Rd;
	  PCWriteCondE <= PCWriteCondD;
	  PCWriteCondNE <= PCWriteCondND;
	  PCWriteE <= PCWriteD; 
	  IorDE <= IorDD; 
	  MemReadE <= MemReadD; 
	  MemWriteE <= MemWriteD;
	  MemtoRegE <= MemtoRegD; 
	  IRWriteE <= IRWriteD;
	  ALUSrcAE <= ALUSrcAD; 
	  RegWriteE <= RegWriteD;
	  DumpE <= DumpD; 
	  ResetE <= ResetD;
	  InitMemE <= InitMemD; 
	  WordByteE <= WordByteD;
		PCSourceE <= PCSourceD; 
		ALUSrcBE <= ALUSrcBD; 
		RegDstE <= RegDstD;
	 end if;
	end process;   

end architecture RTL;
