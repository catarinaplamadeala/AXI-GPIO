`include "uvm_macros.svh"
import uvm_pkg::*;

class registerTest extends uvm_test;
    // factory registration
    `uvm_component_utils (registerTest)

    environment env;
    
    // constructor
    function new(string name="generateMode_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        env = environment::type_id::create("env", this);
    endfunction
    
    virtual function void connect_phase (uvm_phase phase);
        // connect all sub-components
    endfunction
    
    virtual task writeRegister(int addr, int value);
        axigpio_writeSequence writeSeq;
        writeSeq = axigpio_writeSequence::type_id::create("writeSeq");

        writeSeq.addr         = addr;
        writeSeq.writeData    = value;
        writeSeq.writeEnable  = 1;

        writeSeq.start(env.agent.sequencer);
    endtask



    virtual task readRegister(input int addr, output int value);
        axigpio_writeSequence writeSeq;
        writeSeq = axigpio_writeSequence::type_id::create("writeSeq");
        writeSeq.addr         = addr;
         writeSeq.writeEnable  = 0;
        writeSeq.start(env.agent.sequencer);
        value = env.sb.registerBank[addr/4];
    endtask : readRegister
    
  

   virtual task runGenerateMode();
   
        virtual axigpio_intf axigpio;
       
        logic [31:0] gpio_io_t;   // Direcția GPIO
        int readValue;            // Valoare citită
        int writeValue;           // Valoare scrisă
    
        // Randomizarea datelor
        writeValue = $random();  // Randomizezi valoarea pentru scriere
    
        // Configurarea axigpio_intf (în cazul în care ai un astfel de obiect)
        uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio);
        
        // Randomizează semnalul gpio_io_i
        axigpio.gpio_io_i = $random();
    
        // Scrierea în registrul TRI (pentru a configura direcția)
        gpio_io_t = $random(); // Randomizezi direcția pinilor (intrare/ieșire)
        writeRegister(4, gpio_io_t);  // Scriere în registrul TRI pentru adresa 4 (pentru direcții)
    
        // Scrierea în registrul DATA
        writeRegister(0, writeValue);  // Scrierea valorii în DATA register (pentru adresa 0)
    
        // Citirea valorii din DATA register
        readRegister(0, readValue);   // Citirea valorii din registrul DATA pentru adresa 0

    
    endtask : runGenerateMode




    
    virtual task run_phase(uvm_phase phase);
        virtual axigpio_intf axigpio;
       
        axigpio_baseSequence baseSeq;
        
        uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio);
        
       
        baseSeq = axigpio_baseSequence::type_id::create("baseSeq");

        phase.raise_objection(this); 
        
				       
        // reset the module
        axigpio.s_axi_aresetn = 0;
        repeat(3) @(posedge axigpio.s_axi_aclk);
        axigpio.s_axi_aresetn = 1;

        runGenerateMode();

        phase.drop_objection(this);
     
    endtask
endclass
