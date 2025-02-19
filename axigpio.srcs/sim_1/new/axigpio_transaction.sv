`include "uvm_macros.svh"
import uvm_pkg::*;

`ifndef TR
`define TR

class axigpio_transaction extends uvm_sequence_item;

	`uvm_object_utils(axigpio_transaction)

		 logic [31:0] readData;
	rand logic [31:0] writeData;
	rand logic 		  writeEnable;
	rand logic [4:0]  addr;

	constraint c_addr {
		(addr % 4) == 0;
		addr <= 'h18;
	}

	function new(string name="axigpio_transaction");
		super.new(name);

		readData = 0;
		writeData = 0;
		writeEnable = 0;
		addr = 0;
	endfunction : new

	function string convert2string();
		string outputString = "";

		outputString = $psprintf("%s\n\t * readData=%0h", outputString, readData);
		outputString = $psprintf("%s\n\t * writeData=%0h", outputString, writeData);
		outputString = $psprintf("%s\n\t * addr=%0h", outputString, addr);
		outputString = $psprintf("%s\n\t * writeEnable=%0b", outputString, writeEnable);

		return outputString;
	endfunction

endclass : axigpio_transaction
`endif
