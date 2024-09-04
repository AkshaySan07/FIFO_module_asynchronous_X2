`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 00:14:31
// Design Name: 
// Module Name: top_async_tb
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


module top_async_tb;
    wire [31:0] wdata;
    wire reset_w, reset_r, wrt_enable, red_enable, rst_r_mrkgen;
    wire clk_w, clk_r;
    wire [31:0] rdata;
    wire [31:0] zerothmem;
    wire [31:0] wdata_sync2;
    wire full, empty, alm_full, alm_empty;
    wire [9:0] wptr;
    wire       wover;
    wire [9:0] rptr;
    wire       rover;
    wire [9:0] af_indic;
    wire [9:0] ae_indic;
    wire [10:0] wptr_bin_sync;
    wire [10:0] rptr_bin_sync;
    wire [9:0] marker;
    wire flg;
    
    
    
    reg [14:0] i;
    reg clk_50,clk_100,clk_100phs;
    
    top_module_async #(32,1024)DUT(wdata,clk_w,clk_r,reset_w,reset_r,wrt_enable,red_enable,rdata,zerothmem,wdata_sync2,full,empty,alm_full,alm_empty,af_indic,ae_indic,wptr,wover,rptr,wptr_bin_sync,rptr_bin_sync,marker,rst_r_mrkgen,flg);

    initial begin
      $dumpfile("dumpsasync2.vcd");
      $dumpvars(1);
    end
    
    initial begin
        clk_50 = 1'b0;
        forever #10 clk_50 = ~clk_50;
    end
    initial begin
        clk_100 = 1'b0;
        forever #5 clk_100 = ~clk_100;
    end
    initial begin
        clk_100phs = 1'b0;
        #1;
        forever #5 clk_100phs = ~clk_100phs;
    end

        //testcase1 tt1(clk_50, clk_100, clk_100phs, clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r, wdata);
  testcase1 tt2(clk_50, clk_100, clk_100phs, clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r, wdata);
  
     

  
    /*initial begin
        wdata = 32'd0;
        #5 reset_w = 1'b1;
           reset_r = 1'b1;
        #5 wrt_enable = 1;
           red_enable = 0;
      for (i=15'd0; i<15'd1030; i = i+15'd1) begin
            #20 wdata = $urandom;
        end
        #5 wrt_enable = 0;
           red_enable = 1;
      for (i=15'd0; i<15'd1024; i = i+15'd1) begin
            #20 wdata = $urandom;
        end
        #5 $finish;
    end
    
    initial begin
        #300 reset_w = 1'b0;
        #20  reset_w = 1'b1;
    end
    
    initial begin
        #50 red_enable = 0;
        #50 red_enable = 1;
        #5 red_enable = 0;
           wrt_enable = 1;
        #200 red_enable = 1;
        #100 wrt_enable = 0;
        #100 wrt_enable = 1;
        #500 red_enable = 0;
        #100 red_enable = 1;
    end*/

    
endmodule

module testcase1(input clk_50, clk_100, clk_100phs, output reg clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r,output reg [31:0] wdata);
        reg [14:0] j;
        reg[1:0] s;
        // w = 50MHz r = 100MHz
        always @(*) begin
          case(s)
            2'b00 : begin
                   clk_w = clk_50;
                   clk_r = clk_100;
            end
            2'b01 : begin
                   clk_w = clk_100;
                   clk_r = clk_50;
            end
            2'b10 : begin
                   clk_w = clk_100;
                   clk_r = clk_100;
            end
            2'b11 : begin
                   clk_w = clk_100;
                   clk_r = clk_100phs;
            end
          endcase
        end
        
  
  
        initial begin
          {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd0};
        #30 reset_w = 1'b1;
            reset_r = 1'b1;
            for(j = 0; j<1040; j=j+1)begin
              #20 wdata = $urandom;
            end
            //#60;
            reset_w = 1'b0;
            #200; //reset_w = 1'b1; 
            red_enable = 1'b1;
            
        #1200;

        // w = 100MHz r = 50MHz
          {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b1,1'b1,32'd0,2'd1};
        #30 reset_w = 1'b1;
            reset_r = 1'b1;
          for(j = 0; j<2080; j=j+1)begin
            #10 wdata = $urandom;
        end
        wrt_enable = 1'b0;
        red_enable = 1'b1;
        #4000;

        // w = 100MHz r = 100MHz
          {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b1,1'b1,32'd0,2'd2};
        #30 reset_w = 1'b1;
            reset_r = 1'b1;
        for(j = 0; j<104; j=j+1)begin
            #10 wdata = $urandom;
        end
        wrt_enable = 1'b0;
        red_enable = 1'b1;
        #4000;

        // w = 100MHz r = 100MHz with phase diff
          {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b1,1'b1,32'd0,2'd3};
        #30 reset_w = 1'b1;
            reset_r = 1'b1;
        for(j = 0; j<1040; j=j+1)begin
            #10 wdata = $urandom;
        end
        wrt_enable = 1'b0;
        red_enable = 1'b1;
        #4000;  
        $finish;  
        end
endmodule

module testcase2(input clk_50, clk_100, clk_100phs, output reg clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r,output reg [31:0] wdata);
        reg [14:0] j;
        reg [4:0] p;
        reg[1:0] s;
        // w = 50MHz r = 100MHz
        always @(*) begin
          case(s)
            2'b00 : begin
                   clk_w = clk_50;
                   clk_r = clk_100;
            end
            2'b01 : begin
                   clk_w = clk_100;
                   clk_r = clk_50;
            end
            2'b10 : begin
                   clk_w = clk_100;
                   clk_r = clk_100;
            end
            2'b11 : begin
                   clk_w = clk_100;
                   clk_r = clk_100phs;
            end
          endcase
        end
  
  initial begin 
    fork
    begin
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} =    {1'b0,1'b0,1'b0,1'b0,32'd1,2'd0};
    #30 reset_w = 1'b1;
    reset_r = 1'b1;
    wrt_enable = 1'b1;
    for(j = 0; j<104; j=j+1)begin
      #20 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;
    end
   /* begin
    #35;
    for(p = 0; p<10; p=p+1) begin
      #40 {wrt_enable,red_enable} = {$urandom,$urandom};
    end
    
    end*/
    join

        // w = 100MHz r = 50MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b1,1'b0,1'b1,32'd0,2'd1};
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<2080; j=j+1)begin
       #10 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #4000;

        // w = 100MHz r = 100MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd2};
       
    #30 reset_w = 1'b1;       
    reset_r = 1'b1;
    for(j = 0; j<1040; j=j+1)begin
      #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #4000;

        // w = 100MHz r = 100MHz with phase diff
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd3};
        
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<1040; j=j+1)begin
       #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #4000;  
    //$finish;
  end
    
endmodule



//Full FIFO
module testcase3(input clk_50, clk_100, clk_100phs, output reg clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r,output reg [31:0] wdata);
        reg [14:0] j;
        reg [4:0] p;
        reg[1:0] s;
        // w = 50MHz r = 100MHz
        always @(*) begin
          case(s)
            2'b00 : begin
                   clk_w = clk_50;
                   clk_r = clk_100;
            end
            2'b01 : begin
                   clk_w = clk_100;
                   clk_r = clk_50;
            end
            2'b10 : begin
                   clk_w = clk_100;
                   clk_r = clk_100;
            end
            2'b11 : begin
                   clk_w = clk_100;
                   clk_r = clk_100phs;
            end
          endcase
        end
  
  initial begin 
    fork
    begin
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} =    {1'b0,1'b0,1'b0,1'b0,32'd1,2'd0};
    #30 reset_w = 1'b1;
    reset_r = 1'b1;
    wrt_enable = 1'b1;
    for(j = 0; j<1040; j=j+1)begin
      #20 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;
    end
   /* begin
    #35;
    for(p = 0; p<10; p=p+1) begin
      #40 {wrt_enable,red_enable} = {$urandom,$urandom};
    end
    
    end*/
    join

        // w = 100MHz r = 50MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd1};
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<1080; j=j+1)begin
       #10 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;

        // w = 100MHz r = 100MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd2};
       
    #30 reset_w = 1'b1;       
    reset_r = 1'b1;
    for(j = 0; j<1040; j=j+1)begin
      #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;

        // w = 100MHz r = 100MHz with phase diff
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd3};
        
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<1040; j=j+1)begin
       #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;  
    //$finish;    
  end
 endmodule
 
 
 //Empty FIFO
 module testcase4(input clk_50, clk_100, clk_100phs, output reg clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r,output reg [31:0] wdata);
        reg [14:0] j;
        reg [4:0] p;
        reg[1:0] s;
        // w = 50MHz r = 100MHz
        always @(*) begin
          case(s)
            2'b00 : begin
                   clk_w = clk_50;
                   clk_r = clk_100;
            end
            2'b01 : begin
                   clk_w = clk_100;
                   clk_r = clk_50;
            end
            2'b10 : begin
                   clk_w = clk_100;
                   clk_r = clk_100;
            end
            2'b11 : begin
                   clk_w = clk_100;
                   clk_r = clk_100phs;
            end
          endcase
        end
  
  initial begin 
    fork
    begin
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} =    {1'b0,1'b0,1'b0,1'b0,32'd1,2'd0};
    #30 reset_w = 1'b1;
    reset_r = 1'b1;
    wrt_enable = 1'b1;
    for(j = 0; j<20; j=j+1)begin
      #20 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;
    end
   /* begin
    #35;
    for(p = 0; p<10; p=p+1) begin
      #40 {wrt_enable,red_enable} = {$urandom,$urandom};
    end
    
    end*/
    join

        // w = 100MHz r = 50MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd1};
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
       #10 wdata = $urandom;
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #800;

        // w = 100MHz r = 100MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd2};
       
    #30 reset_w = 1'b1;       
    reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
      #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;

        // w = 100MHz r = 100MHz with phase diff
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd3};
        
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
       #10 wdata = $urandom;    
    end
    wrt_enable = 1'b0;
    red_enable = 1'b1;
    #400;  
    //$finish;    
  end
 endmodule
 
 
 
 // Synchronous read writes
  module testcase5(input clk_50, clk_100, clk_100phs, output reg clk_w, clk_r, wrt_enable, red_enable, reset_w, reset_r,output reg [31:0] wdata);
        reg [14:0] j;
        reg [4:0] p;
        reg[1:0] s;
        // w = 50MHz r = 100MHz
        always @(*) begin
          case(s)
            2'b00 : begin
                   clk_w = clk_50;
                   clk_r = clk_100;
            end
            2'b01 : begin
                   clk_w = clk_100;
                   clk_r = clk_50;
            end
            2'b10 : begin
                   clk_w = clk_100;
                   clk_r = clk_100;
            end
            2'b11 : begin
                   clk_w = clk_100;
                   clk_r = clk_100phs;
            end
          endcase
        end
  
  initial begin 
    fork
    begin
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} =    {1'b0,1'b0,1'b0,1'b0,32'd1,2'd0};
    #30 reset_w = 1'b1;
    reset_r = 1'b1;
    wrt_enable = 1'b1;
    for(j = 0; j<20; j=j+1)begin
      #20 wdata = $urandom;
    end
    red_enable = 1'b1;
    for(j = 0; j<50; j=j+1)begin
      #20 wdata = $urandom;
    end
    #400;
    end
   /* begin
    #35;
    for(p = 0; p<10; p=p+1) begin
      #40 {wrt_enable,red_enable} = {$urandom,$urandom};
    end
    
    end*/
    join

        // w = 100MHz r = 50MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd1};
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
       #10 wdata = $urandom;
    end
    red_enable = 1'b1;
    for(j = 0; j<50; j=j+1)begin
      #20 wdata = $urandom;
    end
    #800;

        // w = 100MHz r = 100MHz
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd2};
       
    #30 reset_w = 1'b1;       
    reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
      #10 wdata = $urandom;    
    end
    red_enable = 1'b1;
    for(j = 0; j<50; j=j+1)begin
      #20 wdata = $urandom;
    end
    #400;

        // w = 100MHz r = 100MHz with phase diff
          
    {reset_w,reset_r,red_enable,wrt_enable,wdata,s} = {1'b0,1'b0,1'b0,1'b1,32'd0,2'd3};
        
    #30 reset_w = 1'b1;
        reset_r = 1'b1;
    for(j = 0; j<20; j=j+1)begin
       #10 wdata = $urandom;    
    end
    red_enable = 1'b1;
    for(j = 0; j<50; j=j+1)begin
      #20 wdata = $urandom;
    end
    #400;  
    //$finish;    
  end
 endmodule

