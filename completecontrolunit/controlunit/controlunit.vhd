--MSHKUZ001
LIBRARY altera;
USE altera.maxplus2.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity controlunit is
	port
		(instrmem: in std_logic_vector(15 downto 0);
		nflagin: in std_logic;
		zflagin: in std_logic;
		cflagin: in std_logic;
		
		braout: out std_logic;
		bccout: out std_logic;
		bcsout: out std_logic;
		bneout: out std_logic;
		beqout: out std_logic;
		bplout: out std_logic;
		bmiout: out std_logic;
		
		uppernibbleand: out std_logic;
		
		mux1selout: out std_logic;
		mux2selout: out std_logic_vector(1 downto 0);
		aluinselout: out std_logic;
		controlout: out std_logic_vector(7 downto 0);
		accloadout: out std_logic;
		memwriteout: out std_logic;
		aluopcodeout: out std_logic_vector(4 downto 0));
end controlunit;

LIBRARY altera;
USE altera.maxplus2.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity programcounter is
	port
		(pcin: in std_logic_vector(15 downto 0);
		pcclk: in std_logic;
		pcout: out std_logic_vector(15 downto 0));
end programcounter;

LIBRARY altera;
USE altera.maxplus2.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity memextend is
	port
		(memexin: in std_logic_vector(7 downto 0);
		memexout: out std_logic_vector(15 downto 0));
end memextend;

architecture behave of controlunit is
    
    begin
	process (instrmem, nflagin, zflagin, cflagin)
	variable opcodevar: std_logic_vector(7 downto 0);
	variable aluopcodevar: std_logic_vector(4 downto 0);
	variable instrfilter: std_logic_vector(3 downto 0);
	variable lowerbyte: std_logic_vector(7 downto 0);
		begin
		aluopcodevar := instrmem(15)&instrmem(11)&instrmem(10)&instrmem(9)&instrmem(8);      --Obtains the ALU opcode from the original 16 bit instruction.
		instrfilter := instrmem(15)&instrmem(14)&instrmem(13)&instrmem(12);                  --The variable by which instructions will be identified as imm, dir, inh, or bra.
		lowerbyte := instrmem(7)&instrmem(6)&instrmem(5)&instrmem(4)&instrmem(3)&instrmem(2)&instrmem(1)&instrmem(0); --Obtains lower 8 bits from the 16 bit instructiion.
		opcodevar := instrmem(15)&instrmem(14)&instrmem(13)&instrmem(12)&instrmem(11)&instrmem(10)&instrmem(9)&instrmem(8); --Obtains upper 8 bits from the 16 bit instruction.

			uppernibbleand <= '0';                --Assuming not a branch, always reset the AND of the upper nibble opcode bits to 0. 
			if (instrfilter = "0010") then        --If Branch
				mux2selout <= "00";
				accloadout <= '0';
				aluinselout <= '0';
				memwriteout <= '0';
				if (opcodevar = "00100000") then      --If Branch Always
					braout<='1';
				else
					braout<='0';
				end if;
				
				if (opcodevar = "00100100") then      --If Branch Carry Cleared
					bccout<='1';
				else
					bccout<='0';
				end if;
				
				if (opcodevar = "00100101") then      --If Branch Carry Set
					bcsout<='1';
				else
					bcsout<='0';
				end if;
				
				if (opcodevar = "00100110") then      --If Branch Zero Clear
					bneout<='1';
				else
					bneout<='0';
				end if;
				
				if (opcodevar = "00100111") then      --If Branch Zero Set
					beqout<='1';
				else
					beqout<='0';
				end if;
				
				if (opcodevar = "00101010") then      --If Branch Negative Clear
					bplout<='1';
				else
					bplout<='0';
				end if;
				
				if (opcodevar = "00101011") then      --If Branch Negative Set
					bmiout<='1';
				else
					bmiout<='0';
				end if;
				
				uppernibbleand <= '1'; --To be used for branch 2 way mux select. If the instruction is a branch, this should be high.
				
				
			
			elsif (instrfilter = "1010") then     --If Immediate
				mux1selout <= '0';
				mux2selout <= "00";
				aluinselout <= '1';
				memwriteout <= '0';
				if (opcodevar = "10110001") then           --If CMP
					accloadout <= '0';
				else
					accloadout <= '1';
				end if;
			
			elsif (instrfilter = "0100") then     --If Inherent
				mux2selout <= "00";
				accloadout <= '1';
				aluinselout <= '0';
				memwriteout <= '0';
			
			else                                  --If Direct
				mux1selout <= '1';
				mux2selout <= "00";
				aluinselout <= '1';
				if (opcodevar = "10110001") or (opcodevar = "10110111") or (instrfilter = "0011") then  --If CMP, STA, or read/modify
					accloadout <= '0';
				else
					accloadout <= '1';
				end if;
			
				if (opcodevar = "10110111") then           --If STA
					--Do nothing
				else 
					memwriteout <= NOT(opcodevar(7));
				end if;
		
			end if;
		
			aluopcodeout <= aluopcodevar;	
			controlout<=lowerbyte;                         --8 bit output of the control unit is simply the lower 8 bits of the instruction.
		

	end process;
end behave;

architecture behavetwo of programcounter is
    
    begin
	process (pcin, pcclk)     
	variable pcinval: std_logic_vector(15 downto 0);
	begin
		if rising_edge(pcclk) then  --Program Counter is a storage element, and is hence clocked.
			pcinval:=pcin;
			pcout <= pcinval;  --Route input to output. Program counter acts as a storage element.
		end if;
	
	end process;
end behavetwo;

architecture behavethree of memextend is
    
    begin
	process (memexin)
	variable memexinvar: std_logic_vector(7 downto 0);
	begin
		memexinvar:= memexin;
		memexout <= memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar(7)&memexinvar;
		--The memextend element simply converts the 8 bit output of the control unit to a 16 bit output. MSB duplicated 8 times and appended to do this.
	end process;
end behavethree;