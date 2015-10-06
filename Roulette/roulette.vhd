LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the top level template for Lab 2.  Use the schematic on Page 3
--  of the lab handout to guide you in creating this structural description.
--  The combinational blocks have already been designed in previous tasks,
--  and the spinwheel block is given to you.  Your task is to combine these
--  blocks, as well as add the various registers shown on the schemetic, and
--  wire them up properly.  The result will be a roulette game you can play
--  on your DE2.
--
-----------------------------------------------------------------------

ENTITY roulette IS
	PORT(   CLOCK_27 : IN STD_LOGIC; -- the fast clock for spinning wheel
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END roulette;


ARCHITECTURE structural OF roulette IS
  
  component digit7seg
    port (digit : in unsigned(3 downto 0); seg7 : out std_logic_vector(6 downto 0) );
  end component;
  
  component win
	 port (spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2 0 is black 1 is red
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
  end component;
  
  component spinwheel
	 port(
		fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		resetb : IN  STD_LOGIC;      -- asynchronous reset
		spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
  end component;
  
  component new_balance
	  port(money : in unsigned(11 downto 0);  -- Current balance before this spin
       value1 : in unsigned(2 downto 0);  -- Value of bet 1
       value2 : in unsigned(2 downto 0);  -- Value of bet 2
       value3 : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
   end component;                                       -- bets and subtracting losing bets
    
	component binarytobcd
		port( binIN : in std_logic_vector(11 downto 0);
			 bcd_out : out unsigned(15 downto 0));
	end component;
	 
  signal digit : unsigned(3 downto 0);
  signal balance : unsigned(11 downto 0);
  
  signal new_money : unsigned(11 downto 0);
  
  signal bet1_value : unsigned(5 downto 0);
  signal bet2_colour : std_logic;
  signal bet3_dozen : unsigned(1 downto 0);
  signal bet1_wins : std_logic;
  signal bet2_wins : std_logic;
  signal bet3_wins : std_logic;
  signal spin_result : unsigned(5 downto 0);
  signal spin_result_latched : unsigned(5 downto 0) := "000000";
  signal bet1_amount : unsigned(2 downto 0);
  signal bet2_amount : unsigned(2 downto 0);
  signal bet3_amount : unsigned(2 downto 0);
  
  signal resetb : std_LOGIC;
  
  signal ones : std_logic_vector(3 downto 0);
  signal tens : std_logic_vector(3 downto 0);
  signal hundreds : std_logic_vector(3 downto 0);
  signal binIN : std_LOGIC_VECTOR(11 downto 0);
  
  signal money_bcd : unsigned(15 downto 0);
  signal spin_result_bcd : unsigned(15 downto 0);
  
begin

	process(KEY(0))
		begin
		if rising_edge(KEY(0)) then
			spin_result_latched <= spin_result;
			bet1_value <= unsigned(SW(8 downto 3));
			bet2_colour <= SW(12);
			bet3_dozen <= unsigned(SW(17 downto 16));
			
			bet1_amount <= unsigned(SW(2 downto 0));
			bet2_amount <= unsigned(SW(11 downto 9));
			bet3_amount <= unsigned(SW(15 downto 13));
			
			balance <= new_money;
			
			if(resetb = '0') then
				bet1_value <= to_unsigned(0, 6);
				bet2_colour <= '0';
				bet3_dozen <= "00";
				
				bet1_amount <= to_unsigned(0, 3);
				bet2_amount <= to_unsigned(0, 3);
				bet3_amount <= to_unsigned(0, 3);
				
				balance <= to_unsigned(32, 12);
				
			end if;
			
		end if;
 		
	end process;
	
	resetb <= KEY(2);
	
	spinwheel0: spinwheel port map(CLOCK_27, resetb, spin_result );
	
	win_detect: win port map(spin_result_latched, bet1_value, bet2_colour, bet3_dozen, bet1_wins, bet2_wins, bet3_wins);
	
	new_balance_calc: new_balance port map(balance, bet1_amount, bet2_amount, bet3_amount, bet1_wins, bet2_wins, bet3_wins, new_money);
	
	LEDG(0) <= bet1_wins;
	LEDG(1) <= bet2_wins;
	LEDG(2) <= bet3_wins;
	
	
  --Current Balance Displays
  --disp1: digit7seg port map(unsigned(new_money(11 downto 8)), HEX2);
  --disp2: digit7seg port map(unsigned(new_money(7 downto 4)), HEX1);
  --disp3: digit7seg port map(unsigned(new_money(3 downto 0)), HEX0);
  
  money_bcd_conv : binarytobcd port map(std_logic_vector(new_money), money_bcd);
  spin_bcd_conv : binarytobcd port map(std_logic_vector(spin_result_latched), spin_result_bcd);
  disp1: digit7seg port map(unsigned(ones), HEX0);
  disp2: digit7seg port map(unsigned(tens), HEX1);
  disp3: digit7seg port map(unsigned(hundreds), HEX2);
  
  --Spin Result Registers
  disp4: digit7seg port map( "00" & spin_result_latched(5 downto 4), HEX7);
  disp5: digit7seg port map( spin_result_latched(3 downto 0), HEX6);
  
  binIN <= std_logic_vector(new_money);
  
  
  
  

END;
























