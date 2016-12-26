module counter(input logic clk);

int in, out;
logic valid_in, valid_out, ready_in, ready_out;

initial begin
    in <= 0; valid_in <= 1; ready_out <= 1;
end

always_ff @(posedge clk) begin
    if (valid_in && ready_out) begin
        out <= in + 1;
        valid_in <= 0;
        ready_out <= 0;
        valid_out <= 1;
        ready_in <= 1;
    end
    if (ready_in && valid_out) begin
        in <= out;
        ready_in <= 0;
        valid_out <= 0;
        valid_in <= 1;
        ready_out <= 1; 
    end
end
endmodule
