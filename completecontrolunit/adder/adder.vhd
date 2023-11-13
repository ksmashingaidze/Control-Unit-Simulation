--MSHKUZ001
LIBRARY altera;
USE altera.maxplus2.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity adder is
	port
		(adderin: in std_logic_vector(15 downto 0);
		offset: in std_logic_vector(15 downto 0);
		adderout: out std_logic_vector(15 downto 0));
end adder;

architecture behave of adder is
    
    begin
	process (adderin, offset)
	
	begin
	
		adderout <= adderin + offset;  --Adds the offset (either 1, or the branch operand) to the current value stored in the program counter.
	

	end process;
end behave;