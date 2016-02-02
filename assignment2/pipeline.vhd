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

	-- define the temp signals
	signal stage: integer := 0;
	signal op1_sig: integer := 0;
	signal op3_sig: integer := 0;
	signal op4_sig: integer := 0;
	signal op2_sig: integer := 0;
	signal op5_sig: integer := 0;

begin
-- todo: complete this
	
process (clk)

begin
	if (rising_edge(clk)) then
		for stage in 0 to 2 loop
			case stage is
				when 0 =>	op1_sig <= a + b;
							op3_sig <= c * d;
							op4_sig <= a - e;
							
							op1 <= op1_sig;
							op3 <= op3_sig;
							op4 <= op4_sig;
							
				when 1 =>	op2_sig <= op1_sig * 42;
							op5_sig <= op3_sig * op4_sig;
							
							op2 <= op2_sig;
							op5 <= op5_sig;
							
				when 2 =>	final_output <= op2_sig - op5_sig;
				when others => null;
			end case;
		end loop;
	end if;
end process;

end behavioral;