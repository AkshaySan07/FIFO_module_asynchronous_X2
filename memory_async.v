`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 10:54:34 AM
// Design Name: 
// Module Name: memory_async
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

/*
module memory_async #(parameter
    width = 32,
    depth = 1024
    )(
    input  [width-1:0]         wdata,
    input                      clk_w,
    input                      wrt_en,
    input                      red_en,
    input  [$clog2(depth)-1:0] wptr,
    input  [$clog2(depth)-1:0] rptr,
    output [width-1:0]         rdata);

    reg [width-1:0] mem [depth-1:0];
    reg [width-1:0] wdata_sync;
  
    always @(posedge clk_w) begin
        if(wrt_en) begin
            wdata_sync <= wdata;
            mem [wptr][width-1 : 0] <= wdata_sync;
        end
        else begin
            mem [wptr][width-1 : 0] <= mem [wptr][width-1:0];
        end
    end

    assign rdata [width-1:0] = red_en ? mem [rptr][width-1:0] : 'd0;  

endmodule
*/
    


module memory_async #(parameter
    width = 32,
    depth = 1024
    )(
    input  [width-1:0] wdata,
    input  clk_w,
    input  clk_r,
    //input  rst,
    input  wrt_en,
    input  red_en,
    input  [$clog2(depth)-1: 0] wptr,
    input  [$clog2(depth)-1: 0] rptr,
    output [width-1:0] rdata);
    
    reg [width-1:0] mem [depth-1:0];
    //reg [$clog2(depth):0] i;
    reg [width-1:0] r_rdata;
    
    assign rdata = r_rdata;

    always @(posedge clk_w) begin
        if(wrt_en) begin
            mem [wptr][width-1 : 0] <= wdata;
        end
        else begin
            mem [wptr][width-1 : 0] <= 'd0;
        end
    end
    
    always @(posedge clk_r) begin
        if(red_en) begin
            r_rdata <= mem [rptr][width-1 : 0];
            //mem [rptr][width-1 : 0] <= 'd0;
        end
        else begin
            r_rdata = 'd0;
        end
    end     

endmodule
