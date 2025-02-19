`include "uvm_macros.svh"
import uvm_pkg::*;

class base_test extends uvm_test;
    // factory registration
    `uvm_component_utils (base_test)

    environment env;
    
    // constructor
    function new(string name="base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase (uvm_phase phase);
        env = environment::type_id::create("env", this);
    endfunction
    
    virtual function void connect_phase (uvm_phase phase);
        // connect all sub-components
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        virtual axigpio_intf axigpio;
        axigpio_baseSequence baseSeq;
        
        uvm_config_db#(virtual axigpio_intf)::get(null, "", "axigpio_interface", axigpio);
        
        baseSeq = axigpio_baseSequence::type_id::create("baseSeq");

        phase.raise_objection(this);        
        
        // reset the module
        axigpio.s_axi_aresetn = 0;
        repeat(5) @(posedge axigpio.s_axi_aclk);
        axigpio.s_axi_aresetn = 1;

        // generate 5 random axigpio transactions
        baseSeq.numberOfAccesses=5;
        baseSeq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
endclass
