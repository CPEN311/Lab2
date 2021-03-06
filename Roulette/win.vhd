LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a skeleton you can use for the win subblock.  This block determines
--  whether each of the 3 bets is a winner.  As described in the lab
--  handout, the first bet is a "straight-up" bet, teh second bet is 
--  a colour bet, and the third bet is a "dozen" bet.
--
--  This should be a purely combinational block.  There is no clock.
--  Remember the rules associated with Pattern 1 in the lectures.
--
---------------------------------------------------------------

ENTITY win IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2 0 is black 1 is red
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
END win;


ARCHITECTURE behavioural OF win IS
  
 constant dozen_1_range : unsigned(5 downto 0) := "001100";
 constant dozen_2_range : unsigned(5 downto 0) := "011000";
 constant dozen_3_range : unsigned(5 downto 0) := "100000";
 
  
BEGIN
--  Your code goes here

  process(all)
    begin
      
      if bet1_value = spin_result_latched then
        bet1_wins <= '1';
      else
        bet1_wins <= '0';
      end if;
      
      
      case bet2_colour is
        when '0' => --black
          if (spin_result_latched > 0) and (spin_result_latched <=10) and (spin_result_latched(0) = '0') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 10) and (spin_result_latched <= 18) and (spin_result_latched(0) = '1') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 18) and (spin_result_latched <= 28) and (spin_result_latched(0) = '0') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 28) and (spin_result_latched(0) = '1') then
            bet2_wins <= '1';
          else 
            bet2_wins <= '0';
          end if; 
          
        when '1' => --red
          if (spin_result_latched > 0) and (spin_result_latched <=10) and (spin_result_latched(0) = '1') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 10) and (spin_result_latched <= 18) and (spin_result_latched(0) = '0') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 18) and (spin_result_latched <= 28) and (spin_result_latched(0) = '1') then
            bet2_wins <= '1';
          elsif (spin_result_latched > 28) and (spin_result_latched(0) = '0') then
            bet2_wins <= '1';
          else 
            bet2_wins <= '0';
          end if; 
        when others => bet2_wins <= '0';     
      end case;
      
      case bet3_dozen is
        when "00" =>
          if (spin_result_latched > 0) and (spin_result_latched <= dozen_1_range) then
            bet3_wins <= '1';
          else
            bet3_wins <= '0';
          end if;
          
        when "01" =>
          if (spin_result_latched > dozen_1_range) and (spin_result_latched <= dozen_2_range) then
            bet3_wins <= '1';
          else
            bet3_wins <= '0';
          end if;   
                 
        when "10" =>
          if (spin_result_latched > dozen_2_range) then
            bet3_wins <= '1';
          else
            bet3_wins <= '0';
          end if; 
        
        when others => bet3_wins <= '0';         
      end case;    
    
  end process;

END;















