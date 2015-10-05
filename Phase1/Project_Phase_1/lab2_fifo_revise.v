//-----------------------------------------------------
// Design Name : single clock FIFO1 with fillcount
// Coder       : Cheng Ma
// Date		   : Feb 18th, 2014, revised on March 4th
//-----------------------------------------------------
//`timescale 1ns/10ps
	
module FIFO (clk, reset, data_in, put, get, data_out, empty, full, fillcount);
// parametrize
parameter DEPTH_P2 = 6;
parameter WIDTH = 8;
//parameter PTR_SIZE = log2(DEPTH) ;
/*
function integer log2;
input [31:0] value;
for (log2 = 0; value > 1; log2 = log2 + 1)
begin value = value >> 1;end
endfunction
*/
//------------Input--------------- 
input clk, reset, put, get;
input [WIDTH-1: 0] data_in;
//------------output---------------
output empty, full;
output [WIDTH-1:0] data_out;
output [DEPTH_P2:0] fillcount;
// regs
reg [DEPTH_P2-1 : 0]rd_ptr;
reg [DEPTH_P2-1 : 0]wr_ptr;
reg [WIDTH-1 : 0] arr [2**DEPTH_P2-1:0] ;
reg [DEPTH_P2-1+1: 0]fillcount;

//wires
reg [WIDTH - 1 : 0]data_out;
wire full, empty;
//clocked block
always@(posedge clk)
	begin
		if (reset) begin 
			wr_ptr <= 0;
			rd_ptr <= 0;
			fillcount <= 0;
		end		
		
		else begin
			if (put && !full) begin
				arr[wr_ptr] <= data_in;
				wr_ptr <= wr_ptr + 1;
				fillcount <= fillcount + 1;
			end
			
			if (get && !empty) begin
				rd_ptr <= rd_ptr + 1;
				fillcount <= fillcount - 1;
				//data_out <= arr[rd_ptr]; // sync read
			end
			
			if ((put&& !full) && (get&& !empty)) begin
				fillcount<=fillcount; // rd wr both move
			end
		end
	end

	
// assign
assign full = ( fillcount == DEPTH);
assign empty = ( fillcount == 0);
assign data_out = arr[rd_ptr]; // async read

endmodule // End of Module