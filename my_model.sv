class modelll extends uvm_component;
  uvm_blocking_get_port #(ethernet_pkt_trans) port;
  uvm_analysis_port #(ethernet_pkt_trans) ap;
  `uvm_component_utils(modelll);
  
  function new (string name="modelll", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    ap = new("ap", this);
  endfunction
  
  task main_phase(uvm_phase phase);
    ethernet_pkt_trans trans, new_trans;
    super.main_phase(phase);
    
    while(1)begin
      port.get(trans);
      new_trans = new("new_trans");
      new_trans.copy(trans);
      ap.write(new_trans);
    end
  endtask
endclass
