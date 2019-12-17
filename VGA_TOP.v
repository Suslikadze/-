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
//reg [3:0] char;
reg out;
reg [3:0] i, j = 0;
wire valid_char = ((y > 300) && (y < 308)) ? 1 : 0;
//reg [7:0] pixels_rev;
//////////////////////////////////////////////////////////  
assign R = out; 
assign G = out; 
assign B = out;
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
    .VGA_clk(VGA_clk),
    .en(valid_char),
    .char(x[7:3]),
    .rownum(j[2:0]),
    .pixels(pixels)
);
//////////////////////////////////////////////////////////
// always @(posedge VGA_clk) begin
//     if (valid) begin
//         if (valid_char) begin
//             //if (y < y + 3'd8) begin
//        // if (char < 15) begin
//             //pixels_rev <= {pixels[0], pixels[1], pixels[2], pixels[3], pixels[4], pixels[5], pixels[6], pixels[7]};
//                 if (i < 7) begin
//                     i <= i + 1;
//                     out <= pixels[i];
//                 end else begin
//                     i = 0;
//          //       char <= char + 1;
//                 end
//           //  end
//         end
//         //end else begin
//           //  char <= 1'b0;
//        // end    
//     end
// end
//////////////////////////////////////////////////////////
always @(posedge VGA_clk) begin
    if (valid) begin
        if (valid_char) begin
            if (j < 4'b0111) begin
                if (i < 7) begin
                    i <= i + 1;
                    out <= pixels[i];
                end else begin
                    i = 0;
                    j <= j + 4'b0001;
                end
            end else begin
                j <= 0;
            end
        end
    end
end


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