module wrap_around_gen #(
    
)(
    input  [$clog2(depth)-1:0] wptr,
    input  [$clog2(depth)-1:0] rptr,
    input                      clk_w,
    input                      rst_w,
    input                      rst_r_gen,
    output                     wrap_A_delay);

    reg wrap_A_dly;
    wire wrap_A;

    assign wrap_A = (AF==1 && (rptr > wptr)) ? 1:0;

    always @(posedge clk_w, negedge rst_w) begin
        if(!rst_w) begin
            wrap_A_dly <= 0;
        end
        else begin
            wrap_A_dly <= wrap_A;
        end
    end
endmodule
    end
