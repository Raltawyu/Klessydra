Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;



ENTITY Interface_P IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
    PORT(INSTR_REQ_O		: IN std_logic;
         INSTR_ADDR_O		: IN std_logic_vector(m-1 DOWNTO 0);
         INSTR_RDATA_I		: OUT std_logic_vector(m-1 DOWNTO 0);
         INSTR_RVALID_I		: OUT std_logic;
	 INSTR_GNT_I		: OUT std_logic;
         R_EN_int		: OUT std_logic;
	 RADDR_int		: OUT std_logic_vector(m-1 DOWNTO 0);
         RDATA_int		: IN std_logic_vector(m-1 DOWNTO 0);
	 clk_i, rst_ni		: IN std_logic
	);       
END Interface_P;



ARCHITECTURE behav OF Interface_P IS
  
CONSTANT boot_address: std_logic_vector(m-1 DOWNTO 0) := x"000000C0";	-- boot_address


      

	SIGNAL	STATE, NEXT_STATE		: INTEGER :=0;
	SIGNAL  ADDRESS				: std_logic_vector (31 downto 0);

BEGIN



	


PROCESS (clk_i)
		
		BEGIN
			
			IF clk_i'event AND clk_i = '1' THEN
			
				STATE <= NEXT_STATE;		

			END IF;
 		
END PROCESS;



PROCESS (ALL)
		
		BEGIN

			CASE STATE IS 
					WHEN 0 =>	
							IF INSTR_REQ_O = '1' THEN	

								R_EN_int <= '1';
								INSTR_GNT_I <='1';
								INSTR_RVALID_I <='0';
								ADDRESS <=  INSTR_ADDR_O;
								INSTR_RDATA_I <=  X"ZZZZZZZZ"; 								
								 
								NEXT_STATE <= 1;	

							ELSE

								R_EN_int <= '0';	
								INSTR_GNT_I <='0';
								INSTR_RDATA_I <=  X"ZZZZZZZZ";  
			 					INSTR_RVALID_I <='0';   
								
								NEXT_STATE <= 0;

							END IF;
		
					WHEN 1 =>

							RADDR_int <= ADDRESS;
							R_EN_int <= '1';
							INSTR_GNT_I <='1';
							INSTR_RDATA_I <= RDATA_int;
			  				INSTR_RVALID_I <='1';
							
							NEXT_STATE <= 0;

					WHEN OTHERS => 

							NEXT_STATE <= 0;

			END CASE;

END PROCESS;



    
END behav;