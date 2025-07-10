/**************************************************************
@File    :   pulse_filter_top.v
@Time    :   2025/07/10 09:20:38
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   顶层模块
             接收32路输入脉冲信号，将每一路分别送入单独的pulse_filter_single滤波子模块，输出滤波后的32路信号
**************************************************************/
module pulse_filter_top (
    input  wire        clk,           
    input  wire        rst_n,         
    input  wire [31:0] pulse_in,      // 32路输入脉冲信号
    input  wire [21:0] filter_thres,  // 滤波门限(单位：50ns)
    output wire [31:0] pulse_out      // 32路滤波后的输出信号
);

genvar i;

generate
    for (i = 0; i < 32; i = i + 1) begin : gen_filter
        pulse_filter_single u_filter (
            .clk         (clk         ),
            .rst_n       (rst_n       ),
            .pulse_in    (pulse_in[i] ),
            .filter_thres(filter_thres),
            .pulse_out   (pulse_out[i])
        );
    end
endgenerate

endmodule