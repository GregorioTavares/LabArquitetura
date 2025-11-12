library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is 
	port(CLK, Reset, ALUcontrol, Zero, PCSrc, 
		  MemtoReg, ALUSrc, RegDst, RegWrite: in std_logic;
		  ReadData, Instr : in std_logic_vector(31 downto 0);
		  PC, ALUOut, WriteData : out std_logic_vector(31 downto 0));
end datapath;

