module dma_controller_tb;
reg clk, reset, start, mem_to_peripheral;
reg [7:0] src_data, peripheral_data_in;
wire [7:0] dst_data;
wire [3:0] address;
wire done;
dma_controller dut (
.clk(clk),
.reset(reset),
.start(start),
.mem_to_peripheral(mem_to_peripheral),
.src_data(src_data),
.peripheral_data_in(peripheral_data_in),
.dst_data(dst_data),
.address(address),
.done(done)
);
// Clock generation
initial begin
clk = 0;
forever #5 clk = ~clk;
end
// Stimulus
initial begin
// Initial values
reset = 1;
start = 0;
src_data = 8'hA5;
peripheral_data_in = 8'h3C;
mem_to_peripheral = 0;
#10 reset = 0;
// Memory-to-Memory transfer
#10 start = 1;
#10 start = 0;
wait(done);
#20;
// Memory-to-Peripheral transfer
start = 1;
mem_to_peripheral = 1;
#10 start = 0;
wait(done);
#20;
$finish;
end
endmodule
