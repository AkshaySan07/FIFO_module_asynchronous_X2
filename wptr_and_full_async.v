`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 11:12:55 AM
// Design Name: 
// Module Name: wptr_and_full_async
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


module wptr_and_full_async #(parameter
    width = 32,
    depth = 1024
)(
    input  wrt_enable,
    input  [$clog2(depth):0] rptr_bin_sync,
    input  clk_w,
    input  rst_w,
    input  wrap_A,
    output [$clog2(depth):0] wptr,
    output [$clog2(depth):0] wptr_gray,
    output full,
    output wrt_en);
    
    //parameter sz = $clog2(depth);
    wire f;
    reg [$clog2(depth)-1:0] wp;

    assign full = f;
    assign wrt_en = wrt_enable & (~f);
    assign wptr = {wrap_A,wp};
    assign wptr_gray = {wrap_A,wp}^({wrap_A,wp} >> 1);
    assign f = ({~wrap_A,wp[$clog2(depth) - 1:0]} == rptr_bin_sync) ? 1:0;

    always @(posedge clk_w,negedge rst_w) begin
        if(!rst_w) begin
            wp <= 'd0;
        end
        else if(wrt_en) begin
            wp <= wp + 'd1;
        end
        else begin
            wp <= wp;
        end
    end

endmodule