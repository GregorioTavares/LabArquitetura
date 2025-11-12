library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_mem is
   port(a: in std_logic_vector(31 downto 0);   -- Parramento de end.
	     rd: out std_logic_vector(31 downto 0)); -- Barramento de dados
end instruction_mem;

architecture synth of instruction_mem is
   type rom_type is array (0 to 63) of std_logic_vector(31 downto 0);
	signal mem: rom_type :=(
	0 => x"20020005",
	1 => x"2003000c",
	2 => x"2067fff7",
	3 => x"00e22025",
	4 => x"00642824",
	5 => x"00a42820",
	6 => x"10a7000a",
	7 => x"0064202a", others => (others => '0')); -- Define a memoria
	
	-- Para inicializar a memoria
	--attribute rom_init_file: string; -- Nome do arquivo
	--attribute rom_init_file of mem: signal is "programa.mif";
begin
   -- Leitura combinacional
   rd <= mem(to_integer(unsigned(a(7 downto 2))));  
end synth;