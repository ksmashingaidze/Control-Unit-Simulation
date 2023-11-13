--MSHKUZ001
LIBRARY altera;
USE altera.maxplus2.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity multitwo is
	port
		(sel: in std_logic;
		in0: in std_logic_vector(15 downto 0);
		in1: in std_logic_vector(15 downto 0);
		multi_out: out std_logic_vector(15 downto 0));
end multitwo;

architecture behave of multitwo is
    
    begin
	process (sel, in0, in1)
	
	begin
		
		if (sel = '0') then
			multi_out <= in0;
		else 
			multi_out <= in1;
		end if;

	end process;
end behave;