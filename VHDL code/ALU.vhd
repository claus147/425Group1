----------------------------------------------------------------------------------------
-- This module is used to implement the ALU
-- 
-- Inputs:
--	- A			32-bit operand
--	- B			32-bit operand 
-- 
-- Output:
-- 	- R			32-bit result
-- 
-- Control:
-- 	- Op		choose between operations
-- 	- clk		clock
-- 
-- The results of this module is stored in Data Memory
--
----------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
	port (
		clk 		: in std_logic;
		rst 		: in std_logic;
		A, B		: in signed(31 downto 0);
		Op		: in std_ulogic_vector(5 downto 0);
		R		: out signed(31 downto 0);
		zero		: out std_logic
	);
end entity ALU;

architecture RTL of ALU is
signal B_int : integer;
signal A_int: integer;
signal zero_int: integer;
signal MD_temp : signed (63 downto 0); -- temp signal for multiplication and division
signal hi, lo: signed (31 downto 0);

begin 

zero_int <= 0;
	
process(clk)
	
begin
	
	if(rising_edge(clk)) then
		case Op is
			when "100000" => 		-- 00000	ADD, ADDI,
				R  <= A+B;
			
			when "100010" => 		-- 00001	SUB
				R <= A-B;
				
			when "011000" => 		-- 00010	MULT
				MD_temp <= A*B;
				lo <= MD_temp(31 downto 0);
				hi <= MD_temp(63 downto 32);
				
			when "011010" =>			-- 00011	DIV
				lo <= A / B;
				hi <= mod(A,B);
				
			when "101010" =>  	-- slt
				if (A<B) then
					R <= "00000000000000000000000000000001";
				else
					R <= "00000000000000000000000000000000";  
				end if;
				
			when "100100" => 	-- and
				R <= A and B;
			
			when "100101" =>	-- or 
				R <= A or B;
			
			when "100111" =>	-- nor 
				R <= A nor B;
			
			when "100110" =>	-- xor 
				R <= A xor B;
			
			when "010000" => 	-- move from high
				R <= hi;
			
			when "010010" => 	-- move from low
				R <= lo;
			
			when "000000" => 	-- sll
				
				B_int <= to_integer(B);
				R <= A sll B_int;
				
			when "000010" =>	-- srl
				
				B_int <= to_integer(B);
				R <= A srl B_int;
			
			when "000011" =>  	-- sra
				B_int <= to_integer(B);
				R <= A +Shift_right(A, B_int);
				
			when "111111" => 	-- lui
			
				R <= resize(B(31 downto 16),32);
				
			when "001000" => 	-- jr
			
				-- TODO: Jump Register
			
			when others => 
				NULL;
			
		end case;
		
	end if;
	
	zero <= R = zero_int;
		
end process;
end architecture RTL;
