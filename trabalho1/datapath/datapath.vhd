library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is 
	port(CLK, Reset, PCSrc, MemtoReg, ALUSrc,
		  RegDst, RegWrite, Jump: in std_logic;
		  ALUcontrol : in std_logic_vector(2 downto 0);
		  ReadData, Instr : in std_logic_vector(31 downto 0);
		  PC, ALUOut, WriteData : out std_logic_vector(31 downto 0);
		  Zero : out std_logic);
end datapath;

architecture synth of datapath is
	component mux2 is 
   port(d0, d1: in  STD_LOGIC_VECTOR(31 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	component rcadder is
   port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
        y:    out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	component regfile is 
   port(clk:         in  STD_LOGIC;
       we:           in  STD_LOGIC;
       ra1, ra2, wa: in  STD_LOGIC_VECTOR(4 downto 0);   -- enderecos de leitura e gravação
       wd:           in  STD_LOGIC_VECTOR(31 downto 0);  -- conteudo a ser gravado
       rd1, rd2:     out STD_LOGIC_VECTOR(31 downto 0)); -- portas de leitura
	end component;
	
	
	component register32 is 
   port(clk, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(31 downto 0);
       q:          out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	component signext is
   port(a: in  STD_LOGIC_VECTOR(15 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	component ula is 
   port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       result:     buffer STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
	end component;


	component sl2 is
   port(a: in  STD_LOGIC_VECTOR(31 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	
	component mux2_5 is 
   port(d0, d1: in  STD_LOGIC_VECTOR(4 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
	signal mux5Out : std_logic_vector(4 downto 0);
	signal sl2instrOut, muxJumpOut, PcOut, PcPlus4, SrcA, rd2Out, signextendOut,
	SrcB, AluOutSig, muxMemToRegOut, sl2signextendOut, RcJumpOut, muxSrcOut, sl2Mix : std_logic_vector(31 downto 0);
	
begin
	muxSrc: mux2 port map(s => PCSrc, d0 => PcPlus4, d1 => RcJumpOUt, y => muxSrcOut);
	
	muxJump: mux2 port map(s => Jump, d0 => muxSrcOut, d1 => sl2Mix, y => muxJumpOut);
	
	sl2instr: sl2 port map(a => Instr, y => sl2instrOut);
	
	PcReg : register32 port map(clk => CLK, reset => Reset, d => muxJumpOut, q => PcOut); 
	
	Rc4 : rcadder port map(a => pcOut, b => x"00000004", y => PcPlus4);
	
	mux5 : mux2_5 port map(d0 => Instr(20 downto 16), d1 => Instr(15 downto 11), s => RegDst, y => mux5Out);
	
	RegisterFile : regfile port map(clk => CLK, ra1 => Instr(25 downto 21), ra2 => Instr(20 downto 16),
	wa => mux5Out, we => RegWrite, rd1 => SrcA, rd2 => rd2Out, wd => muxMemToRegOut);
	
	signextend : signext port map(a => Instr(15 downto 0), y => signextendOut);
	
	muxAluSrc : mux2 port map(s => ALUSrc, d0 => rd2Out, d1 => signextendOut, y => SrcB);
	
	Alu : ula port map(a => SrcA, b => SrcB, alucontrol => ALUcontrol, zero => Zero, result => AluOutSig);
	
	muxMemToReg : mux2 port map(s => MemtoReg, d0 => AluOutSig, d1 => ReadData, y => muxMemToRegOut);
	
	sl2signextend : sl2 port map(a => signextendOut, y => sl2signextendOut);
	
	RcJump : rcadder port map(a => sl2signextendOut, b => PcPlus4, y => RcJumpOut);
	
	--criando sinal
	sl2Mix <= PcPlus4(31 downto 28) & sl2instrOut(27 downto 0);
	
	ALUOut <= AluOutSig;
	WriteData <= rd2Out;
	PC <= PcOut;

end synth;