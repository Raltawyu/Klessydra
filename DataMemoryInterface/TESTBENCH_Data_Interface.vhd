Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use std.textio.all;


ENTITY Testbench_Interface_Data_SRAM IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
END Testbench_Interface_Data_SRAM;


ARCHITECTURE behav OF Testbench_Interface_Data_SRAM IS
  
COMPONENT SRAM_D IS
  GENERIC(N: INTEGER:=15;
          m: INTEGER:=32;
          K: INTEGER:=7
	  );
  PORT(W_EN, R_EN	: IN std_logic;
       WADDR, RADDR	: IN std_logic_vector(m-1 DOWNTO 0);
       WDATA		: IN std_logic_vector(m-1 DOWNTO 0);
       RDATA		: OUT std_logic_vector(m-1 DOWNTO 0)
       );
END COMPONENT SRAM_D;


COMPONENT Interface_D IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
    PORT(DATA_REQ_O, DATA_WE_O		: IN std_logic;
         DATA_WDATA_O			: IN std_logic_vector(m-1 DOWNTO 0);
         DATA_ADDR_O			: IN std_logic_vector(m-1 DOWNTO 0);
         DATA_BE_O			: IN std_logic_vector(3 DOWNTO 0);
         DATA_RDATA_I			: OUT std_logic_vector(m-1 DOWNTO 0);
         DATA_RVALID_I, DATA_GNT_I	: OUT std_logic;
	 DATA_ERR_I			: OUT std_logic;
         W_EN_int, R_EN_int		: OUT std_logic;
         WADDR_int			: OUT std_logic_vector(m-1 DOWNTO 0);
	 RADDR_int			: OUT std_logic_vector(m-1 DOWNTO 0);
         WDATA_int			: OUT std_logic_vector(m-1 DOWNTO 0);
         RDATA_int			: IN std_logic_vector(m-1 DOWNTO 0);
	 clk_i, rst_ni  		: IN  std_logic
	);       
END COMPONENT Interface_D;


file SRAM_Data: text; 
file Data_interface : text;


SIGNAL   DATA_REQ_O_signal, DATA_WE_O_signal				: std_logic;
SIGNAL   DATA_WDATA_O_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   DATA_ADDR_O_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   DATA_BE_O_signal						: std_logic_vector(3 DOWNTO 0);
SIGNAL   DATA_RDATA_I_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   DATA_RVALID_I_signal, DATA_GNT_I_signal, DATA_ERR_I_signal	: std_logic;
SIGNAL   W_EN_int_signal, R_EN_int_signal				: std_logic;
SIGNAL   WADDR_int_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   RADDR_int_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   WDATA_int_signal						: std_logic_vector(m-1 DOWNTO 0);
SIGNAL   RDATA_int_signal						: std_logic_vector(m-1 DOWNTO 0);  



SIGNAL   DATA_WDATA_O_signal_old					: std_logic_vector(m-1 DOWNTO 0);		-- for testbench assert check


SIGNAL clk	: std_logic;
SIGNAl reset	: std_logic;
   
CONSTANT clk_period : time := 1 ns; 	-- Clock Period Definition
   

BEGIN
  
blocco_1: Interface_D
      PORT MAP (  DATA_REQ_O    => DATA_REQ_O_signal,
		  DATA_WE_O     => DATA_WE_O_signal,
		  DATA_WDATA_O  => DATA_WDATA_O_signal,		
                  DATA_ADDR_O   => DATA_ADDR_O_signal,
                  DATA_BE_O     =>  DATA_BE_O_signal,
                  DATA_RDATA_I  => DATA_RDATA_I_signal,
                  DATA_RVALID_I => DATA_RVALID_I_signal,
                  DATA_GNT_I    => DATA_GNT_I_signal,
                  DATA_ERR_I    =>  DATA_ERR_I_signal,
		  W_EN_int      => W_EN_int_signal,
                  R_EN_int      =>  R_EN_int_signal,
		  WADDR_int     => WADDR_int_signal,
		  WDATA_int     => WDATA_int_signal,
                  RADDR_int     =>  RADDR_int_signal,
                  RDATA_int     =>  RDATA_int_signal,
		  clk_i		=> clk,
		  rst_ni	=> reset
		 );
  

blocco_2: SRAM_D 
    PORT MAP (    W_EN 	=>  W_EN_int_signal,
		  R_EN 	=>  R_EN_int_signal,
                  WADDR	=>  WADDR_int_signal, 
		  RADDR =>  RADDR_int_signal,
                  WDATA	=>  WDATA_int_signal,
      		  RDATA	=>  RDATA_int_signal
		  );      


-- Clock Process Definition
clk_process: PROCESS
      	BEGIN
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
   END PROCESS clk_process;
 

-- Stimulus Process Definition
stimulus_process: PROCESS
      BEGIN
	
	
		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';


	FOR ADDRESS IN 32765 DOWNTO 0
	LOOP
        
		
		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';

		--write mode
		DATA_WE_O_signal 		<= '1';
		DATA_REQ_O_signal 		<= '1';
		DATA_ADDR_O_signal		<=  conv_std_logic_vector(ADDRESS, 32);
		DATA_WDATA_O_signal 	<=  conv_std_logic_vector(ADDRESS-100, 32);
		
        
		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';

		--read mode
		DATA_REQ_O_signal 			<= '1';
		DATA_WE_O_signal			<= '0';
		DATA_ADDR_O_signal			<=  conv_std_logic_vector(ADDRESS, 32);
 		DATA_WDATA_O_signal_old		<=  conv_std_logic_vector(ADDRESS-100, 32);
             
      		
  	  

		-- assert check -- 
		
		FOR i IN 31 DOWNTO 0
		LOOP					
			ASSERT DATA_RDATA_I_signal(i) = DATA_WDATA_O_signal_old(i) 
			REPORT "_____Wrong values have been read from DATA_SRAM. There's been no matching between written and read values _____"
			SEVERITY FAILURE;
		END LOOP;		
        	
		-- end assert check --

		

	END LOOP;

END PROCESS stimulus_process;


END behav;