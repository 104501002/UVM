//[1] need to tell driver driven what
class only_driver extends uvm_driver #(ethernet_pkt_trans);
  virtual my_if drv_vif;
  `uvm_component_utils(only_driver);
  
  function new(string name="only_driver", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual my_if)::get(null,"*","global_vif", drv_vif)) begin
      `uvm_fatal(get_type_name(),"ermmmm")
    end
  endfunction
  
  task main_phase(uvm_phase phase);
    //[2] trans get from sequencer
    {drv_vif.valid, drv_vif.data} <= 0;
    while(!drv_vif.rstn) begin
      @(posedge drv_vif.clk);
    end
    while(1) begin
      seq_item_port.try_next_item(req); //[3] get_next_item(blocking), try_next_item(non_blocking, more accurate behaviour for the driver)
      if(req == null)
        @(posedge drv_vif.clk);
      else begin
        pack(req);
        seq_item_port.item_done();
      end
    end
  endtask
  
  task pack(ethernet_pkt_trans trans);
    byte unsigned data_q[];
    int data_size;
    trans.print();
    
    data_size = trans.pack_bytes(data_q)/8;
    
    repeat(2) @(posedge drv_vif.clk);
    for(int i=0; i<data_size; i++)begin
      @(posedge drv_vif.clk);
      drv_vif.valid <= 1;
      drv_vif.data  <= data_q[i];
    end
    
    @(posedge drv_vif.clk);
    drv_vif.valid <= 0;
  endtask
    
endclass
