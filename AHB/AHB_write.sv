module AHB_write (
    input logic hclk, hsel_x, hreset_n, hready, hwrite,
    input logic [1:0] write_select,
    input logic [7:0] hwdata,
    input logic current_hresp,
    output logic [7:0] payload_0,
    output logic [7:0] payload_1,
    output logic [4:0] data_size,
    output logic hready_out,
    output logic hresp
);
    always_ff @(posedge hclk, negedge hreset_n) begin
        if (hsel_x) begin
            if (!hreset_n) begin
                payload_0 <= 8'd0;
                payload_1 <= 8'd0;
                data_size <= 5'd0;
                hready_out <= 1'd0;
                hresp <= 1'd0;
            end else if (hwrite && hready) begin
                case (write_select)
                    2'd0: payload_0 <= hwdata;
                    2'd1: payload_1 <= hwdata;
                    2'd2: data_size <= hwdata[4:0];
                    default: ;
                endcase
                hready_out <= 1'd1;
                hresp <= current_hresp;
            end else begin
                hready_out <= 1'd0;
                hresp <= 1'd0;
            end
        end
    end
endmodule