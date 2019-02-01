Library ieee;
Library std;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use std.textio.all;


ENTITY testbench_SRAM_P IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
END testbench_SRAM_P;



ARCHITECTURE testbench OF testbench_SRAM_P IS
  
-- Component Declaration for the Unit Under Test (UUT)
COMPONENT SRAM_P
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7
	     );
      PORT(R_EN 	: IN std_logic;
           RADDR	: IN std_logic_vector(m-1 DOWNTO 0);
           RDATA	: OUT std_logic_vector(m-1 DOWNTO 0)
	   );
END COMPONENT SRAM_P;
    
FOR uut: SRAM_P USE ENTITY work.SRAM_P (behavioral);
 
-- Signal Declaration
SIGNAL R_EN_Signal	: std_logic;
SIGNAL RADDR_Signal	: std_logic_vector(m-1 DOWNTO 0);
SIGNAL RDATA_Signal	: std_logic_vector(m-1 DOWNTO 0);
   
SIGNAL clk		: std_logic;
   
CONSTANT clk_period 	: time := 1 ns;
   
   
BEGIN
  
uut: SRAM_P 
    PORT MAP (  R_EN	=>R_EN_Signal,	 
                RADDR	=>RADDR_Signal,
                RDATA 	=>RDATA_Signal 
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

	FOR ADDRESS IN 195 DOWNTO 90 LOOP

		R_EN_Signal 	<= '1';
		RADDR_Signal	<= conv_std_logic_vector(ADDRESS, m);
        	
		wait until clk'event AND clk = '1';

        END LOOP;
        
   END PROCESS stimulus_process;

dump_program_Process: PROCESS(RADDR_Signal,RDATA_Signal,clk)

	FILE Output_File		: TEXT OPEN WRITE_MODE IS "Dump_program_memory.txt";
	VARIABLE Current_File_Line	: LINE;
		
	BEGIN
	IF clk'event AND clk = '1' THEN
		
		WRITE (Current_File_Line, conv_integer(RADDR_Signal), RIGHT, m+5);
		HWRITE (Current_File_Line, RADDR_Signal, RIGHT, m+5);
		HWRITE (Current_File_Line, RDATA_Signal, RIGHT, m+5); 
		WRITELINE (Output_File, Current_File_Line);
				
	END IF;
					
   END PROCESS  dump_program_Process;


END testbench;