// interface 定义保持不变
interface and_if(input bit clk);
	// bit clk;
    logic a, b, y;
    // ... tasks if needed
endinterface

// DUT 定义保持不变
module and_gate (
	input logic clk,
    input  logic a,
    input  logic b,
    output logic y
);
	always@(posedge clk) begin
		y <= a & b;
	end
    // assign y = a & b;
endmodule

// ==========================================================
// 将原来的 "program" 改为 "module"
// ==========================================================
// old: program test(and_if.sig);
// new: module test;
// module test;
//     // 获取 interface 句柄的引用（使用 modport 会更规范，但这里简化）
//     // 我们通过一个虚拟的 initial 块来驱动 interface 信号

//     // 声明一个 interface 类型的变量来接收实例
//     // 注意：这里不能直接像 program 那样传参，需要在顶层连接

//     // 测试行为写在 initial 块里
//     initial begin
//         $display("=== Starting AND Gate Test ===");
        
//         // 假设我们可以通过某种方式访问到 interface 实例 sig
//         // 这里的技巧是：在顶层模块中直接调用，而不是在这里
        
//         // 为了配合顶层，我们只写测试逻辑，不直接操作 sig
//         // 具体操作移到 top module 的 initial 块中
//         #1; // 占位
//     end
// endmodule


// ==========================================================
// 顶层模块 (Top Module)
// ==========================================================
module top;
	bit clk;
	always #5 clk=~clk;
	
    // 实例化 Interface
    and_if sig(clk);

    // 实例化 DUT
    and_gate dut (
		.clk(sig.clk),
        .a(sig.a),
        .b(sig.b),
        .y(sig.y)
    );



    // 1. 声明一个动态数组
    // 不需要在声明时指定大小
    byte unsigned data_q[$]; // 使用 byte unsigned 确保是 8bit 无符号
    
    // 或者使用 logic [7:0] 也可以
    // logic [7:0] data_arr[];

    initial begin

        static int array_size = 4096; // 设定数组大小为 10
        
        $display("Generating random 8-bit data...");

        // 2. 循环生成随机数据并加入数组
        // 也可以使用 randomize() 约束，但循环最直观
        repeat(array_size) begin
            byte tmp;
            // void'(std::randomize(tmp)); // 如果使用随机化类
            tmp = $urandom_range(0, 255); // 生成 0 到 255 的随机数 (8bit范围)
            data_q.push_back(tmp);
        end

        // 3. 打印结果验证
        foreach (data_q[i]) begin
            //$display("data_q[%0d] = 'h%0h (Decimal: %0d)", i, data_q[i], data_q[i]);
        end
		$display("done-%d", $time);
    end


 // 声明一个固定大小的 8bit 数组 (16个元素)
    logic [7:0] fixed_data [15:0];

    initial begin
        // 随机初始化每一个元素
        foreach (fixed_data[i]) begin
            fixed_data[i] = $urandom(); // $urandom 默认返回 32bit，但赋值给 8bit 会自动截断
            // 或者严格限制范围: fixed_data[i] = $urandom_range(8'h00, 8'hFF);
        end

        $display("--- Fixed Array Dump ---");
        foreach (fixed_data[i]) begin
            $write("0x%0h ", fixed_data[i]);
        end
        $write("\n");
    end


  //   // ==========================================================
  //   // 在顶层直接写测试逻辑，或者实例化 test module
  //   // ==========================================================
    initial begin
        
		
		
		$display("=== Starting AND Gate Test ===");
        
        // 测试用例 1: 0 & 0
        sig.a = 0; sig.b = 0; #10;
        $display("A=0, B=0 | Y=%b", sig.y);

        // 测试用例 2: 0 & 1
        sig.a = 0; sig.b = 1; #10;
        $display("A=0, B=1 | Y=%b", sig.y);

        // 测试用例 3: 1 & 1
        sig.a = 1; sig.b = 1; #10;
        $display("A=1, B=1 | Y=%b", sig.y);

		#10;
        $display("A=1, B=1 | Y=%b", sig.y);
		
        $display("=== Test Completed ===");
        $finish;
    end

endmodule