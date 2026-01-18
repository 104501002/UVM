class ethernet_pkt_trans extends uvm_sequence_item;
  //Ethernet pkt format: dmac(6B), smac(6B), type(2B), payload(46~1500B), crc(4B)
  rand bit[47:0] dmac, smac;
  rand bit[15:0] ether_type;
  rand byte pload[];
  rand bit[31:0] crc;
  
  constraint pload_cons {pload.size inside {[1:3]};} //Modified to only send [1:3]
  
  //[1] use uvm_field to register related variables, so we can use build in function (copy, compare, print)
  `uvm_object_utils_begin(ethernet_pkt_trans)
  `uvm_field_int(dmac, UVM_ALL_ON)
  `uvm_field_int(smac, UVM_ALL_ON)
  `uvm_field_int(ether_type, UVM_ALL_ON)
  `uvm_field_array_int(pload, UVM_ALL_ON)
  `uvm_field_int(crc, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //[2] different with uvm_component, dint have the parent when new
  function new(string name="ethernet_pkt_trans");
    super.new(name);
  endfunction
  
  function bit[31:0] calc_crc();
    return 32'h3;
  endfunction
  
  function void post_randomize();
    crc = calc_crc;
  endfunction

endclass
