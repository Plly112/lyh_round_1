`timescale 1ns/1ps

module tb_pulse_filter_top;

    // 参数定义
    parameter CLK_PERIOD = 50;  // 20MHz -> 50ns

    // 信号定义
    reg         clk         ;
    reg         rst_n       ;
    reg  [31:0] pulse_in    ;
    reg  [21:0] filter_thres;
    wire [31:0] pulse_out   ;

    // 实例化被测模块
    pulse_filter_top dut (
        .clk         (clk         ),
        .rst_n       (rst_n       ),
        .pulse_in    (pulse_in    ),
        .filter_thres(filter_thres),
        .pulse_out   (pulse_out   )
    );

    // 生成 20MHz 时钟
    always #(CLK_PERIOD/2) clk = ~clk;

    // 仿真主进程
    initial begin
        // 初始化
        clk = 0;
        rst_n = 0;
        pulse_in = 32'd0;
        filter_thres = 22'd2000000;  // 100ms = 2000000 x 50ns

        // 复位
        #100;
        rst_n = 1;

        // 等待一段时间
        #200;

        // == 测试：短脉冲（小于 100ms）
        // 输出短脉冲 (持续 40ms)
        pulse_in[0] = 1;
        #(40000000);  // 40ms
        pulse_in[0] = 0;
        #1000000;     // 50ms idle

        // == 测试：长脉冲（大于 100ms）
        // 输出长脉冲 (持续 120ms)
        pulse_in[0] = 1;
        #(120000000);  // 120ms
        pulse_in[0] = 0;
        #1000000;      // idle

        #2000000;  // 等待

        $stop;
    end

endmodule