`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 11:20:30 AM
// Design Name: 
// Module Name: sync_2ff
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


module sync_2ff #(parameter
    depth = 1024
)(
    input  [$clog2(depth):0] gin,
    input              clk,
    input              rst,
    output [$clog2(depth):0] gout);

    reg [$clog2(depth):0] r0,r1;

    assign gout = r1;
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            {r1,r0} <= 0;
        end
        else begin
            {r1,r0} <= {r0,gin};
        end
    end
endmodule