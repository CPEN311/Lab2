LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
-- Skeleton file for new_balance subblock.  This block is purely
-- combinational (think Pattern 1 in the slides) and calculates the
-- new balance after adding winning bets and subtracting losing bets.
--
---------------------------------------------------------------


ENTITY new_balance IS
  PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
       value1 : in unsigned(2 downto 0);  -- Value of bet 1
       value2 : in unsigned(2 downto 0);  -- Value of bet 2
       value3 : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                -- bets and subtracting losing bets
END new_balance;


ARCHITECTURE behavioural OF new_balance IS
	-- signal win_money_1 = unsigned(9 downto 0);
	-- signal win_money_2 = unsigned(9 downto 0);
	-- signal win_money_3 = unsigned(9 downto 0);
BEGIN
	process(value1, value2, value3, bet1_wins, bet2_wins, bet3_wins)

		variable	win_money_1 : unsigned(7 downto 0);
		variable win_money_2 : unsigned(2 downto 0);
		variable win_money_3 : unsigned(4 downto 0);
		variable thirtyfive : integer := 35;
		begin 
	
			if bet1_wins = '1' then
				win_money_1 := to_unsigned(35, 5)*value1;
				
			else
				win_money_1 := to_unsigned(0, win_money_1'length)-value1;
			
			end if;
			
			if bet2_wins = '1' then
				win_money_2 := value2;
			else
				win_money_2 := to_unsigned(0, win_money_2'length)-value2;

			end if;
			
			if bet3_wins = '1' then
				win_money_3 := to_unsigned(2, 2)*value2;
				
			else 
				win_money_3 := to_unsigned(0, win_money_3'length)-value3;

			end if;
		new_money <= money + win_money_1+win_money_2+win_money_3;
  
  end process;
  
END;
