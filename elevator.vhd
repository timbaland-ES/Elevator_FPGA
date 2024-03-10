library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LIFT_LOGIK is
    Port ( 
		   CABIN_REQUEST : in std_logic_vector (3 downto 0);
		   EXT_REQUEST : in std_logic_vector (3 downto 0);
		   CURRENT_FLOOR : in Integer range 0 to 3;
		   LAST_DIRECTION : in std_logic; -- 1:up, 0: down
           TARGET_DIRECTION : out std_logic -- 1:up, 0: down
		   );
end LIFT_LOGIK;

architecture Verhalten of LIFT_LOGIK is
	signal REQUEST_OBERHALB, REQUEST_UNTERHALB: std_logic_vector (3 downto 0);
	
	--Prozedurdefinition
	procedure FuelleOberUnterhalb (signal CABIN_REQUEST, EXT_REQUEST: in std_logic_vector (3 downto 0);
	   signal CURRENT_FLOOR: in Integer range 0 to 3;
	   signal REQUEST_OBERHALB, REQUEST_UNTERHALB: out std_logic_vector (3 downto 0)) is
	   
	   begin
	       REQUEST_UNTERHALB <= (others=>'0');
	       REQUEST_OBERHALB <= (others=>'0');
	       
		   
	       for i in (CURRENT_FLOOR+1) to 3 loop  
	           REQUEST_OBERHALB(i) <= CABIN_REQUEST(i); 
	           REQUEST_OBERHALB(i) <= EXT_REQUEST(i);
	       end loop;

	       for i in (CURRENT_FLOOR-1) downto 0 loop
	           REQUEST_UNTERHALB(i) <= CABIN_REQUEST(i);
	           REQUEST_UNTERHALB(i) <= EXT_REQUEST(i);
	       end loop;
	   
	   end FuelleOberUnterhalb;
	   
	--Funktionsdefinition
	function requestCheck (functionInput : std_logic_vector) return std_logic is
        variable result: std_logic:= '0'; 
        begin
            for i in 3 downto 0 loop
                if functionInput(i) = '1' then 
                     result := '1'; 
                     exit;    
                end if;                      
            end loop;      
            return result;       
    end function;


    begin
         OberUnterhalbBefuellen : process (CABIN_REQUEST,EXT_REQUEST,CURRENT_FLOOR)
            begin
                FuelleOberUnterhalb(CABIN_REQUEST, EXT_REQUEST, CURRENT_FLOOR,REQUEST_OBERHALB,
                    REQUEST_UNTERHALB);           
            end process;
         
         RichtungBestimmen : process (REQUEST_UNTERHALB,REQUEST_OBERHALB,LAST_DIRECTION)
			begin
                if LAST_DIRECTION = '0' then
                    if ((requestCheck(REQUEST_UNTERHALB)) = '1') then 
                        TARGET_DIRECTION <= '0';
                        else
                           TARGET_DIRECTION <= '1'; 
                    end if;
                    elsif (LAST_DIRECTION = '1') then
                       if (requestCheck(REQUEST_OBERHALB)) = '1' then 
                            TARGET_DIRECTION <= '1';
                            else
                                TARGET_DIRECTION <= '0';
                       end if;
                    else
                       null;
                end if;
         end process;
end Verhalten;