`include "uvm_macros.svh"
import uvm_pkg::*;

class axigpio_writeSequence extends uvm_sequence #(axigpio_writeSequence);
	
	`uvm_object_utils (axigpio_writeSequence)


	axigpio_transaction axigpio_item;
	int writeData;
	int addr;
	bit writeEnable;


	function new(string name="axigpio_writeSequence");
		super.new(name);
	endfunction : new


	virtual task body();
		axigpio_item = axigpio_transaction::type_id::create("axigpio_item");
		
		start_item(axigpio_item);
		axigpio_item.writeEnable 	= writeEnable;
		axigpio_item.addr 			= addr;
		axigpio_item.writeData 	= writeData;
		finish_item(axigpio_item);

	endtask : body


endclass : axigpio_writeSequence
