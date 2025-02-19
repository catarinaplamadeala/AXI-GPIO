`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axigpio_transaction.sv"
class axigpio_monitor extends uvm_monitor;

	`uvm_component_utils(axigpio_monitor)

	uvm_analysis_port #(axigpio_transaction) analysisPort;


	function new(string name="", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new


	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		analysisPort = new("axigpioAnalysisPort", this);
	endfunction



	virtual task run_phase (uvm_phase phase);
		virtual axigpio_intf axigpio_interface;

		uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio_interface);

		fork
			forever begin // WRITE
				axigpio_transaction axigpio_item;
				axigpio_item = axigpio_transaction::type_id::create("axigpio_item_write");

				axigpio_item.writeEnable = 1;

				wait(axigpio_interface.s_axi_awready == 1 && axigpio_interface.s_axi_wready == 1);
				@(posedge axigpio_interface.s_axi_aclk);

				axigpio_item.addr      = axigpio_interface.s_axi_awaddr;
				axigpio_item.writeData = axigpio_interface.s_axi_wdata;

				wait(axigpio_interface.s_axi_bvalid == 1);
				@(posedge axigpio_interface.s_axi_aclk);

				`uvm_info("axigpio_monitor", $psprintf("Detected a new write response: %s", axigpio_item.convert2string()), UVM_NONE)
				analysisPort.write(axigpio_item);
			end
			forever begin // READ
				axigpio_transaction axigpio_item;
				axigpio_item = axigpio_transaction::type_id::create("axigpio_item_read");

				wait(axigpio_interface.s_axi_arvalid == 1);
				@(posedge axigpio_interface.s_axi_aclk);

				axigpio_item.addr = axigpio_interface.s_axi_araddr;

				wait(axigpio_interface.s_axi_rvalid == 1);
				@(posedge axigpio_interface.s_axi_aclk);

				axigpio_item.readData = axigpio_interface.s_axi_rdata;

				`uvm_info("axigpio_monitor", $psprintf("Detected a new read response: %s", axigpio_item.convert2string()), UVM_NONE)
				analysisPort.write(axigpio_item);
			end
		join
	endtask

endclass

