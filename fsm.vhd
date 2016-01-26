library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity comments_fsm is
port (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
end comments_fsm;

architecture behavioral of comments_fsm is

-- The ASCII value for the '/', '*' and end-of-line characters
constant SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
constant STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
constant NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

-- Define the states
type state_type is (Idle, Slash1, Slash2, LineCo, LineEnd, Star1, BlockCo, Star2, BlockEnd);
signal next_state, current_state: state_type;

begin

-- Insert your processes here
-- state registers
-- Go to Idle if reset. Else go to the next state on the rising edge.
state_reg: process (clk, reset)
begin
    if (reset='1') then
		current_state <= Idle;
	elsif (clk'event and clk='1') then
		current_state <= next_state;
	end if;
end process;

-- combinational logic to choose next state
comb_logic: process(current_state, input)
begin
	case current_state is
	
		when Idle =>	output <= '0';
						if input /= SLASH_CHARACTER then
							next_state <= Idle;
						else
							next_state <= Slash1;
						end if;

		when Slash1 =>	output <= '0';
						if (input /= SLASH_CHARACTER) or (input /= STAR_CHARACTER) then
							next_state <= Idle;
						elsif input = SLASH_CHARACTER then
							next_state <= Slash2;
						elsif input = STAR_CHARACTER then
							next_state <= Star1;
						end if;

		when Slash2 =>	output <= '0';
						if input = NEW_LINE_CHARACTER then
							next_state <= LineEnd;
						else
							next_state <= LineCo;
						end if;
		
		when LineCo =>	output <= '1';
						if input /= NEW_LINE_CHARACTER then
							next_state <= LineCo;
						else
							next_state <= LineEnd;
						end if;
		
		when LineEnd =>	output <= '1';
						if input = SLASH_CHARACTER then
							next_state <= Slash1;
						else
							next_state <= Idle;
						end if;
		
		when Star1 =>	output <= '0';
						if input = STAR_CHARACTER then
							next_state <= Star2;
						else
							next_state <= BlockCo;
						end if;
		
		when BlockCo =>	output <= '1';
						if input /= STAR_CHARACTER then
							next_state <= BlockCo;
						else
							next_state <= Star2;
						end if;

		when Star2 =>	output <= '1';
						if input /= SLASH_CHARACTER then
							next_state <= BlockCo;
						else
							next_state <= BlockEnd;
						end if;
		
		when BlockEnd =>	output <= '1';
							if input /= SLASH_CHARACTER then
								next_state <= Idle;
							else
								next_state <= Slash1;
							end if;

	end case;
end process;

end behavioral;