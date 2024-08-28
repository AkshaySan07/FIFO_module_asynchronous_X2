`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 10:57:26 AM
// Design Name: 
// Module Name: rptr_and_empty_async
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rptr_and_empty_async #(parameter
    width = 32,
    depth = 1024
)(
    input  red_enable,
    input  [$clog2(depth):0] wptr_bin_sync,
    input  clk_r,
    input  rst_r,
    output [$clog2(depth):0] rptr,
    output [$clog2(depth):0] rptr_gray,
    output empty,
    output red_en);
    
    //parameter sz = $clog2(depth);
    wire e;
    reg [$clog2(depth):0] rp;
    
    assign empty = e;
    assign red_en = red_enable & (~e);
    assign rptr = rp;
    assign rptr_gray = rp^(rp >> 1);
    assign e = (rp == wptr_bin_sync) ? 1:0;

    always @(posedge clk_r,negedge rst_r) begin
        if(!rst_r) begin
            rp <= 'd0;
        end
        else if(red_en) begin
            rp <= rp + 'd1;
        end
        else begin
            rp <= rp;
        end
    end

endmodule
