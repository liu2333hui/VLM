module test;

reg [7:0] a;
reg [7:0] b;
reg [7:0] pre;

initial begin
$dumpfile("test.vcd");
$dumpvars(0, test);

// b = 0;
// a = 0;

// #1
// a = 1;
// #1
// a = 2;

// b = 4'b110x +  4'b0101;   //8'hbe & 8'hfc ~8'hfc << 8'h02 | 8'h01;

b = 0;
a = 8'b0011_1111;

// b[7] = a[7];
// b[6] = ~b[7] & a[6];
// b[5] = (~b[6] | ~b[7] ) & a[5];
// b[4] = ~b[5] & a[4];
// b[3] = ~b[4] & a[3];
// b[2] = ~b[3] & a[2];
// b[1] = ~b[2] & a[1];
// b[0] = ~b[1] & a[0];

//:0] = ~bs[7:1] & a[6:0];
// $display(b);
// pre[7] = 1'b0;
// pre[6] = pre[7] | a[7];
// pre[5] = pre[6] | a[6];
// pre[4] = pre[5] | a[5];
// pre[3] = pre[4] | a[4];
// pre[2] = pre[3] | a[3];
// pre[1] = pre[2] | a[2];
// pre[0] = pre[1] | a[1];
// b = a & ~pre;
// b = a & ~b;
// b = pre;
#1;

$display("%b",b);
$display("%b",pre);
#1;
$finish;
end
endmodule