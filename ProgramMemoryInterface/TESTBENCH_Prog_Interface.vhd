Library ieee;
Library STD;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use std.textio.all;


ENTITY Testbench_Interface_Program_SRAM IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
END Testbench_Interface_Program_SRAM;


ARCHITECTURE behav OF Testbench_Interface_Program_SRAM IS
  
COMPONENT SRAM_P 
     GENERIC(N: INTEGER:=15;
             m: INTEGER:=32;
             K: INTEGER:=7
	     );
  PORT(R_EN	: IN std_logic;
       RADDR	: IN std_logic_vector(m-1 DOWNTO 0);
       RDATA	: OUT std_logic_vector(m-1 DOWNTO 0)
       );
END COMPONENT SRAM_P; 


COMPONENT Interface_P
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7
	      );
      PORT(INSTR_REQ_O					: IN std_logic;
           INSTR_ADDR_O					: IN std_logic_vector(m-1 DOWNTO 0);
           INSTR_RDATA_I				: OUT std_logic_vector(m-1 DOWNTO 0);
           INSTR_RVALID_I, INSTR_GNT_I			: OUT std_logic; 
  	   R_EN_INT					: OUT std_logic;
           RADDR_INT					: OUT std_logic_vector(m-1 DOWNTO 0);
           RDATA_INT					: IN std_logic_vector(m-1 DOWNTO 0);
	   clk_i, rst_ni  				: IN  std_logic
	  );
END COMPONENT Interface_P;


file Program_interface: text; 
file SRAM_Program : text;
 

SIGNAL INSTR_REQ_O_s			:  std_logic;
SIGNAL INSTR_ADDR_O_s			:  std_logic_vector(m-1 DOWNTO 0);       
SIGNAL INSTR_RDATA_I_s			:  std_logic_vector(m-1 DOWNTO 0);
SIGNAL INSTR_RVALID_I_s		 	:  std_logic; 
SIGNAL INSTR_GNT_I_s			:  std_logic; 
SIGNAL R_EN_INT_s			:  std_logic;
SIGNAL RADDR_INT_s			:  std_logic_vector(m-1 DOWNTO 0);
SIGNAL RDATA_INT_s			:  std_logic_vector(m-1 DOWNTO 0);

SIGNAL clk				: std_logic;
SIGNAl reset				: std_logic;

CONSTANT clk_period 			: time := 1 ns;		-- Clock Period Definition

   
BEGIN
  

blocco_1: Interface_P
      PORT MAP (  INSTR_REQ_O    => INSTR_REQ_O_s,		
                  INSTR_ADDR_O   => INSTR_ADDR_O_s,
                  INSTR_RDATA_I  => INSTR_RDATA_I_s,
                  INSTR_RVALID_I => INSTR_RVALID_I_s,
                  INSTR_GNT_I    => INSTR_GNT_I_s,
                  R_EN_INT       => R_EN_INT_s,
                  RADDR_INT      => RADDR_INT_s,
                  RDATA_INT      => RDATA_INT_s,
		  clk_i		 => clk,
		  rst_ni	 => reset
		  );
  
blocco_2: SRAM_P 
     PORT MAP ( R_EN    => R_EN_INT_s,
                RADDR   => RADDR_INT_s,
                RDATA   => RDATA_INT_s
		);      


-- Clock Process Definition
clk_process: PROCESS
      BEGIN
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
   END PROCESS clk_process;
   

-- Stimulus Process
stimulus_process: PROCESS
      BEGIN
	
	reset <='0';
	wait until clk'event AND clk = '1';
	INSTR_REQ_O_s 	<= '0';
	INSTR_ADDR_O_s	<= x"0000005C";

	FOR ADDRESS IN 195 DOWNTO 90 LOOP

		wait until clk'event AND clk = '1';
		wait until clk'event AND clk = '1';
		INSTR_REQ_O_s 	<= '1';
		INSTR_ADDR_O_s	<= conv_std_logic_vector(ADDRESS, m);	
	
	END LOOP;

	

   END PROCESS stimulus_process;

file_log_Process: PROCESS(INSTR_ADDR_O_s,INSTR_RDATA_I_s, clk)

	FILE Output_File	: TEXT OPEN WRITE_MODE IS "Program_Memory_Interface_LOG.txt";
	--FILE Input_File	: TEXT OPEN READ_MODE IS "Inizialization_Program_Memory.txt";
	VARIABLE Current_File_Line	: LINE;
	--VARIABLE Line_Read		: std_logic_vector(m-1 downto 0);		
			
	BEGIN
	IF clk'event AND clk = '1' THEN
		--IF INSTR_GNT_I_s = '1' AND INSTR_RVALID_I_s = '1' THEN

		--READLINE (Input_File, Current_File_Line);
		--HREAD (Current_File_Line, Line_Read);
		--HWRITE (Current_File_Line, Line_Read, Right, m+5);

		WRITE (Current_File_Line, conv_integer(INSTR_ADDR_O_s), RIGHT, m+5);
		HWRITE (Current_File_Line, INSTR_ADDR_O_s, RIGHT, m+5);
		HWRITE (Current_File_Line, INSTR_RDATA_I_s, RIGHT, m+5); 
		WRITELINE (Output_File, Current_File_Line);
				
		
	END IF;
					
  END PROCESS  file_log_Process;


END behav;