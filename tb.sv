import uvm_pkg::*;

`include "uvm_macros.svh"
`include "my_if.sv"
`include "my_trans.sv"
`include "my_seq.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scb.sv"
`include "my_env.sv"
`include "my_base_test.sv"
module tb_top;
  logic clk, rstn;
  my_vif in(clk, rstn);
  my_vif out(clk,rstn);
  dut my_dut (.rxd(in.data), .rx_dv(in.valid), txd(out.data), tx_dv(out.valid),.*);
  
  
  initial begin
    //[1]set to null bcz tb_top is not class
    uvm_config_db#(virtual my_vif)::set(null,"*", "global_vif", in);
    run_test("my_base_test");
    uvm_config_db#(virtual my_vif)::set(null,"uvm_test_top.final_env.in_ag.mon_inside_ag", "mon_vif", in);
    uvm_config_db#(virtual my_vif)::set(null,"uvm_test_top.final_env.out_ag.mon_inside_ag", "mon_vif", out);
    run_test("my_base_test");
  end
  initial begin
    {clk, rstn} = 0;
    #5 rstn = 1;
  end
  always #10 clk = ~clk;
endmodule
