Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use std.textio.all;



ENTITY data_memory IS
    GENERIC(N: INTEGER:=15;
            m: INTEGER:=32;
            K: INTEGER:=7
	    );
    PORT( DATA_RDATA_I	 		: OUT std_logic_vector(m-1 DOWNTO 0);
	  DATA_REQ_O, DATA_WE_O		: IN  std_logic;
          DATA_WDATA_O			: IN  std_logic_vector(m-1 DOWNTO 0);
          DATA_ADDR_O			: IN  std_logic_vector(m-1 DOWNTO 0);
          DATA_BE_O			: IN  std_logic_vector(3 DOWNTO 0);
          DATA_RVALID_I, DATA_GNT_I	: OUT std_logic;
          DATA_ERR_I			: OUT std_logic;
	  clk_i, rst_ni                 : IN  std_logic
	);
	  	
END data_memory;



ARCHITECTURE behav OF data_memory IS
  
-- Component Declaration for the Interface
COMPONENT Interface_D
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7
	      );
      PORT(DATA_REQ_O, DATA_WE_O	: IN std_logic;
           DATA_WDATA_O			: IN std_logic_vector(m-1 DOWNTO 0);
           DATA_ADDR_O			: IN std_logic_vector(m-1 DOWNTO 0);
           DATA_BE_O			: IN std_logic_vector(3 DOWNTO 0);
           DATA_RDATA_I			: OUT std_logic_vector(m-1 DOWNTO 0);
           DATA_RVALID_I, DATA_GNT_I	: OUT std_logic;
	   DATA_ERR_I			: OUT std_logic;
           W_EN_INT, R_EN_INT		: OUT std_logic;
           WADDR_INT, RADDR_INT		: OUT std_logic_vector(m-1 DOWNTO 0);
           WDATA_INT			: OUT std_logic_vector(m-1 DOWNTO 0);
           RDATA_INT			: IN std_logic_vector(m-1 DOWNTO 0);
	   clk_i			: IN  std_logic;
	   rst_ni			: IN  std_logic
	);
END COMPONENT Interface_D;
    

-- Component Declaration for the SRAM
COMPONENT SRAM_D
      GENERIC(N: INTEGER:=15;
              m: INTEGER:=32;
              K: INTEGER:=7
	      );
      PORT(W_EN, R_EN		: IN std_logic;
           WADDR, RADDR		: IN std_logic_vector(m-1 DOWNTO 0);
           WDATA		: IN std_logic_vector(m-1 DOWNTO 0);
           RDATA		: OUT std_logic_vector(m-1 DOWNTO 0)
	   );
END COMPONENT SRAM_D;
    

-- FOR block_2: SRAM_D USE ENTITY work.SRAM_D (behavioral);
file SRAM_Data : text; 
  
-- FOR block_1: Interface_D USE ENTITY work.Interface_D (behav);
file Data_interface : text;  
   
SIGNAL WENINT, RENINT		: std_logic;
SIGNAL WADDRINT, RADDRINT	: std_logic_vector(m-1 DOWNTO 0);
SIGNAL WDATAINT			: std_logic_vector(m-1 DOWNTO 0);
SIGNAL RDATAINT	 		: std_logic_vector(m-1 DOWNTO 0);



BEGIN
  
block_1: Interface_D
      PORT MAP (  DATA_WE_O     =>  DATA_WE_O,
		  DATA_REQ_O    =>  DATA_REQ_O,		
                  DATA_WDATA_O  =>  DATA_WDATA_O,
                  DATA_ADDR_O   =>  DATA_ADDR_O,
                  DATA_BE_O     =>  DATA_BE_O,
                  DATA_RDATA_I  =>  DATA_RDATA_I,
                  DATA_RVALID_I =>  DATA_RVALID_I,
                  DATA_GNT_I    =>  DATA_GNT_I,
                  DATA_ERR_I    =>  DATA_ERR_I,
                  W_EN_INT      =>  WENINT,
                  R_EN_INT      =>  RENINT,
                  WADDR_INT     =>  WADDRINT,
                  RADDR_INT     =>  RADDRINT,
                  WDATA_INT     =>  WDATAINT,
                  RDATA_INT     =>  RDATAINT,	
		  clk_i		=>  clk_i,		
	   	  rst_ni	=>  rst_ni
	 	);

block_2: SRAM_D 
    PORT MAP (  W_EN    => WENINT,
                R_EN    => RENINT,
                WADDR   => WADDRINT,
                RADDR   => RADDRINT,
                WDATA   => WDATAINT,
                RDATA   => RDATAINT
		);      

END behav;