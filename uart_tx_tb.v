module uart_tx_tb;

reg clk, rest;
reg [7:0] din;
reg start;
wire tx;

uart_tx h1(
    .clk(clk),
    .rest(rest),
    .din(din),
    .start(start),
    .tx(tx)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    rest = 1;
    start = 0;
    din = 0;

    #10;
    rest = 0;

    // First data
    din = 8'b1010_1101;
    start = 1;

    @(posedge clk);
    #2000000;
   // start = 0;

    // Wait for complete 8-N-1 frame
    //#10000;

    // Second data
   // din = 8'b1011_0010;
    //start = 1;

  //  @(posedge clk);
    //#1;
   // start =0;

    

    $finish;
end

endmodule
