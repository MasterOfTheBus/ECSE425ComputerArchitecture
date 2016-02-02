LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE behaviour OF fsm_tb IS

COMPONENT comments_fsm IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
	  --state	: out std_logic_vector(3 downto 0); -- debug purposes
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');
--SIGNAL s_state: std_logic_vector(3 downto 0) := (others => '0'); -- debug purposes

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
	
	-- test generic success, test // in comment, test empty comment, test newline after comment, test consecutive comments
	REPORT "Test line comment success: //a//\n//\n\n";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the second slash, the output should be '0'" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a character in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a slash in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a slash in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "For a new line in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the second slash, the output should be '0'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the new line character, the output should be '1'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Reading new line outside of a comment, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- test fail
	REPORT "Test line comment single slash: /\n";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the new line outside a comment, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- block comment tests
	
	-- test generic success, test new line, test /**/ in comment, test consecutive comments, test empty comment
	REPORT "Test block comment success: /*a/**/\n*//**/a";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first star, the output should be '0'" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a character in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Characters in comments should have output '1'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Characters in comments should have output '1'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Characters in comments should have output '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "Characters in comments should have output '1'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the new line character, the output should be '1'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end star, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end slash, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first star, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end star, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end slash, the output should be '1'" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- test fail
	REPORT "Test block comment missing star: /*/";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a slash in a comment, the output should be '1'" SEVERITY ERROR;
	s_input <= "01011000";
	s_reset <= '1';
	WAIT FOR 1 * clk_period;
	s_reset <= '0';
	ASSERT (s_output = '0') REPORT "Reset output failed" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- combined tests
	
	REPORT "Test line comment followed by block comment: //\n/**/";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the second slash, the output should be '0'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the new line character, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first star, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end star, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end slash, the output should be '1'" SEVERITY ERROR;
	REPORT "_______________________";
	
	REPORT "Test block comment followed by line comment: /**///\n";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first star, the output should be '0'" SEVERITY ERROR;
	s_input <= STAR_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end star, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the end slash, the output should be '1'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the second slash, the output should be '0'" SEVERITY ERROR;
	s_input <= NEW_LINE_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading the new line character, the output should be '1'" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- test reset
	
	REPORT "Testing reset line";
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the first slash, the output should be '0'" SEVERITY ERROR;
	s_input <= SLASH_CHARACTER;
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading the second slash, the output should be '0'" SEVERITY ERROR;
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '1') REPORT "When reading a character in a comment, the output should be '1'" SEVERITY ERROR;
	s_reset <= '1';
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "Reset failed" SEVERITY ERROR;
	REPORT "_______________________";
	
	WAIT;
END PROCESS stim_process;
END;
