module uart_rx_tb;


    reg clk;
    reg rest;
    reg rx;

    wire [7:0] rx_data;
    wire rx_valid;


    // DUT

    uart_rx uut (
        .clk(clk),
        .rest(rest),
        .rx(rx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );


    // 100 MHz clock
    // 10 ns period

    always #5 clk = ~clk;


    // UART byte transmission

    task send_byte;

        input [7:0] data;
        integer i;

        begin

            // Start bit

            rx = 0;
            #104170;


            // 8 data bits
            // LSB first

            for(i = 0; i < 8; i = i + 1) begin

                rx = data[i];
                #104170;

            end


            // Stop bit

            rx = 1;
            #104170;

        end

    endtask


    // Test

    initial begin

        clk = 0;
        rest = 1;
        rx = 1;

        // Reset

        #100;
        rest = 0;

        // Send A = 8'h41

        send_byte(8'h41);

        // Wait

        #200000;


        $finish;

    end


    // Display received data

    always @(posedge clk) begin

        if(rx_valid)
            $display("Received Data = %h", rx_data);

    end

endmodule
