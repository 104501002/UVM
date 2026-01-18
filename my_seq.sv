class seq extends uvm_sequence #(ethernet_pkt_trans);
  ethernet_pkt_trans eth_trans;
  `uvm_object_utils(seq)
  
  function new(string name="seq");
    super.new(name);
  endfunction
  
  virtual task body();
    //[1] starting phase is variable inside uvm_sequence. when sequencer start the default_sequence, it will do 
    //seq.starting_phase = phase;
    //seq.start(this);
    $display("kppppk");
    if(starting_phase != null) begin
      $display("kkk");
    starting_phase.raise_objection(this);
    end
    else begin
      $display("whyyy");
    end
    repeat(10)
      `uvm_do(eth_trans);
    #100;
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
endclass
