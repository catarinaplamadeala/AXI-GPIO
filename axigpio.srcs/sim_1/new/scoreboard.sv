`include "uvm_macros.svh"
import uvm_pkg::*;


// decalares a new analysis import type
`uvm_analysis_imp_decl(_axigpio_monitor)


class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)


	uvm_analysis_imp_axigpio_monitor #(axigpio_transaction, scoreboard) axigpio_imp_monitor;

    virtual axigpio_intf axigpio;
    virtual register_intf registerIntf;
	int registerBank[7];


	function new(string name="", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new


	virtual function void build_phase(uvm_phase phase);
		axigpio_imp_monitor = new("axigpio_imp_monitor", this);
	endfunction


	virtual function void connect_phase(uvm_phase phase);
        uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio);
       
	endfunction
	// this function must be implemented when using an analysis import
	//	it is automatically called by the imp with the associated name
	virtual function void write_axigpio_monitor(axigpio_transaction monitorItem);

    if (monitorItem.writeEnable == 1) begin
        // Scriere în registrul simulat
        registerBank[monitorItem.addr / 4] = monitorItem.writeData;

        // Verifică dacă datele sunt propagate corect pe axi_gpio_o
        if (monitorItem.addr == 0) begin // Registrul de date asociat GPIO
            if (axigpio.gpio_io_o !== monitorItem.writeData) begin
                `uvm_error("GPIO_ERROR", $psprintf("Mismatch on GPIO output. Expected %0h, but got %0h",
                    monitorItem.writeData, axigpio.gpio_io_o));
            end else begin
                `uvm_info("GPIO_MONITOR", $psprintf("Correctly propagated data %0h to axi_gpio_o", monitorItem.writeData), UVM_LOW);
            end
        end 
    end
   else begin
    for (int i = 0; i <= 31; i++) begin
        // Dacă pinul este configurat ca intrare în gpio_io_t
        if (axigpio.gpio_io_t[i] == 1) begin
            // Validare pentru pini configurați ca intrare
            if (axigpio.gpio_io_i[i] != monitorItem.readData[i]) begin
                `uvm_error("GPIO_INPUT_ERROR", $sformatf("Mismatch on input GPIO pin %0d. Expected %0b, but got %0b", i, monitorItem.readData[i], axigpio.gpio_io_i[i]));
            end else begin
                `uvm_info("GPIO_INPUT", $sformatf("Input pin %0d matched correctly with value %0b.", i, axigpio.gpio_io_i[i]), UVM_LOW);
            end
        end else begin
            // Validare pentru pini configurați ca ieșire
            if (axigpio.gpio_io_o[i] != monitorItem.readData[i]) begin
                `uvm_error("GPIO_OUTPUT_ERROR", $sformatf( "Mismatch on output GPIO pin %0d. Expected %0b, but got %0b", i, monitorItem.readData[i], axigpio.gpio_io_o[i]));
            end else begin
                `uvm_info("GPIO_OUTPUT", $sformatf("Output pin %0d matched correctly with value %0b.", i, axigpio.gpio_io_o[i]), UVM_LOW);
            end
        end
    end
end


    

endfunction


	

endclass
