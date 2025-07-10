/**************************************************************
@File    :   pulse_filter_single.v
@Time    :   2025/07/10 09:32:52
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   单脉冲去抖滤波器
             当输入值持续变化超过设定的滤波系数时才更新输出,除毛刺
**************************************************************/
module pulse_filter_single (
    input  wire        clk         ,
    input  wire        rst_n       ,
    input  wire        pulse_in    , //输入脉冲信号
    input  wire [21:0] filter_thres, //滤波时间阈值(单位：50ns),200ms = 4000000 = 22位
    output reg         pulse_out     //滤波后输出信号
);

    reg [21:0]  cnt    ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt        <= 0;
            pulse_out  <= 0;
        end 

        else begin
            if (pulse_in != pulse_out) begin //当pulse_in与当前输出不同(状态变化中)
                if (cnt < filter_thres) begin //状态变化，但未超过滤波门限
                    cnt <= cnt + 1;
                end 
                
                else begin //变化持续时间满足门限
                    pulse_out <= pulse_in;
                    cnt       <= 0;
                end
            end

            else begin
                // 没有变化，计数清零
                cnt <= 0;
            end
        end
    end

endmodule