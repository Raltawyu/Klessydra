Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;



ENTITY testbench IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
		);
END testbench;



ARCHITECTURE behav OF testbench IS
  
   -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT test
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7);
      PORT(W_EN, R_EN: IN std_logic;
           WADDR, RADDR: IN std_logic_vector(m-1 DOWNTO 0);
           WDATA: IN std_logic_vector(m-1 DOWNTO 0);
           RDATA: OUT std_logic_vector(m-1 DOWNTO 0));
    END COMPONENT;
    
    FOR uut: test USE
      ENTITY work.sram_d (behavioral);
    
   -- Input Declaration
    SIGNAL W_EN, R_EN: std_logic;
    SIGNAL WADDR, RADDR: std_logic_vector(m-1 DOWNTO 0);
    SIGNAL WDATA: std_logic_vector(m-1 DOWNTO 0);
   
   -- Output Declaration
    SIGNAL RDATA: std_logic_vector(m-1 DOWNTO 0);
    
   -- Clock Declaration
    SIGNAL clk: std_logic;
   
   -- Clock Period Definition
    CONSTANT clk_period : time := 1 ns;
   
   
   
BEGIN
  
  
  
  -- Unit Under Test(UUT) Instance
   uut: test 
    PORT MAP (  W_EN => W_EN,
                R_EN => R_EN,
                WADDR => WADDR,
                RADDR => RADDR,
                WDATA => WDATA,
                RDATA => RDATA );      

   -- Clock Process Definition
   clk_process: PROCESS
      BEGIN
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
   END PROCESS clk_process;
   
   -- Stimulus Process
   stim_proc: PROCESS
      BEGIN

	FOR ADDRESS IN 32767 DOWNTO 0 
	LOOP

		wait until clk'event AND clk = '1';
      
        
      	   	W_EN <= '1';
	        R_EN <= '0';
	        WADDR <= conv_std_logic_vector(ADDRESS, 32);
        	RADDR <= conv_std_logic_vector(ADDRESS/2, 32);
        	WDATA <= conv_std_logic_vector(ADDRESS/2, 32);
        	
		wait until clk'event AND clk = '1';
        
        	W_EN <= '0';
       	 	R_EN <= '1';
        	WADDR <= conv_std_logic_vector(ADDRESS/2, 32);
       	 	RADDR <= conv_std_logic_vector(ADDRESS, 32);
        	WDATA <= conv_std_logic_vector(ADDRESS/2, 32);
        
	END LOOP;
       
   END PROCESS stim_proc;

END behav;