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
	WAIT FOR 2 * clk_period; -- Need to wait for 2 cycles for the data to propagate (?)
	ASSERT (s_op1 = 3) REPORT "Adding a + b = 1 + 2 did not produce 3" SEVERITY ERROR;
	ASSERT (s_op2 = 0) REPORT "Computation for op2 should not have propagated yet" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "Multiplying c * d = 3 * 4 did not produce 12" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "Subtracting a - e = 1 - 5 did not produce -4" SEVERITY ERROR;
	ASSERT (s_op5 = 0) REPORT "Computation for op5 should not have propagated yet" SEVERITY ERROR;
	ASSERT (s_final_output = 0) REPORT "Computation for final_output should not have propagated yet" SEVERITY ERROR;
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "op1 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op2 = 126) REPORT "Multiplying op1 * 42 = 3 * 42 did not produce 126" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "Multiplying op3 * op4 = 12 * -4 did not produce -48" SEVERITY ERROR;
	ASSERT (s_final_output = 0) REPORT "Computation for final_output should not have propagated yet" SEVERITY ERROR;
	WAIT FOR 1 * clk_period;
	ASSERT (s_op1 = 3) REPORT "op1 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op2 = 126) REPORT "op2 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 174) REPORT "Subtracting op2 - op5 = 126 - (-48) did not produce 174" SEVERITY ERROR;
	
	REPORT "Changing b = 5";
	s_b <= 5;
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 3) REPORT "computation for op1 should not have propagated yet" SEVERITY ERROR;
	ASSERT (s_op2 = 126) REPORT "computation for op2 should not have propagated yet" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 174) REPORT "Computation for final_output should not have propagated yet" SEVERITY ERROR;
	
	REPORT "Changing a = 3, c = 2";
	s_a <= 3;
	s_c <= 2;
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 6) REPORT "Adding a + b = 1 + 5 did not produce 6" SEVERITY ERROR;
	ASSERT (s_op2 = 126) REPORT "computation for op2 should not have propagated yet" SEVERITY ERROR;
	ASSERT (s_op3 = 12) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = -4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 174) REPORT "Computation for final_output should not have propagated yet" SEVERITY ERROR;

	REPORT "Changing d = 2, e = 3";
	s_b <= 1;
	s_d <= 2;
	s_e <= 3;
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 8) REPORT "Adding a + b = 3 + 5 did not produce 8" SEVERITY ERROR;
	ASSERT (s_op2 = 252) REPORT "Multiplying op1 * 42 = 6 * 42 did not produce 252" SEVERITY ERROR;
	ASSERT (s_op3 = 8) REPORT "Multiplying c * d = 2 * 4 did not produce 8" SEVERITY ERROR;
	ASSERT (s_op4 = -2) REPORT "Subtracting a - e = 3 - 5 did not produce -2" SEVERITY ERROR;
	ASSERT (s_op5 = -48) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 174) REPORT "Computation for final_output should not have propagated yet" SEVERITY ERROR;
	
	REPORT "Changing a = 5, b = 4, c = 3, d = 2, e = 1";
	s_a <= 5;
	s_b <= 4;
	s_c <= 3;
	s_d <= 2;
	s_e <= 1;
	WAIT FOR 1 * clk_period;

	ASSERT (s_op1 = 4) REPORT "Adding a + b = 3 + 1 did not produce 4" SEVERITY ERROR;
	ASSERT (s_op2 = 336) REPORT "Multiplying op1 * 42 = 8 * 42 did not produce 336" SEVERITY ERROR;	
	ASSERT (s_op3 = 4) REPORT "Multiplying c * d = 2 * 2 did not produce 4" SEVERITY ERROR;
	ASSERT (s_op4 = 0) REPORT "Subtracting a - e = 3 - 3 did not produce 0" SEVERITY ERROR;
	ASSERT (s_op5 = -16) REPORT "Multiplying op3 * op4 = 8 * -2 did not produce -16" SEVERITY ERROR;
	ASSERT (s_final_output = 300) REPORT "Subtracting op2 - op5 = 252 - (-48) did not produce 300" SEVERITY ERROR;

	REPORT "Let the pipeline drain; don't add any more inputs";
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 9) REPORT "Adding a + b = 5 + 4 did not produce 9" SEVERITY ERROR;
	ASSERT (s_op2 = 168) REPORT "Multiplying op1 * 42 = 4 * 42 did not produce 168" SEVERITY ERROR;
	ASSERT (s_op3 = 6) REPORT "Multiplying c * d = 3 * 2 did not produce 6" SEVERITY ERROR;
	ASSERT (s_op4 = 4) REPORT "Subtracting a - e = 5 - 1 did not produce 4" SEVERITY ERROR;
	ASSERT (s_op5 = 0) REPORT "Multiplying op3 * op4 = 4 * 0 did not produce 0" SEVERITY ERROR;
	ASSERT (s_final_output = 352) REPORT "Subtracting op2 - op5 = 336 - (-16) did not produce 352" SEVERITY ERROR;
	
	REPORT "Drain time + 1";
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 9) REPORT "op1 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op2 = 378) REPORT "Multiplying op1 * 42 = 9 * 42 did not produce 378" SEVERITY ERROR;	
	ASSERT (s_op3 = 6) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = 4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = 24) REPORT "Multiplying op3 * op4 = 6 * 4 did not produce 24" SEVERITY ERROR;
	ASSERT (s_final_output = 168) REPORT "Subtracting op2 - op5 = 168 - (0) did not produce 168" SEVERITY ERROR;
	
	REPORT "Drain time + 2";
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 9) REPORT "op1 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op2 = 378) REPORT "op2 should not have any new inputs" SEVERITY ERROR;	
	ASSERT (s_op3 = 6) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = 4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = 24) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 354) REPORT "Subtracting op2 - op5 = 378 - 24 did not produce 354" SEVERITY ERROR;
	
	REPORT "Drain time + 3";
	WAIT FOR 1 * clk_period;
	
	ASSERT (s_op1 = 9) REPORT "op1 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op2 = 378) REPORT "op2 should not have any new inputs" SEVERITY ERROR;	
	ASSERT (s_op3 = 6) REPORT "op3 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op4 = 4) REPORT "op4 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_op5 = 24) REPORT "op5 should not have any new inputs" SEVERITY ERROR;
	ASSERT (s_final_output = 354) REPORT "final_output should not have any new inputs" SEVERITY ERROR;
	
	WAIT;
END PROCESS stim_process;
END;
