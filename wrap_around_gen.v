module wrap_around_gen (
    input                      clk_w,
    input                      rst_w,
    input                      alm_full,
    output                     wrap_A_delay);

    reg wrap_A_dly;
    wire wrap_A;

    assign wrap_A = (alm_full==1) ? 1:0;

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
