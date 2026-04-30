module dma_controller
( input clk,
input reset,
input start,
input mem_to_peripheral, // 0: Memory-to-Memory, 1: Memory-to-Peripheral
input [7:0] src_data,
input [7:0] peripheral_data_in,
output reg [7:0] dst_data,
output reg [3:0] address,
output reg done );
reg [3:0] count;
reg [1:0] state;
parameter IDLE = 2'b00;
parameter TRANSFER = 2'b01;
parameter COMPLETE = 2'b10;
always @(posedge clk or posedge reset) begin
if(reset) begin
state <= IDLE;
count <= 4'd0;
address <= 4'd0;
done <= 0;
dst_data <= 8'd0;
end else begin
case (state)
IDLE: begin
done <= 0;
if (start) begin
count <= 4'd0;
address <= 4'd0;
state <= TRANSFER;
end
end
TRANSFER: begin
if (mem_to_peripheral)
dst_data <= peripheral_data_in;
else
dst_data <= src_data;
count <= count + 1;
address <= count;
if (count == 4'd9) // total 10 transfers
state <= COMPLETE;
end
COMPLETE: begin
done <= 1;
state <= IDLE;
end
endcase
end
end
endmodule
