library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;


ENTITY Interface_D IS
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
	 clk_i				: IN  std_logic;
	 rst_ni				: IN  std_logic
	);       
END Interface_D;

 

ARCHITECTURE behav OF Interface_D IS
      

	SIGNAL	STATE, NEXT_STATE		: INTEGER :=0;
	
BEGIN



	


PROCESS (clk_I)
		
		BEGIN
		
			IF clk_i'event AND clk_i = '1' THEN
			
				STATE <= NEXT_STATE;		

			END IF;
 		
END PROCESS;



PROCESS (ALL)
		
		BEGIN

			CASE STATE IS 
					WHEN 0 =>	

							DATA_ERR_I <= '0';

							IF DATA_REQ_O = '1' AND DATA_WE_O = '0' THEN			-- READ MODE

								
								DATA_GNT_I <= '1';
								DATA_RVALID_I <= '0';
									
								DATA_RDATA_I <= RDATA_INT;
								RADDR_INT <= DATA_ADDR_O;
							 
								R_EN_INT <= '1';
								W_EN_INT <= '0';

							 	NEXT_STATE <= 1;
	
							ELSIF DATA_REQ_O = '1' AND DATA_WE_O = '1' THEN			-- WRITE MODE
				
								DATA_GNT_I <= '1';
								DATA_RVALID_I <= '0';
								
								WADDR_INT <= DATA_ADDR_O;
								
								R_EN_INT <= '0';
								W_EN_INT <= '1';

								NEXT_STATE <= 2;	

							ELSIF DATA_REQ_O = '0' THEN

								W_EN_INT <= 'Z';
								R_EN_int <= 'Z';	
								DATA_GNT_I <='0';
								
			 					DATA_RVALID_I <='0';  

								NEXT_STATE <= 0;

							END IF;
	
		
					WHEN 1 =>
							--READ MODE
								
							RADDR_INT <= DATA_ADDR_O;	
							DATA_RDATA_I <= RDATA_INT;
							R_EN_INT <= '1';
							W_EN_INT <= '0';
							DATA_GNT_I <= '1';
							DATA_RVALID_I <= '1';
						
							NEXT_STATE <= 0;

					
		
					WHEN 2 =>
							--WRITE MODE
								
							R_EN_INT <= '0';
							W_EN_INT <= '1';
							DATA_GNT_I <= '1';
							DATA_RVALID_I <= '1';  

							WDATA_int <= DATA_WDATA_O;					
								 
							--IF DATA_BE_O(0)='1' THEN
              						--	WDATA_int(7 DOWNTO 0) <= DATA_WDATA_O(7 DOWNTO 0);
             						--END IF;
              						--IF DATA_BE_O(1)='1' THEN
                					--	WDATA_int(15 DOWNTO 8) <= DATA_WDATA_O(15 DOWNTO 8);
              						--END IF;
              						--IF DATA_BE_O(2)='1' THEN
                					--	WDATA_int(23 DOWNTO 16) <= DATA_WDATA_O(23 DOWNTO 16);
             						-- END IF;
              						--IF DATA_BE_O(3)='1' THEN
                					--	WDATA_int(31 DOWNTO 24) <= DATA_WDATA_O(31 DOWNTO 24);
              						--END IF;
							
							NEXT_STATE <= 0;


					WHEN OTHERS => 
							 
							NEXT_STATE <= 0;

			END CASE;

END PROCESS;



    
END behav;	