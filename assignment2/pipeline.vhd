library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline is
port (clk : in std_logic;
      a, b, c, d, e : in integer;
      op1, op2, op3, op4, op5, final_output : out integer
  );
end pipeline;

architecture behavioral of pipeline is
begin
-- todo: complete this
process (clk)

	variable op1_var: integer;
	variable op3_var: integer;
	variable op4_var: integer;
	variable op2_var: integer;
	variable op5_var: integer;

begin
	op1_var := a + b;
	op1 <= op1_var;
	
	op3_var := c * d;
	op3 <= op3_var;
	
	op4_var := a - e;
	op4 <= op4_var;
	
	op2_var := op1_var * 42;
	op2 <= op2_var;
	
	op5_var := op3_var * op4_var;
	op5 <= op5_var;
	
	final_output <= op2_var - op5_var;
end process;

end behavioral;