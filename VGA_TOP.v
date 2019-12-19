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
wire [7:0] pixels;
reg out;
reg [3:0] char;
reg [3:0] j = 0;
reg valid_char = 0;
reg [31:0] line;
//////////////////////////////////////////////////////////  
assign R = out; 
assign G = out; 
assign B = out;
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
chars chars(
   // .VGA_clk(VGA_clk),
    .en(valid_char),
    .char(char),
    .rownum(j[2:0]),
    .pixels(pixels)
);
//////////////////////////////////////////////////////////
always @(*) begin
    if (y > 300) begin
        valid_char <= 1;
    end else if (j == 0) begin
        valid_char <= 0;
    end
end
//////////////////////////////////////////////////////////   
always @(*) begin
    if (valid_char) begin
        if (pixels[7 - x[2:0]]) begin
            out <= 1;
        end else begin
            out <= 0;
        end
    end
end
//////////////////////////////////////////////////////////
always @(posedge newline) begin
    if (valid_char) begin
        j <= j + 1;
    end
    if (j == 7) begin
        j <= 0;
    end
end
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
    case (x[9:3])
        7'd1: char = line[3:0];
        7'd3: char = line[7:4];
        7'd5: char = line[11:8];
        7'd7: char = line[15:12];
        7'd9: char = line[19:16];
        7'd12: char = line[23:20];
        7'd13: char = line[27:24];
        7'd14: char = line[31:28];
    default: char = 4'd15;
    endcase
end
//////////////////////////////////////////////////////////

endmodule