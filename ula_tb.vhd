library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

entity ula_tb is 
end ula_tb;

architecture sim of ula_tb is

-- importa o componente UUT
component ula is 
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       result:     buffer STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
end component;

-- sinais para interagir com o UUT
signal a, b, result: STD_LOGIC_VECTOR(31 downto 0);
signal control: STD_LOGIC_VECTOR(2 downto 0);
signal z: STD_LOGIC;

begin 
	uut: ula port map(a=>a, b=>b, result=>result, alucontrol=>control, zero=>z);

	-- gera estimulos para testar a uut
	process
	begin
		-- testar soma
		control <= "010";
		a <= x"0000000f";
		b <= x"00000003";
		wait for 10ns;
		
		-- testar subtracao
		control <= "110";
		a <= x"0000000f";
		b <= x"00000003";
		wait for 10ns;
		
		-- testar zero
		control <= "110";
		a <= x"0000000f";
		b <= x"0000000f";
		wait for 10ns;
		
		--testar and
		control <= "000";
		a <= x"00000003";
		b <= x"0000000f";
		wait; -- para encerrar a simulacao 
		
	end process;
end sim;