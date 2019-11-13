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
reg rval;
reg gval;
reg bval;
//////////////////////////////////////////////////////////  
assign R = rval;
assign G = gval;
assign B = bval;
////////////////////////////////////////////////////////// 
vga vga(
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .valid(valid),
    .hsync(hsync),
    .newframe(newframe),
    .newline(newline),
    .clk25_out(VGA_clk)
);
//////////////////////////////////////////////////////////
always @(posedge VGA_clk) begin
    if (valid) begin
        rval = (x < 120 || x > 320) ? 1 : 0;
        gval = (y < 240 || y > 360) ? 1 : 0;
        bval = (x > 500 && (y < 120 || y > 300)) ? 1 : 0;
    end else begin
        rval = 0;
        gval = 0;
        bval = 0;
    end
end
endmodule