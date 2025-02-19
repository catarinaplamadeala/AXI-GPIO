import uvm_pkg::*;
`include "registerTest.sv"
module testbench();

// ------ Signals declaration ------ //
// inputs

logic freeze;
logic s_axi_aclk;
logic s_axi_aresetn;
logic [8:0] s_axi_awaddr;
logic s_axi_awvalid;
logic [31:0] s_axi_wdata;
logic [3:0] s_axi_wstrb;
logic s_axi_wvalid;
logic s_axi_bready;
logic [8:0] s_axi_araddr;
logic s_axi_arvalid;
logic s_axi_rready;
logic [31:0] gpio_io_i;

// outputs
logic generateout0;
logic s_axi_awready;
logic [31:0] gpio_io_o;
logic [31:0] gpio_io_t;
logic s_axi_wready;
logic [1:0] s_axi_bresp;
logic s_axi_bvalid;
logic s_axi_arready;
logic [31:0] s_axi_rdata;
logic [1:0] s_axi_rresp;
logic s_axi_rvalid;


// ------- DUT instantiation ------- //
axigpio_wrapper dut_inst(.*);


// ------- Interfaces instantiation ------- //
axigpio_intf axigpio();
register_intf registerIntf();


// ------- Clock generation ------- //
initial begin
    s_axi_aclk = 0;
    forever begin
        #5 s_axi_aclk = ~s_axi_aclk;
    end
end


// ------- Signals assignments ------- //
assign axigpio.s_axi_awready   = s_axi_awready;
assign axigpio.s_axi_wready   = s_axi_wready;
assign axigpio.gpio_io_o   = gpio_io_o;
assign axigpio.gpio_io_t    = gpio_io_t;
assign axigpio.s_axi_bresp     = s_axi_bresp;
assign axigpio.s_axi_bvalid    = s_axi_bvalid;
assign axigpio.s_axi_arready   = s_axi_arready;
assign axigpio.s_axi_rdata     = s_axi_rdata;
assign axigpio.s_axi_rresp     = s_axi_rresp;
assign axigpio.s_axi_rvalid    = s_axi_rvalid;
assign axigpio.s_axi_aclk      = s_axi_aclk;

assign registerIntf.generateout0 = generateout0;

assign s_axi_aresetn    = axigpio.s_axi_aresetn;
assign s_axi_awaddr     = axigpio.s_axi_awaddr;
assign s_axi_awvalid    = axigpio.s_axi_awvalid;
assign s_axi_wdata      = axigpio.s_axi_wdata;
assign s_axi_wstrb      = axigpio.s_axi_wstrb;
assign s_axi_wvalid     = axigpio.s_axi_wvalid;
assign s_axi_bready     = axigpio.s_axi_bready;
assign s_axi_araddr     = axigpio.s_axi_araddr;
assign s_axi_arvalid    = axigpio.s_axi_arvalid;
assign s_axi_rready     = axigpio.s_axi_rready;
assign gpio_io_i        = axigpio.gpio_io_i;


assign freeze = registerIntf.freeze;


// ------- Run a test ------- //
initial begin
    uvm_config_db#(virtual axigpio_intf)::set(null, "", "axigpio_interface", axigpio);
    uvm_config_db#(virtual register_intf)::set(null, "", "register_interface", registerIntf);

    fork
        begin
            run_test("registerTest");
        end
        begin
            int clkLimit = 1000;
            repeat(clkLimit) @(posedge axigpio.s_axi_aclk);
            `uvm_fatal("SIM_END", $psprintf("Reached the simulation limit of %0d s_axi_aclk cycles", clkLimit))
        end
    join_any
end



endmodule
