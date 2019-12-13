`timescale 1ns / 1ps
module vga(
        input clk,
        input rst,
        output reg [9:0] x,
        output reg [9:0] y,
        output valid,
        output hsync,
        output vsync,
        output reg newframe, 
        output reg newline,
        output clk25_out
    );
 //////////////////////////////////////////////////////////   
reg clk25; 
//////////////////////////////////////////////////////////
assign hsync = x < (640 + 16) || x >= (640 + 16 + 96);
assign vsync = y < (480 + 10) || y >= (480 + 10 + 2);
assign valid = (x < 640) && (y < 480);
assign clk25_out = clk25;
//////////////////////////////////////////////////////////
always @(posedge clk) begin
    newframe <= 0;
    newline <= 0;
    clk25 <= 0;
    if (rst == 0) begin
        x <= 10'b0;
        y <= 10'b0;
        clk25 <= 1'b0;
        newframe <= 1;
        newline <= 1;
    end else begin
        clk25 <= ~clk25;
        if (clk25 == 1) begin
            if (x < 10'd799) begin
                x <= x + 1'b1;
            end else begin
                x <= 10'b0;
                newline <= 1;
                if (y < 525) begin
                    y <= y + 1'b1;    
                end else begin
                    y <= 10'b0;
                    newframe <= 1;
                end
            end
        end
    end
end
//////////////////////////////////////////////////////////
endmodule