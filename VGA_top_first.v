`timescale 1ns / 1ps
module ROM(
    input clk,
    input rst,
    input valid,
    input 
    input [9:0] y,
    output [] line,
);
//////////////////////////////////////////////////////////  
wire valid;
wire newframe;
wire newline;
wire VGA_clk;
wire [7:0] pixels;
//reg [3:0] char;
reg out;
reg [3:0] i, j = 0;
wire valid_char = ((y > 300) && (y < 308)) ? 1 : 0;
//reg [7:0] pixels_rev;
//////////////////////////////////////////////////////////  

////////////////////////////////////////////////////////// 
chars chars(
    .VGA_clk(VGA_clk),
    .en(valid_char),
    .char(chars),
    .rownum(j[2:0]),
    .pixels(pixels)
);
//////////////////////////////////////////////////////////
//входной chars, где помещены символы, задействованные в тексте(ширина line параметризируемая)
always @(*) begin
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
always @(posedge VGA_clk) begin
    if (valid) begin
        if (valid_char) begin
            if (i < 7) begin
                i <= i + 1;
                out <= pixels[i];
            end else begin
                i = 0;
            end
        end
    end
end
//////////////////////////////////////////////////////////
always @(posedge VGA_clk) begin
    if (valid) begin
        if (valid_char) begin
            if (newline) begin
                j <= j + 4'b0001;
            end
        end else begin
            j <= 0;
        end
    end
end
//////////////////////////////////////////////////////////
// always @(posedge VGA_clk) begin
//     if (valid) begin
//         rval = (x < 120 || x > 320) ? 1 : 0;
//         gval = (y < 240 || y > 360) ? 1 : 0;
//         bval = (x > 500 && (y < 120 || y > 300)) ? 1 : 0;
//     end else begin
//         rval = 0;
//         gval = 0;
//         bval = 0;
//     end
// end
endmodule