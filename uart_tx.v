module uart_tx(
input rest,clk,
input [7:0]din,
input start,
output reg tx
    );
    parameter idel=0;
    parameter s_start=1;
    parameter data=2;
    parameter stop=3;
    reg [1:0]ps,ns;
    reg [13:0]baud_counter;
    reg [2:0]bit_counter;
    reg [7:0]data_reg;
    //baud_counter logic
   always@(posedge clk or posedge rest)begin
    if(rest)
    baud_counter<=0;
    else if(ps==idel&&start)
    baud_counter<=0;
    else if(baud_counter==10416)
        baud_counter<=0;
        else
   baud_counter<=baud_counter+1;
   end
     //bit_counter logic 
  always@(posedge clk or posedge rest)begin
  if(rest)
   bit_counter<=0;
   else if(ps==data&&baud_counter==10416)begin
   if(bit_counter<7)
    bit_counter<=bit_counter+1;
    else
    bit_counter<=0;
  end
  end
 //FSM logic
 always@(posedge clk or posedge rest)begin
 if(rest)
 ps<=idel;
 else
 ps<=ns;
 end
 //data_reg
 always@(posedge clk or posedge rest)begin
 if(rest)
 data_reg<=0;
 else if(ps==idel&&start)
 data_reg<=din;
 end
 
 always@(*)begin
 ns=ps;
 tx=1;
 case(ps)
 idel:begin
 if(start)
 ns=s_start; 
 else 
 ns=idel;
 end
 s_start:begin
 tx=0;
 if(baud_counter==10416)
 ns=data;
 else
 ns=s_start;
 end
 data:begin
 tx=data_reg[bit_counter];
 if(baud_counter==10416)begin
 if(bit_counter==7)
 ns=stop;
 else
 ns=data;
 end
 end
 stop:begin
 tx=1;
 if(baud_counter==10416)
 ns=idel;
 else
 ns=stop;
 end
 default:
 ns=idel;
 endcase
 end 
  //output logic
  always@(*)begin
  tx=0;
  case(ps)
  idel:begin
  tx=1;
  end
  s_start:begin
  tx=0;
  end
  data:begin
  tx=data_reg[bit_counter];
  end
  stop:begin
  tx=1;
  end
  default:begin
  tx=0;
 end
 endcase
 end 
endmodule
