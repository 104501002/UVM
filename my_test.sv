class base_test extends uvm_test;
  only_env final_env;
  `uvm_component_utils(base_test);
  
  function new (string name="base_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    final_env = only_env::type_id::create("final_env", this);
    //[1] set seq as default sequence for trans sequencer 
    //uvm_config_db#(uvm_object_wrapper)::set(this, "final_env.in_ag.trans_sequencer.main_phase", "default_sequence", seq::type_id::get());
  endfunction
  
  function void report_phase(uvm_phase phase);
    uvm_report_server server;
    int err_num;
    super.report_phase(phase);
    
    $display("REPORT_PHASE");
    
    server = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);
    
    if(err_num !=0)  begin
      $display("TEST FAILED ");
    end
    else begin
      $display("TEST PASS");
    end
  endfunction
endclass
