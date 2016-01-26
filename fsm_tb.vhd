LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behaviour OF fsm_tb IS

COMPONENT comments_fsm IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;
CONSTANT SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
CONSTANT STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
CONSTANT NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

BEGIN
dut: comments_fsm
PORT MAP(clk, s_reset, s_input, s_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 
--TODO: Thoroughly test your FSM
stim_process: PROCESS
BEGIN    
	REPORT "Example case, reading a meaningless character";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";
    
	-- line comment tests
	
	REPORT "Test line comment success: //abc\n";
	REPORT "_______________________";
	
	REPORT "Test line comment success: ab//c\n";
	REPORT "_______________________";
	
	REPORT "Test line comment multiple lines: //a\nb //c\n";
	REPORT "_______________________";
	
	REPORT "Test line comment // in comment: //a//b\n";
	REPORT "_______________________";
	
	REPORT "Test line comment multiple /: //////\n";
	REPORT "_______________________";
	
	REPORT "Test line comment empty: //\n";
	REPORT "_______________________";
	
	REPORT "Test line comment multiple new line: //abc\n\n";
	REPORT "_______________________";
	
	REPORT "Test line comment single slash: /abc\n";
	REPORT "_______________________";
	
	REPORT "Test line comment consecutive comments: //\n//\n";
	REPORT "_______________________";
	
	REPORT "Test line comment: /a/bc\n";
	REPORT "_______________________";
	
	-- block comment tests
	
	REPORT "Test block comment success: /*abc*/";
	REPORT "_______________________";
	
	REPORT "Test block comment success: ab/*c*/";
	REPORT "_______________________";
	
	REPORT "Test block comment empty comment: /**/";
	REPORT "_______________________";
	
	REPORT "Test block comment multiple lines: /*a\n\na*/";
	REPORT "_______________________";
	
	REPORT "Test block comment multiple stars: /*****/";
	REPORT "_______________________";
	
	REPORT "Test block comment middle star: /*a*c*/";
	REPORT "_______________________";
	
	REPORT "Test block comment consecutive comments: /**//**/";
	REPORT "_______________________";
	
	REPORT "Test block comment missing star: /*abc/";
	REPORT "_______________________";
	
	REPORT "Test block comment: /*a*b/";
	REPORT "_______________________";
	
	REPORT "Test block comment: /a*bc*/";
	REPORT "_______________________";
	
	-- combined tests
	
	REPORT "Test line comment followed by block comment: //\n/**/";
	REPORT "_______________________";
	
	REPORT "Test block comment followed by line comment: /**///\n";
	REPORT "_______________________";
	
	REPORT "Test: /*a*//a\n";
	REPORT "_______________________";
	
	REPORT "Test: /*//\n*/";
	REPORT "_______________________";
	
	REPORT "Test: ///**/\n";
	REPORT "_______________________";
	
	WAIT;
END PROCESS stim_process;
END;
