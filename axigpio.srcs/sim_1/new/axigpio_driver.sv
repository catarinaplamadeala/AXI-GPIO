`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axigpio_transaction.sv"
class axigpio_driver extends uvm_driver #(axigpio_transaction);

	`uvm_component_utils(axigpio_driver)


	function new(string name="", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new


	virtual task run_phase (uvm_phase phase);
		axigpio_transaction axigpio_item;
		virtual axigpio_intf axigpio_interface;

		uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio_interface);

		forever begin
			seq_item_port.get_next_item(axigpio_item);

			uvm_report_info("axigpio_driver", $psprintf("Received new item: %s", axigpio_item.convert2string()), UVM_NONE);

			// Synchronize the driving with the AXI clock
			@(posedge axigpio_interface.s_axi_aclk);

			if(axigpio_item.writeEnable == 1) begin // write
				// Drive the address and data
				axigpio_interface.s_axi_wdata  = axigpio_item.writeData;
				axigpio_interface.s_axi_awaddr = axigpio_item.addr;
				// Signal that the data and the address are valid on the bus
				axigpio_interface.s_axi_awvalid = 1;
				axigpio_interface.s_axi_wvalid  = 1;
				

				// Wait until the consumer acknowledges the data and the address, then clear the valid signals
				wait(axigpio_interface.s_axi_awready == 1 && axigpio_interface.s_axi_wready == 1);
				@(posedge axigpio_interface.s_axi_aclk);
				axigpio_interface.s_axi_awvalid = 0;
				axigpio_interface.s_axi_wvalid  = 0;
				
				// Wait until the consumer aknowledges the write and check the response
				wait(axigpio_interface.s_axi_bvalid == 1);
				@(posedge axigpio_interface.s_axi_aclk);
				
				if(axigpio_interface.s_axi_bresp == 0)
					`uvm_info("axigpio_driver", "Write access successfull", UVM_NONE)
				else
					`uvm_warning("axigpio_driver", $psprintf("The previous write access generated %0b response", axigpio_interface.s_axi_bresp))

				// Acknowledge the response by setting BREADY for 1 clock cycle
				axigpio_interface.s_axi_bready = 1;
				@(posedge axigpio_interface.s_axi_aclk);
				axigpio_interface.s_axi_bready = 0;
				
				
			end
			else begin // read
				// Drive the address and signal that it is valid
				axigpio_interface.s_axi_araddr = axigpio_item.addr;
				axigpio_interface.s_axi_arvalid = 1;

				// Wait until the consumer acknowldedges the address, then clear the valid signal
				wait (axigpio_interface.s_axi_arready == 1);
				@(posedge axigpio_interface.s_axi_aclk );
				axigpio_interface.s_axi_arvalid = 0;

				// Wait until the consumer signals that the read data is available on the bus
				wait (axigpio_interface.s_axi_rvalid  == 1);

				// Check the response
				// If successful, print the data in the log. This is only for debugging purposes, since the monitor will capture it
				@(posedge axigpio_interface.s_axi_aclk);
				if(axigpio_interface.s_axi_rresp == 0) 
					`uvm_info("axigpio_driver", $psprintf("Successfully read data %0h", axigpio_interface.s_axi_rdata), UVM_NONE)
				else
					`uvm_warning("axigpio_driver", $psprintf("The previous read access generated %0b response", axigpio_interface.s_axi_bresp))
				
				// Acknowledge the response by setting RREADY for 1 clock cycle
				axigpio_interface.s_axi_rready  = 1;
				@(posedge axigpio_interface.s_axi_aclk);
				axigpio_interface.s_axi_rready  = 0;
			end

			seq_item_port.item_done();
		end
	endtask : run_phase


endclass : axigpio_driver
