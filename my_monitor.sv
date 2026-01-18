class monitor extends uvm_monitor;
  virtual my_if mon_vif;
  
  uvm_analysis_port#(ethernet_pkt_trans) ap;
  `uvm_component_utils(monitor)
  
  function new (string name="monitor", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual my_if)::get(null, get_full_name(),"mon_vif", mon_vif))begin
      `uvm_fatal(get_type_name(),"oops")
    end
    ap = new("ap", this);
  endfunction
  
  task main_phase(uvm_phase phase);
    ethernet_pkt_trans trans;
    while(1)begin
      //[1] usually not big deal, but slightly better than create_id(each call does a factory lookup. In a tight loop generating millions of trans per simulation step, this can add some overhead
      trans = new("trans");
      repack(trans);
    end
  endtask
  
  task repack(ethernet_pkt_trans trans);
    byte unsigned data_q[$];
    byte unsigned data_array[]; //[2] needed bcz when called .unpack_bytes, the argument is array
    int data_size;
    
    while(mon_vif.valid)begin
      data_q.push_back(mon_vif.data);
      @(negedge mon_vif.clk);
    end
    data_array = new[data_q.size()];
    foreach(data_q[i])
      data_array[i] = data_q[i];
    if(data_q.size != null) begin
      //[3] unpack using buildin function, pload is dynamic array, need to allocate correct size bcz unpack [dmac+smac=12B, crc=4B ,ether_type=2B -> 18B]
      trans.pload = new[data_q.size()-18];
      data_size = trans.unpack_bytes(data_array)/8;
      trans.print();
      ap.write(trans);
    end
    @(negedge mon_vif.clk);    
  endtask
     
endclass
