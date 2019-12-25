`timescale 1ns / 1ps
module vga_TOP(
        input clk,
        input rst,
        output R,
        output G,
        output B,
        output hsync,
        output vsync
);
//////////////////////////////////////////////////////////  
wire valid;
wire [9:0] x;
wire [9:0] y;
wire newframe;
wire newline;
wire VGA_clk;
reg [31:0] line;
wire [7:0] exit_value;
reg [5:0] counter_value;
reg [19:0] counter_clk;
//////////////////////////////////////////////////////////  

////////////////////////////////////////////////////////// 
localparam CHAR_B = 4'd10, CHAR_F = 4'd11, CHAR_I = 4'd12, CHAR_U = 4'd13,
  CHAR_Z = 4'd14;
//////////////////////////////////////////////////////////
vga vga(
    .clk(clk),
    .rst(rst),
    .x(x[9:0]),
    .y(y[9:0]),
    .valid(valid),
    .hsync(hsync),
    .vsync(vsync),
    .newframe(newframe),
    .newline(newline),
    .clk25_out(VGA_clk)
);

ROM ROM(
    .clk(VGA_clk),
    .rst(rst),
    .newline(newline),
    .newframe(newframe),
    .x(x[9:0]),
    .y(y[9:0]),
    .line(line[31:0]),
    .exit_value(exit_value[7:0]),
    .out_R(R),
    .out_G(G),
    .out_B(B)
);

value_ROM value_ROM(
    .some_value(counter_value[5:0]),
    .en(valid),
    .newframe(newframe),
    .exit_value(exit_value[7:0])
);
//////////////////////////////////////////////////////////
always @(*) begin
    line[3:0] <= CHAR_F;
    line[7:4] <= CHAR_I;
    line[11:8] <= CHAR_Z;
    line[15:12] <= CHAR_Z;
    line[19:16] <= CHAR_B;
    line[23:20] <= CHAR_U;
    line[27:24] <= CHAR_Z;
    line[31:28] <= CHAR_Z;
end
//////////////////////////////////////////////////////////
always @(posedge VGA_clk) begin
    if (counter_clk != 5000) begin
        counter_clk <= counter_clk + 1;
    end else if (counter_value != 6'o77) begin
        counter_clk <= 0;
        counter_value <= counter_value + 1;
    end else begin
        counter_value <= 0;
        counter_clk <= 0;
    end
end
endmodule