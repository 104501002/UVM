class only_env extends uvm_env;
   agent    in_ag, out_ag;
   scb      the_scb;
   modelll  ref_model;
  uvm_tlm_analysis_fifo#(ethernet_pkt_trans) in_ag_middle_fifo, out_ag_middle_fifo, ref_model_middle_fifo;
  `uvm_component_utils(only_env);
  
  function new (string name="only_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    //[1] mon and drive do diff with similar algo
    in_ag = agent::type_id::create("in_ag", this);
    out_ag = agent::type_id::create("out_ag", this);
    
    ref_model = modelll::type_id::create("ref_model", this);
    the_scb = scb::type_id::create("the_scb", this);
    
    in_ag.is_active = UVM_ACTIVE;
    out_ag.is_active = UVM_PASSIVE;
    
    in_ag_middle_fifo = new("in_ag_middle_fifo",this);
    out_ag_middle_fifo = new("out_ag_middle_fifo",this);
    ref_model_middle_fifo = new("ref_model_middle_fifo",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    in_ag.mon_inside_ag.ap.connect(in_ag_middle_fifo.analysis_export); //in_ag's monitor write trans to ap->in_ag fifo
    ref_model.port.connect(in_ag_middle_fifo.blocking_get_export); // reference model get trans from in_ag.monitor (input)
    
    out_ag.mon_inside_ag.ap.connect(out_ag_middle_fifo.analysis_export); //out_ag's monitor write trans to ap->out_ag fifo
    the_scb.obs_port.connect(out_ag_middle_fifo.blocking_get_export); // scb get DUT output from out_ag.monitor   
    ref_model.ap.connect(ref_model_middle_fifo.analysis_export); // ref model write trans to ap -> ref_model_middle_fifo
    the_scb.exp_port.connect(ref_model_middle_fifo.blocking_get_export); // scb get expectation from reference model
  endfunction
  
  task main_phase(uvm_phase phase);
    //[2] can remove already since we set the default sequencer 
    seq seq1;
    phase.raise_objection(this);
    seq1 = seq::type_id::create("seq");
    seq1.start(in_ag.trans_sequencer);
  endtask
endclass
