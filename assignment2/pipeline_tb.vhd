LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behaviour OF pipeline_tb IS

COMPONENT pipeline IS
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk: STD_LOGIC := '0';
SIGNAL s_a, s_b, s_c, s_d, s_e : INTEGER := 0;
SIGNAL s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output : INTEGER := 0;

CONSTANT clk_period : time := 1 ns;

BEGIN
dut: pipeline
PORT MAP(clk, s_a, s_b, s_c, s_d, s_e, s_op1, s_op2, s_op3, s_op4, s_op5, s_final_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 

stim_process: PROCESS
BEGIN   
	--TODO: Stimulate the inputs for the pipelined equation ((a + b) * 42) - (c * d * (a - e)) and assert the results
	REPORT "Sanity check: testing a = 1, b = 2, c = 3, d = 4, e = 5";
	s_a <= 1;
	s_b <= 2;
	s_c <= 3;
	s_d <= 4;
	s_e <= 5;
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "Adding a + b = 1 + 2 did not produce 3" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "Multiplying c * d = 3 * 4 did not produce 12" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "Subtracting a - e = 1 - 5 did not produce -4" SEVERITY ERROR;
	--WAIT FOR 1 * clk_period;
	ASSERT (s_op2 = 126) REPORT "Multiplying op1 * 42 = 3 * 42 did not produce 126" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "Multiplying op3 * op4 = 12 * -4 did not produce -48" SEVERITY ERROR;
	--WAIT FOR 1 * clk_period;
	ASSERT (s_final_output = 174) REPORT "Subtracting op2 - op5 = 126 - (-48) did not produce 174" SEVERITY ERROR;
	
	REPORT "Changing b = 5";
	s_b <= 5;
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 6) REPORT "Adding a + b = 1 + 5 did not produce 6" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "Multiplying c * d = 3 * 4 did not produce 12" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "Subtracting a - e = 1 - 5 did not produce -4" SEVERITY ERROR;
	ASSERT (s_op2 = 252) REPORT "Multiplying op1 * 42 = 6 * 42 did not produce 252" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "Multiplying op3 * op4 = 12 * -4 did not produce -48" SEVERITY ERROR;
	ASSERT (s_final_output =300) REPORT "Subtracting op2 - op5 = 252 - (-48) did not produce 300" SEVERITY ERROR;

	WAIT;
END PROCESS stim_process;
END;
