module uart_rx(
input rest,clk,rx,
output reg [7:0]rx_data,
output reg rx_valid
    );
    reg [7:0]shift_reg;
    reg [13:0]baud_counter;
    reg [2:0]bit_counter;
    reg [1:0]ps,ns;
    parameter idel=2'b00;
    parameter start=2'b01;
    parameter data=2'b10;
    parameter stop=2'b11;
    
    //baud counter logic
    
    always@(posedge clk or posedge rest)begin
    if(rest)
    baud_counter<=0;
    else if(ps==idel)
    baud_counter<=0;
    else if(baud_counter==10416)
    baud_counter<=0;
    else
    baud_counter<=baud_counter+1;
    end
    
    //bit counter
    always@(posedge clk or posedge rest)begin
    if(rest)
    bit_counter<=0;
    else if(ps==data&&baud_counter==10416)
    if(bit_counter<7)
    bit_counter<= bit_counter+1;
    else 
    bit_counter<=0;
    end
    
    //fsm log
    always@(posedge clk or posedge rest)begin
    if(rest)
    ps<=idel;
    else
    ps<=ns;
    end
    always@(posedge clk or posedge rest)begin
 if(rest)
 shift_reg<=0;
 else if(ps==data&&baud_counter==10416)
 shift_reg[bit_counter]<=rx;
 end
    always@(*)begin
    ns=ps;
    case(ps)
    idel:begin
    if(rx==0)
    ns=start;
    else
    ns=idel;
    end
    start:begin
    if(baud_counter==5208)begin
    if(rx==0)
    ns=data;
    else
    ns=idel;
    end
    else
    ns=start;
    end
    data:begin
    if(baud_counter==10416)begin
        //shift_reg[bit_counter]=rx;
    if(bit_counter==7)
    ns=stop;
    else
    ns=data;
    end
    end
    stop:begin
    if(baud_counter==10416)begin
    if(rx)
    ns=idel;
    else
    ns=stop;
    end
    else
    ns=stop;
    end
    endcase
    end
    always@(posedge clk or posedge rest)begin
    if(rest)begin
    rx_data<=0;
    rx_valid<=0;
    end
    else
    begin
    rx_valid<=0;
    if(ps==stop&&baud_counter==10416&&rx==1)begin
    rx_data<=shift_reg;
    rx_valid<=1;
    end
    end
    end
endmodule
