class agent extends uvm_agent;
  only_driver     drv_inside_ag;
  only_sequencer  trans_sequencer;
  monitor         mon_inside_ag;
  
  `uvm_component_utils(agent);
  
  function new (string name="agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
      drv_inside_ag = only_driver::type_id::create("drv_inside_ag", this);
      trans_sequencer = only_sequencer::type_id::create("trans_sequencer", this);
    end
    mon_inside_ag = monitor::type_id::create("mon_inside_ag", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)begin
      drv_inside_ag.seq_item_port.connect(trans_sequencer.seq_item_export);
    end
  endfunction
endclass
