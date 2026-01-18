//[1] same with driver, need to define trans type
class only_sequencer extends uvm_sequencer #(ethernet_pkt_trans);
  `uvm_component_utils(only_sequencer)
  
  function new (string name="only_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
endclass
