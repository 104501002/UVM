// Code your design here
module dut(
  input clk, rstn,
  input logic[7:0] rxd,
  input logic rx_dv,
  output logic[7:0] txd,
  output logic tx_en
);
  
  always@(posedge clk)begin
    if(!rstn) begin
      txd   <= 0;
      tx_en <= 0;
    end
    else begin
      txd    <= rxd;
      tx_en	 <= rx_dv;
    end
  end
endmodule
