----------------------------------------------------------------------------------------
-- This module is used hold values inbetween ID_EX (Buffer)
-- 
-- Inputs:
-- -	AD, top operand to ALU
-- -	BD, bottom operand to ALU
-- -	RsD, register name
-- -	RtD
-- -	RdD
-- -	PCWriteCondD, our branch
-- -	PCWriteCondND
-- -	PCWriteD
-- -	IorDD
-- -	MemReadD
-- -	MemWriteD
-- -	MemtoRegD
-- -	IRWriteD, MIGHT NOT NEED THIS LINE, controlled the IR  in unpipe, now this reg is our (IF_ID reg)
-- -	ALUSrcAD
-- -	RegWriteD
-- -	DumpD, for Main mem
-- -	ResetD, for Main mem
-- -	InitMemD, for Main mem
-- -	WordByteD, for Main mem
-- -	PCSourceD 
-- -	ALUSrcBD
-- -	RegDstD, will tie to Rt $ Rd
-- - opD
--
-- Outputs:						
-- -	AE, top operand to ALU
-- -	BE, bottom operand to ALU
-- -	RsE, register name
-- -	RtE
-- -	RdE
-- -	PCWriteCondE, our branch
-- -	PCWriteCondNE
-- -	PCWriteE
-- -	IorDE
-- -	MemReadE
-- -	MemWriteE
-- -	MemtoRegE
-- -	IRWriteE, MIGHT NOT NEED THIS LINE, controlled the IR  in unpipe, now this reg is our (IF_ID reg)
-- -	ALUSrcAE
-- -	RegWriteE
-- -	DumpE
-- -	ResetE
-- -	InitMemE
-- -	WordByteE
-- -	PCSourceE 
-- -	ALUSrcBE
-- -	RegDstE
-- - opE
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
    AD      : in signed(31 downto 0);
	  BD      : in signed(31 downto 0);
	  RsD     : in std_ulogic_vector(4 downto 0);
	  RtD     : in std_ulogic_vector(4 downto 0);
	  RdD     : in std_ulogic_vector(4 downto 0);
	  PCWriteCondD, PCWriteCondND, PCWriteD, IorDD, MemReadD, MemWriteD, MemtoRegD, IRWriteD, ALUSrcAD, RegWriteD, DumpD, ResetD, InitMemD,WordByteD, ALUSrcBD	: in std_logic;
		PCSourceD, RegDstD	: in std_ulogic_vector(1 downto 0);
	  PCWriteCondE, PCWriteCondNE, PCWriteE, IorDE, MemReadE, MemWriteE, MemtoRegE, IRWriteE, ALUSrcAE, RegWriteE, DumpE, ResetE, InitMemE,WordByteE, ALUSrcBE	: out std_logic;
		PCSourceE, RegDstE	: out std_ulogic_vector(1 downto 0);
	  RsE : out std_ulogic_vector(4 downto 0);
	  RtE : out std_ulogic_vector(4 downto 0);
	  RdE : out std_ulogic_vector(4 downto 0);	  
	  AE  : out signed(31 downto 0);
	  BE  : out signed(31 downto 0);
	  flush  : in std_logic;
	  opD : in std_ulogic_vector(5 downto 0);
	  opE: out std_ulogic_vector(5 downto 0)
	);
end entity Reg_ID_EX;
--------------------------------------------------------------
architecture RTL of Reg_ID_EX is
  
begin
  process(clk)
  begin
    
	 if(rising_edge(clk)  and flush = '0') then 
	  AE <= AD;
	  BE <= BD;
	  RsE <= RsD;
	  RtE <= RtD;
	  RdE <= RdD;
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
		opE <= opD;
	 end if;
	end process;   

end architecture RTL;
