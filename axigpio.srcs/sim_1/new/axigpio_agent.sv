`include "uvm_macros.svh"
import uvm_pkg::*;

class axigpio_agent extends uvm_agent;

	`uvm_component_utils(axigpio_agent)


	axigpio_monitor monitor;
	axigpio_driver driver;
	uvm_sequencer #(axigpio_transaction) sequencer;


	function new(string name="", uvm_component parent=null);
		super.new(name, parent);
	endfunction


	virtual function void build_phase(uvm_phase phase);
		sequencer = uvm_sequencer#(axigpio_transaction)::type_id::create("sequencer", this);
		driver 	  = axigpio_driver::type_id::create("driver", this);
		monitor   = axigpio_monitor::type_id::create("monitor", this);
	endfunction


	virtual function void connect_phase(uvm_phase phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction


endclass

