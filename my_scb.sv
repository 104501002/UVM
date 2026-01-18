class scb extends uvm_scoreboard;
  ethernet_pkt_trans exp_q[$];
  
  uvm_blocking_get_port #(ethernet_pkt_trans) exp_port,obs_port;
  `uvm_component_utils(scb);
  
  function new(string name="scb", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    exp_port = new("exp_port", this);
    obs_port = new("obs_port", this);
  endfunction
  
  task main_phase(uvm_phase phase);
  	ethernet_pkt_trans exp_trans, obs_trans;
    bit result;
    super.main_phase(phase);
    
    fork
      while(1) begin
        exp_port.get(exp_trans);
        exp_q.push_back(exp_trans);
      end
      while(1) begin
        obs_port.get(obs_trans);
        if(exp_port.size()>0)begin
          result = obs_trans.compare(exp_q.pop_front());
          if(result) begin
            `uvm_info(get_type_name(),"PASS!",UVM_LOW)
          end
          else begin
            `uvm_error(get_type_name(),"exp and obs diff!")
          end
        end
        else begin
          `uvm_error(get_type_name(),"received frm DUT but exp_q is empty!")
        end
      end
    join    
  endtask
endclass
