`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 14:22:07
// Design Name: 
// Module Name: wrap_around_gen
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


module wrap_around_gen (
    input                      clk_w,
    input                      rst_w,
    input                      alm_full,
    output                     wrap_A_delay);

    reg wrap_A_dly;
    assign wrap_A_delay = wrap_A_dly;

    always @(posedge clk_w, negedge rst_w) begin
        if(!rst_w) begin
            wrap_A_dly <= 0;
        end
        else begin
            wrap_A_dly <= alm_full;
        end
    end
endmodule
