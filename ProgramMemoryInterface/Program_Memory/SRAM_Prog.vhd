Library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;




ENTITY SRAM_P IS
  GENERIC(N: INTEGER:=15;
          m: INTEGER:=32;
          K: INTEGER:=7
	);
  PORT(R_EN: IN std_logic;
       RADDR: IN std_logic_vector(m-1 DOWNTO 0);
       RDATA: OUT std_logic_vector(m-1 DOWNTO 0));
END SRAM_P;



ARCHITECTURE behavioral OF SRAM_P IS
  
  SIGNAL RVL: std_logic_vector(2**(K)-1 DOWNTO 0);
  SIGNAL RHL: std_logic_vector(2**(N-K)-1 DOWNTO 0);
  TYPE data_array IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic_vector(m-1 DOWNTO 0);
  SIGNAL Din, Dout: data_array;
  
-- Intermediate Signals of Memory-Cells
  TYPE column_intermediate_signal IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic;
  TYPE row_intermediate_signal IS ARRAY(2**(N-K)-1 DOWNTO 0) OF column_intermediate_signal;
  SIGNAL w, EN_tristate: row_intermediate_signal; 

-- Memory Cell Array   

  
 
  TYPE column IS ARRAY (2**(K)-1 DOWNTO 0) OF std_logic_vector(m-1 DOWNTO 0);
  TYPE matrix IS ARRAY(2**(N-K)-1 DOWNTO 0) OF column;
  signal TriState_out: matrix; -- these are the tristate buffers on latch output

  SIGNAL DL_out : matrix := (  

		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000"),
		(others => x"00000000"), (others => x"00000000"), (others => x"00000000"), (others => x"00000000") , (others => x"00000000"),(others => x"00000000"),	
		(64 => x"402081FF", 60 => x"342196F3", 56 => x"F10115F3", 52 => x"3000E573", 48 => x"00000013", 44 => x"00000013", 40 => x"10200073", 36 => x"00102E23", 32 => x"0080006F", 28 => x"00202E23", 
		 24 => x"3000E573", 20 => x"402081B3", 16 => x"01802103", 12 => x"0BC0006F", 8 => x"0C00006F", 4 => x"0C40006F", 0 => x"0100006F", others => x"00000000"),	 	
		(124 => x"0BC0006F", 120 => x"0C00006F", 116 => x"0C40006F", 112 => x"0C80006F", 108 => x"0CC0006F", 104 => x"0D00006F", 100 => x"0D40006F", 96 => x"0D80006F", 92 => x"0DC0006F", others => x"00000000")
	

		-- This is the address order:
		-- ADDR_row_1: 192, 188, 184, 180, 176, 172, 168, 164, 164, 160, 156, 152, 148, 144, 140, 136, 132
		-- ADDR_row_0: 128, 124, 120, 116, 112, 108, 104, 100, 96, 92
				
 		);

  
  BEGIN
     
    
-- Processes for Decoder Operations
   
    
    -- Column Decoder for Reading Operation
    p_dec_RVL: PROCESS(all)
      VARIABLE i_RVL: INTEGER RANGE (2**(K)-1) DOWNTO 0;
      BEGIN
        i_RVL := to_integer(unsigned(RADDR(K-1 DOWNTO 0)));
        RVL <= (others => '0');
        IF R_EN = '1'  THEN
          RVL(i_RVL) <= '1';
        END IF;      
    END PROCESS p_dec_RVL;
    
    -- Row Decoder for Reading Operation
    p_dec_RHL: PROCESS(all)
      VARIABLE i_RHL: INTEGER RANGE (2**(N-K)-1) DOWNTO 0;
      BEGIN
        i_RHL := to_integer(unsigned(RADDR(N-1 DOWNTO K)));
        RHL <= (others => '0');
        RHL(i_RHL) <= '1';      
    END PROCESS p_dec_RHL;
    
    
    

       
-- Memory-Cells generate  
        columns: FOR j IN 2**(K)-1 DOWNTO 0
          generate
            rows: FOR i IN 2**(N-K)-1 DOWNTO 0
              generate   
              
                
                
                -- Reading Operation
                  EN_tristate(i)(j) <= RVL(j) AND RHL(i);
                  TriState_out(i)(j) <= DL_out(i)(j) when EN_tristate(i)(j) = '1' else (others => 'Z');


                 -- fixed connections to Dout buses
                 Dout(j) <= TriState_out(i)(j);
                
              END generate rows;
              
              --fixed connectiions to RDATA output bus
              RDATA <= Dout(j);
              
          END generate columns;


    
END behavioral;