`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 11:41:18 AM
// Design Name: 
// Module Name: top_module_async
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


module top_module_async #(parameter
    width = 32,
    depth = 1024
)(
    input  [width-1:0]         wdata,
    input                      clk_w,
    input                      clk_r,
    input                      reset_w,
    input                      reset_r,
    input                      wrt_enable,
    input                      red_enable,
    output [width-1:0]         rdata,
    output                     full,
    output                     empty,
    output                     alm_full,
    output                     alm_empty,
    output [$clog2(depth)-1:0] af_indic,
    output [$clog2(depth)-1:0] ae_indic,
    output [$clog2(depth)-1:0] wptr_t,
    output                     wover,
    output [$clog2(depth)-1:0] rptr_t,
    output                     rover,
    output [$clog2(depth):0]   wptr_bin_sync,
    output [$clog2(depth):0]   rptr_bin_sync,
    output [$clog2(depth)-1:0] w_marker,
    output                     flg);


//Internal Variables
    wire rst_w, rst_r, wrt_en, red_en, rst_r_mrkgen, rst_r_new;
    wire [$clog2(depth):0] wptr_gray, rptr_gray, wptr_gray_sync, rptr_gray_sync, wptr, rptr;
    wire [$clog2(depth)-1:0] marker;
    

//Instantiations
    async_rst AR1(reset_w, clk_w, rst_w);
    async_rst AR2(reset_r, clk_r, rst_r);
    memory_async M1(wdata, clk_w, clk_r, wrt_en, red_en, wptr[$clog2(depth)-1:0], rptr[$clog2(depth)-1:0], rdata);
    //memory_async M2(wdata, clk_w, wrt_en, red_en, wptr[$clog2(depth)-1:0], rptr[$clog2(depth)-1:0], rdata);
    wptr_and_full_async WPF1(wrt_enable, rptr_bin_sync, clk_w, rst_w, wptr, wptr_gray, full, wrt_en);
    rptr_and_empty_async RPE1(red_enable, wptr_bin_sync, clk_r, rst_r_new, rptr, rptr_gray, empty, red_en);
    sync_2ff Sff1(wptr_gray,clk_r,rst_r,wptr_gray_sync);
    sync_2ff Sff2(rptr_gray,clk_w,rst_w,rptr_gray_sync);
    gray2bin G2B1(wptr_gray_sync,wptr_bin_sync);
    gray2bin G2B2(rptr_gray_sync,rptr_bin_sync);
    marker_gen MRKG1(rst_w,clk_r,wptr,rptr,marker,rst_r_mrkgen,flg);
    
        
    
//Logic Circuit
    assign w_marker = marker;
    assign rst_r_new = rst_r & rst_r_mrkgen;
    assign alm_empty = (ae_indic) < 'd24 && (full) == 'd0 ;
    assign alm_full = (af_indic) < 'd24 && (empty) =='d0;
    assign af_indic = rptr_t - wptr_t;
    assign ae_indic = wptr_t - rptr_t;
    assign wptr_t = wptr[$clog2(depth)-1:0];
    assign rptr_t = rptr[$clog2(depth)-1:0];
    assign wover  = wptr[$clog2(depth)];
    assign rover  = rptr[$clog2(depth)];
    

endmodule

module async_rst(
    input  reset,
    input  clk,
    output rst
);
    reg r1,r2;
    
    assign rst = r2;
    
    always @(posedge clk,negedge reset) begin
        if(!reset) begin
            r2 <= 1'b0; 
            r1 <= 1'b0;
        end
        else begin
            r1 <= 1'b1;
            r2 <= r1;
        end
    end    

endmodule
