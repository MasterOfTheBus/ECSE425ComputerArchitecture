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
	signal op1_sig: integer;
	signal op3_sig: integer;
	signal op4_sig: integer;
	signal op2_sig_42: integer;
	signal op5_sig: integer;

begin
-- todo: complete this
process (clk)
	op1 <= a + b; -- wrong
	op3 <= c * d;
	op4 <= a - e;

	op2 <= op1
begin
end process;

end behavioral;