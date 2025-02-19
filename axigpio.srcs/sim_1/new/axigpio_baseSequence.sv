`include "uvm_macros.svh"
import uvm_pkg::*;

class axigpio_baseSequence extends uvm_sequence #(axigpio_transaction);
	
	`uvm_object_utils (axigpio_baseSequence)


	axigpio_transaction axigpio_item;
	int numberOfAccesses;


	function new(string name="axigpio_baseSequence");
		super.new(name);
	endfunction : new


	virtual task body();
		axigpio_item = axigpio_transaction::type_id::create("axigpio_item");

		`uvm_info("axigpio_baseSequence", $psprintf("Going to generate %d axigpio transactions", numberOfAccesses), UVM_NONE)
		
		repeat(numberOfAccesses) begin
			start_item(axigpio_item);
			axigpio_item.randomize();
			finish_item(axigpio_item);
		end

		`uvm_info("axigpio_baseSequence", $psprintf("Finished generating axigpio transactions"), UVM_NONE)
	endtask : body


endclass : axigpio_baseSequence

