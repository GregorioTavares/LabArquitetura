library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_mem_tb is
end instruction_mem_tb;

architecture sim of instruction_mem_tb is

	-- componente da unidade a ser testado
	component instruction_mem is
		port(a: in std_logic_vector(31 downto 0);   -- Parramento de end.
	        rd: out std_logic_vector(31 downto 0)); -- Barramento de dados
	end component;
	
	-- sinais para interagir com o componente a ser testado 
	signal a, rd: std_logic_vector(31 downto 0); 
	
begin
		-- instancia o componente a ser testado
		uut: instruction_mem port map(a=>a, rd=>rd);
		-- logica de teste
		process
		begin
		
		-- acessa a primeira palavra
		a <= x"00000000";
		wait for 10ns;
		
		-- acessa a segunda palavra
		a <= x"00000004";
		wait for 10ns;
		
		-- acessa a terceira palavra
		a <= x"00000008";
		wait for 10ns;
		
		-- acessa a quarta palavra
		a <= x"0000000c";
		wait for 10ns;
		
		-- acessa a quinta palavra
		a <= x"00000010";
		wait for 10ns;
		
		-- acessa a sexta palavra
		a <= x"00000014";
		wait for 10ns;
		
		-- acessa a setima palavra
		a <= x"0000001c";
		wait;
	
	end process;
end sim;