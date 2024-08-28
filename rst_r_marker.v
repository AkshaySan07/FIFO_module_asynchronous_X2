
module rst_r_marker #(parameter
    ptrsize = 10,
    depth = 1024
)(
    input                rst_w,
    input                rst_r,
    input                clk_w,
    input  [ptrsize-1:0]   wptr,
    input  [ptrsize-1:0]   rptr,
    output [ptrsize-1:0] marker,
    output               rst_r_mrkgen,
    output               flg_w);

    reg [ptrsize-1:0] mark;

    assign rst_r_mrkgen = (marker == rptr) ? 0:1;
    assign marker = mark;

    always@(posedge clk_w, negedge rst_r) begin
        if(!rst_r || !rst_r_mrkgen) begin
            mark <= depth-1;
            flg_w <= 0;
        end
        else if((!rst_w) && (!flg)) begin
            mark <= wptr;
            flg_w <= 1;
        end
        else begin
            mark <= mark;
            flg_w <= 1;
        end
    end
            
            
    
