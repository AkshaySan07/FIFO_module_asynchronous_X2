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
    output [width-1:0]         zerothmem,
    output [width-1:0]         wdata_sync2,
    output                     full,
    output                     empty,
    output                     alm_full,
    output                     alm_empty,
    output [$clog2(depth)-1:0] af_indic,
    output [$clog2(depth)-1:0] ae_indic,
    output [$clog2(depth)-1:0] wptr_t,
    output                     wover,
    output [$clog2(depth)-1:0] rptr_t,
    output [$clog2(depth):0]   wptr_bin_sync,
    output [$clog2(depth):0]   rptr_bin_sync,
    output [$clog2(depth)-1:0] w_marker,
    output                     rst_r_mrkgen,
    output                     flg);


//Internal Variables
    wire rst_w, rst_r, wrt_en, red_en, rst_r_new, wrap_A;    //rst_r_mrkgen
    wire [$clog2(depth):0] wptr_gray, rptr_gray, wptr_gray_sync, rptr_gray_sync, wptr, rptr;
    wire [$clog2(depth)-1:0] marker;
    wire full_sync, empty_sync;
    

//Instantiations
    async_rst AR1(reset_w, clk_w, rst_w);
    async_rst AR2(reset_r, clk_r, rst_r);
    memory_async #(width,depth) M1(wdata, clk_w, rst_w, wrt_en, red_en, wptr[$clog2(depth)-1:0], rptr[$clog2(depth)-1:0], rdata, zerothmem, wdata_sync2);
    //memory_async M2(wdata, clk_w, wrt_en, red_en, wptr[$clog2(depth)-1:0], rptr[$clog2(depth)-1:0], rdata);
    wptr_and_full_async #(width,depth) WPF1(wrt_enable, rptr_bin_sync, clk_w, rst_w, wrap_A, wptr, wptr_gray, full, wrt_en);
    rptr_and_empty_async #(width,depth) RPE1(red_enable, wptr_bin_sync, clk_r, rst_r_gen, rptr, rptr_gray, empty, red_en);
    sync_2ff #(depth) Sff1(wptr_gray, clk_r, rst_r, wptr_gray_sync);
    sync_2ff #(depth) Sff2(rptr_gray, clk_w, (rst_w), rptr_gray_sync);
    sync_2ff #(1) Sff3(full, clk_r, rst_r, full_sync);
    sync_2ff #(1) Sff4(empty, clk_w, rst_w, empty_sync);
    
    gray2bin #(depth) G2B1(wptr_gray_sync, wptr_bin_sync);
    gray2bin #(depth) G2B2(rptr_gray_sync, rptr_bin_sync);
    rst_r_marker #(depth) MRKG1(rst_w, rst_r, rst_r_gen, clk_w, clk_r, wptr[$clog2(depth)-1:0], rptr[$clog2(depth)-1:0], marker, rst_r_mrkgen, flg);
    wrap_around_gen WAG1(clk_w, rst_w, alm_full, wrap_A);
    
        
    
//Logic Circuit
    assign w_marker = marker;
    assign rst_r_gen = rst_r & rst_r_mrkgen;
    
    
    assign alm_empty = (ae_indic) < 'd24 && (full_sync) == 'd0 ;
    assign alm_full = (af_indic) < 'd24 && (empty_sync) =='d0;
//    assign alm_empty = (wptr_bin_sync[$clog2(depth)-1:0] - rptr_t) < 'd24 && (full_sync) == 'd0 ;
//    assign alm_full = (rptr_bin_sync[$clog2(depth)-1:0] - wptr_t) < 'd24 && (empty_sync) =='d0;
    assign af_indic = rptr_bin_sync[$clog2(depth)-1:0] - wptr_t;
    assign ae_indic = wptr_bin_sync[$clog2(depth)-1:0] - rptr_t;
    
    
    assign wptr_t = wptr[$clog2(depth)-1:0];
    assign rptr_t = rptr[$clog2(depth)-1:0];
    assign wover  = wrap_A;
    

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