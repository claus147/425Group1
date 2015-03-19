----------------------------------------------------------------------------------------
-- This module is used to implement an IO_MUX
-- 
-- Inputs:
--	- dat			32-bit signed operand
-- 
-- Output:
-- 	- instruction			32-bit unsigned instruction
--
-- Input/Output:
--  - memIO     32-bit std_logic_vector
-- 
-- Control:
-- 	- sel  std_logic
-- 
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX is
	port (
	  rst   : in std_logic;
		dat  	: in std_logic_vector(31 downto 0);
		sel   : in std_logic;
		inst  : out std_logic_vector(31 downto 0);
		memIO : inout std_logic_vector(31 downto 0)
	);
end entity MUX;

architecture RTL of MUX is
signal temp : unsigned(31 downto 0);
begin 
--  with sel select 
--  inst <= dat when '1',
--       memIO when others;

--process(sel,rst)
--  begin
--    
--    if rst = '1' then
--      
--      inst <= "00000000000000000000000000000000";
--      
--    else
--    
--      if sel = '1' then
--      
--        --memIO <= dat;
--        inst <= "00000000000000000000000000000000";
--      
--      elsif sel = '0' then 
--      
--        inst <= memIO;
--      
--      end if;
--      
--    end if;
--    
--  end process;
temp <= unsigned(memIO);
memIO <= std_logic_vector(dat) when sel = '1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
inst <= memIO when sel = '0' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

end architecture RTL;