`timescale  1ns/1ns
`include    "R11641312 (38).v"

module testbench;
reg [1:0] SS_ADDR   = 0;
reg [7:0] DATA_ADDR = 0;

wire [3:0] SS;
wire MISO, MOSI, SCLK;
wire MISO_w0, MISO_w1, MISO_w2, MISO_w3;

assign MISO = MISO_w0 | MISO_w1 | MISO_w2 | MISO_w3;

master_device UUTM0(.DATA_ADDR(DATA_ADDR), .SS_ADDR(SS_ADDR), .SCLK(SCLK), .MOSI(MOSI), .MISO(MISO), .SS(SS));

slave_device UUTS0(.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO_w0), .SS(SS[0]));
slave_device UUTS1(.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO_w1), .SS(SS[1]));
slave_device UUTS2(.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO_w2), .SS(SS[2]));
slave_device UUTS3(.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO_w3), .SS(SS[3]));

integer pass = 0;
integer cases = 0;
integer i = 0;
integer j = 0;

reg [7:0] addresses [7:0];
reg [7:0] testCases [7:0];

initial begin
  // Generate a waveform file.
  $dumpfile("SPI.vcd");
  $dumpvars(0, testbench);

  // Load the addresses into the array.
  addresses[0] = 8'h1A;
  addresses[1] = 8'h1B;
  addresses[2] = 8'h1C;
  addresses[3] = 8'h1D;
  addresses[4] = 8'h2A;
  addresses[5] = 8'h2B;
  addresses[6] = 8'h2C;
  addresses[7] = 8'h2D;

  // Load the test cases into the array.
  testCases[0] = 8'h41;
  testCases[1] = 8'hDC;
  testCases[2] = 8'h3B;
  testCases[3] = 8'h4E;
  testCases[4] = 8'h8C;
  testCases[5] = 8'hB5;
  testCases[6] = 8'h05;
  testCases[7] = 8'hE5;

  // Execute the test.
  for (i = 0; i < 4; i = i + 1)
  begin
    for (j = 0; j < 8; j = j + 1)
    begin
    cases = cases + 1;
      SS_ADDR = i; DATA_ADDR = addresses[j]; #500;
      if (UUTM0.DATA == testCases[j])
      begin
        $display("Retrieved data from device %d = %h. (PASS)", i, UUTM0.DATA);
        pass = pass + 1;
      end
      else
      begin
        $display("Retrieved data from device %d = %h. (FAIL)", i, UUTM0.DATA);
      end
    end
  end
  $display("Test complete with %d of %d test cases passing.", pass, cases);
  $finish;
end
endmodule
