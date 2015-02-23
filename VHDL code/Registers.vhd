----------------------------------------------------------------------------------------
-- This module is used to implement the Registers
-- 
-- Inputs:
--	- ReadRegOne		5-bit operand
--	- ReadRegTwo	    5-bit operand
--  - WriteReg          5-bit operand
--  - WiteData          32-bit operand
-- 
-- Output:
-- 	- ReadDataOne		32-bit result
--  - ReadDataTwo       32-bit result
-- 
-- Control:
-- 	- clk		clock
--  - RegWrite  signal to write into  write register
-- 
-- The results of this module is 
--
----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
	port (
		clk       	: in std_logic;
		rst		: in std_logic;
        	RegWrite    	: in std_logic;
        
        	ReadRegOne  	: in unsigned(4 downto 0);
        	ReadRegTwo  	: in unsigned(4 downto 0);
        	WriteReg    	: in unsigned(4 downto 0);
        	WriteData   	: in signed(31 downto 0);
        
		ReadDataOne 	: out signed(31 downto 0);
        	ReadDataTwo 	: out signed(31 downto 0)
	);
end entity Registers;

architecture RTL of Registers is

        type dataArray is array (0 to 31) of signed(31 downto 0);
--        type addressArray is array (0 to 31) of unsigned(4 downto 0);
        
        signal data : dataArray;
        
--        signal addresses : addressArray := ("00000","00001","00010",
--                                            "00011","00100","00101",
--                                            "00110","00111","01000",
--                                            "01001","01010","01011",
--                                            "01100","01101","01110",
--                                            "01111","10000","10001",
--                                            "10010","10011","10100",
--                                            "10101","10110","10111",
--                                            "11000","11001","11010",
--                                            "11011","11100","11101",
--                                            "11110","11111");
                                            
        signal write_int : integer;

begin 

	process(clk,RegWrite)
	
    	begin

	   	if(rising_edge(clk)) then
        
            		ReadDataOne <= data(conv_integer(ReadRegOne));
            		ReadDataTwo <= data(conv_integer(ReadRegTwo));
            
            		if(RegWrite) then
            
                		write_int <= conv_integer(WriteReg);
                		data(write_int) <= WriteData;
            
            		end if;
		
	   	end if;

    	end process;
    
end architecture RTL;
