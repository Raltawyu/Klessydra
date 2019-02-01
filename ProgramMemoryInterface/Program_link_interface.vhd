Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use std.textio.all;



ENTITY Program_memory IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7;
 	    gnt_latency : integer := 1; -- zero means the same cycle as req
            val_latency : integer := 0  -- zero means the next cycle after gnt
	    );
    PORT( INSTR_RDATA_I	 		: OUT std_logic_vector(m-1 DOWNTO 0);
	  INSTR_REQ_O			: IN  std_logic;
          INSTR_ADDR_O			: IN  std_logic_vector(m-1 DOWNTO 0);
          INSTR_RVALID_I, INSTR_GNT_I	: OUT std_logic;
	  clk_i, rst_ni  		: IN  std_logic
	);
	  	
END Program_memory;



ARCHITECTURE behav OF Program_memory IS
  
-- Component Declaration for the Interface
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
    
  
-- Component Declaration for the SRAM
COMPONENT SRAM_P
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7
	      );
      PORT(R_EN			: IN std_logic;
           RADDR		: IN std_logic_vector(m-1 DOWNTO 0);
           RDATA		: OUT std_logic_vector(m-1 DOWNTO 0)
	  );
END COMPONENT SRAM_P;
    
-- FOR block_2: SRAM_P USE ENTITY work.SRAM_P (behavioral);
file SRAM_Program : text; 
  
-- FOR block_1: Interface_P USE ENTITY work.Interface_P (behav) ;
file Program_Interface : text;  
   
SIGNAL RENINT	: std_logic;
SIGNAL RADDRINT	: std_logic_vector(m-1 DOWNTO 0);
SIGNAL RDATAINT	: std_logic_vector(m-1 DOWNTO 0);



BEGIN

blocco_1: Interface_P
     PORT MAP (  
		  INSTR_REQ_O    => INSTR_REQ_O,		
                  INSTR_ADDR_O   => INSTR_ADDR_O,
                  INSTR_RDATA_I  => INSTR_RDATA_I,
                  INSTR_RVALID_I => INSTR_RVALID_I,
                  INSTR_GNT_I    => INSTR_GNT_I,
                  R_EN_INT      =>  RENINT,
                  RADDR_INT     =>  RADDRINT,
                  RDATA_INT     =>  RDATAINT,
		  clk_i		=>  clk_i,
		  rst_ni	=>  rst_ni
	 	);
  
blocco_2: SRAM_P 
    PORT MAP (  R_EN    => RENINT,
                RADDR   => RADDRINT,
                RDATA   => RDATAINT
		);      

END behav;