`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 14:24:38
// Design Name: 
// Module Name: rst_r_marker
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
module rst_r_marker #(parameter
    depth = 1024
)(
    input                rst_w,
    input                rst_r,
    input                clk_w,
    input                clk_r,
    input  [$clog2(depth)-1:0]   wptr,
    input  [$clog2(depth)-1:0]   rptr_bin_sync,
    output [$clog2(depth)-1:0] marker,
    output               rst_r_sync,
    output               flg);

    reg [$clog2(depth)-1:0] mark;
    reg flg_w, rst_r_mrkgen_sync;
    wire rst_mrkgen;
    

    assign rst_mrkgen = (mark == rptr_bin_sync) ? 0:1;
    assign marker = mark;
    assign flg = flg_w;
    assign rst_r_sync = rst_r_mrkgen_sync;
    
    always@(posedge clk_r, negedge rst_r) begin
        if(!rst_r) begin
            rst_r_mrkgen_sync = 1'b0;
        end
        else begin
            rst_r_mrkgen_sync = rst_mrkgen;
        end
    end
        

    always@(negedge rst_r, negedge rst_w) begin
    //always@(posedge clk_w, negedge rst_w) begin
        if((!rst_w) && (!flg)) begin
            mark <= wptr;
            flg_w <= 1;
        end
        else if(!rst_r || !rst_mrkgen) begin
            mark <= depth-1;
            flg_w <= 0;
        end
        else begin
            mark <= mark;
            flg_w <= flg;
        end
    end
endmodule
*/



    

//    reg [$clog2(depth)-1:0] mark;
//    reg [$clog2(depth)-1:0] mark_sync;
//    reg flg_w, ack;
//    wire [$clog2(depth)-1:0] mark_gray;
//    wire [$clog2(depth)-1:0] mark_gray_sync;
    
//    assign mark_gray = mark ^ (mark>>1);
//    assign marker = mark_sync; 
//    assign flg = flg_w;
    
//    sync_2ff #(depth) Sff2(mark_gray, clk_r, rst_r, mark_gray_sync);
//    gray2bin #(depth) G2B2(mark_gray_sync, mark_bin_sync);
    
//    assign rst_r_mrkgen = (mark_sync == rptr) ? 0 : 1;
    
//    always @(posedge clk_r, negedge rst_r) begin
//        if(!rst_r) begin
//            mark_sync <= depth-1;
//        end
//        else begin
//            mark_sync <= mark_bin_sync;
//        end
    
//    end
    
//    always @(posedge clk_w, negedge rst_w) begin
//        if(!rst_w) begin
//            ack <= 0;
//        end
//        else begin
//            ack <= rst_r_gen;
//        end
//    end
    
    
//    always @(posedge clk_w, negedge rst_w) begin
//        if(ack) begin
//            mark <= depth-1;
//            flg_w <= 0;
//        end
//        else if(!rst_w && !flg_w) begin
//            mark <= wptr;
//            flg_w <= 1;
//        end
//        else begin
//            mark <= mark;
//            flg_w <= flg_w;
//        end
//    end

   // assign rst_r_sync = rst_r_mrkgen_sync;
    
//    always@(posedge clk_r, negedge rst_r) begin
//        if(!rst_r) begin
//            rst_r_mrkgen_sync = 1'b0;
//        end
//        else begin
//            rst_r_mrkgen_sync = rst_mrkgen;
//        end
//    end
  
///////////////////////////////////////////////////////////////////////////////////////////////////// Code Below: Working but, its wrong!!  
//module rst_r_marker #(parameter
//    depth = 1024
//)(
//    input                rst_w,
//    input                rst_r,
//    input                rst_r_gen,
//    input                clk_w,
//    input                clk_r,
//    input  [$clog2(depth)-1:0]   wptr,
//    input  [$clog2(depth)-1:0]   rptr,
//    output [$clog2(depth)-1:0] marker,
//    output               rst_r_mrkgen,
//    output               flg);

//    reg [$clog2(depth)-1:0] mark;
//    reg [$clog2(depth)-1:0] mark_sync;
//    reg flg_w, ack;
//    wire [$clog2(depth)-1:0] mark_gray;
//    wire [$clog2(depth)-1:0] mark_gray_sync;
    

//    assign rst_r_mrkgen = (mark == rptr) ? 0:1;
//    assign marker = mark;
//    assign flg = flg_w;

        

//    always@(negedge rst_r, negedge rst_w) begin
//    //always@(posedge clk_w, negedge rst_w) begin
//        if(!rst_r || !rst_r_mrkgen) begin
//            mark <= depth-1;
//            flg_w <= 0;
//        end
//        else if((!rst_w) && (!flg) && wptr != 'd0) begin
//            mark <= wptr;
//            flg_w <= 1;
//        end
//        else begin
//            mark <= mark;
//            flg_w <= flg;
//        end
//    end
//endmodule

module rst_r_marker #(parameter
    depth = 1024
)(
    input                rst_w,
    input                rst_r,
    input                rst_r_gen,
    input                clk_w,
    input                clk_r,
    input  [$clog2(depth)-1:0]   wptr,
    input  [$clog2(depth)-1:0]   rptr,
    output [$clog2(depth)-1:0] marker,
    output               rst_r_mrkgen,
    output               flg);
    
    reg ack1, ack, flg_w;
    reg [$clog2(depth)-1:0] mark;
    reg rst_r_mrkgen_i;
    wire [$clog2(depth):0] mark_gray, mark_gray_sync, mark_bin_sync;
    wire rst_r_mrkgen1;
 
    
    
    sync_2ff #(depth) Sffm(mark_gray, clk_r, rst_r, mark_gray_sync);
    gray2bin #(depth) G2Bm(mark_gray_sync, mark_bin_sync);
    
    assign mark_gray = {1'b0,mark}^({1'b0,mark}>>1);
    assign rst_r_mrkgen1 = (mark_bin_sync == {1'b0,rptr})? 0:1;
    assign rst_r_mrkgen  = rst_r_mrkgen1;
    assign marker = mark;
    assign flg = flg_w;
    
    always @(posedge clk_r,negedge rst_r_mrkgen1) begin
        if(!rst_r_mrkgen1) begin
            rst_r_mrkgen_i <= 1'b0;
        end
        else begin
            rst_r_mrkgen_i <= 1'b1;
        end
    end
     
    always @(posedge clk_w, negedge rst_w) begin
        if(!rst_w) begin
            ack1 <= 1;
            ack <= 1; 
        end
        else begin
            ack1 <= rst_r_mrkgen_i;
            ack <= ack1; 
        end
    end
    
    always @(negedge rst_w, negedge ack) begin
        if(!ack) begin
            mark <= depth-1;
            flg_w <= 0;
        end
        else begin
            mark <= (!rst_w && !flg_w) ? wptr : mark;
            flg_w <= (!rst_w && !flg_w) ? 1'b1 : 1'b0;
        end
    end
    
    
endmodule

