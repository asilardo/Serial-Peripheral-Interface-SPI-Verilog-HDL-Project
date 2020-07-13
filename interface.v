/**
* starter.v
*
* Serial Peripheral Interface (SPI)
*
* Implement both sides of a SPI interface.
*
*/

module master_device(DATA_ADDR, SS_ADDR, SCLK, MOSI, MISO, SS);
// I/O PORTS (DO NOT MODIFY)
input MISO; 
output reg MOSI, SCLK;
input   [1:0] SS_ADDR;
output  [3:0] SS;
input   [7:0] DATA_ADDR;

wire [3:0] W_SS;
assign SS = ~W_SS;


dec2to4 u0(.A(SS_ADDR), .D(W_SS));

integer i = 0;

integer j = 0;

reg [7:0] DATA;

// ADD COMBINATIONAL LOGIC HERE

always@(DATA_ADDR, SS_ADDR)
begin
  // ADD SEQUENTIAL LOGIC HERE
    
    for (j = 0; j < 8; j = j + 1)
    begin  
        SCLK = 0; #10;
        MOSI = DATA_ADDR[j];
        SCLK = 1; #10;
    end

    for (j = 0; j < 8; j = j + 1)
    begin 
        SCLK = 0; #10;
        SCLK = 1; #10;
        DATA[j] = MISO;
    end 

end

endmodule

module slave_device(SCLK, MOSI, MISO, SS);
// I/O PORTS (DO NOT MODIFY)
input       MOSI, SCLK, SS;
output  reg MISO = 0;

// INTERNAL DATA REGISTERS (DO NOT MODIFY)
reg [7:0] reg0 = 8'h41; // Address = 8'h1A
reg [7:0] reg1 = 8'hDC; // Address = 8'h1B
reg [7:0] reg2 = 8'h3B; // Address = 8'h1C
reg [7:0] reg3 = 8'h4E; // Address = 8'h1D
reg [7:0] reg4 = 8'h8C; // Address = 8'h2A
reg [7:0] reg5 = 8'hB5; // Address = 8'h2B
reg [7:0] reg6 = 8'h05; // Address = 8'h2C
reg [7:0] reg7 = 8'hE5; // Address = 8'h2D

// ADD YOUR CODE HERE 

reg [7:0] ADDR_COMPARE = 8'h0;
//COUNTER 
reg [3:0] counter = 0;

always @(posedge SCLK)
begin
MISO = 0;
if (SS == 0)

begin
         if (counter < 8)
        begin
            ADDR_COMPARE [counter] = MOSI;
        end
    
        else if ( ADDR_COMPARE == 8'h1A)
        begin
          MISO = reg0[counter - 8];
        end
        
        else if( ADDR_COMPARE == 8'h1B)
        begin 
        MISO = reg1[counter - 8];
        end 
        
        else if( ADDR_COMPARE == 8'h1C)
        begin 
        MISO = reg2[counter - 8];
        end 
        
        else if( ADDR_COMPARE == 8'h1D)
        begin 
        MISO = reg3[counter - 8];
        end 
        
        else if( ADDR_COMPARE == 8'h2A)
        begin 
        MISO = reg4[counter - 8];
        end 
       
        else if( ADDR_COMPARE == 8'h2B)
        begin 
        MISO = reg5[counter - 8];
        end
       
        else if( ADDR_COMPARE == 8'h2C)
        begin 
        MISO = reg6[counter - 8];
        end

         else if( ADDR_COMPARE == 8'h2D)
        begin 
        MISO = reg7[counter - 8];
        end
        end

        counter = counter + 1;
    end

endmodule

module dec2to4(A, D);
input [1:0] A;
output [3:0] D;

wire [3:0] W;

dec1to2 u0(.A(A[1]), .D(W[3:2]));
dec1to2 u1(.A(A[0]), .D(W[1:0]));

assign D[3] = W[3] & W[1];
assign D[2] = W[3] & W[0];
assign D[1] = W[2] & W[1];
assign D[0] = W[2] & W[0];

endmodule


module dec1to2(A, D);
input A;
output [1:0] D;

assign D[1] = ~A;
assign D[0] = A;

endmodule