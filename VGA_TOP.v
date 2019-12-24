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
    .out_R(R),
    .out_G(G),
    .out_B(B)
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

endmodule