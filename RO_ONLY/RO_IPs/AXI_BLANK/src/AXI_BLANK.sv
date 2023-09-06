`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2023 09:24:51 AM
// Design Name: 
// Module Name: AXI_BLANK
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AXI_BLANK(       
        input wire axi_aclk,       
        //AXI
        output logic [32 : 0] axi_awaddr,        //Transaction address   (base address)
        output logic [1 : 0] axi_awburst,        //Burst attribute, FIXED, INCR, WRAP. default 0b01(INCR)   
        output logic [3 : 0] axi_awlen,          //Number of transfers per transaction
        output logic [5 : 0] axi_awid,
        input wire axi_awready,   
        output logic [2 : 0] axi_awsize,         //Transfer size. 0b000 = 1 byte per transfer, 0b111 = 128 bytes per transfer
        output logic axi_awvalid,                                    
        
        output logic [255 : 0] axi_wdata,         //data        
        output logic axi_wlast,                  //Last write data    
        input wire axi_wready,     
        output logic [31 : 0] axi_wstrb,          //write data strobes. Default 1s                   
        output logic axi_wvalid,                                              
                           
        input wire [5 : 0] axi_bid,
        output logic axi_bready, 
        input wire [1 : 0] axi_bresp,           //write response                      
        input wire axi_bvalid,                                                
                 
        output logic [32 : 0] axi_araddr,        //Transaction address   
        output logic [1 : 0] axi_arburst,        //Burst attribute 
        output logic [5 : 0] axi_arid,  
        output logic [3 : 0] axi_arlen,          //Number of transfers per transaction
        input wire axi_arready,   
        output logic [2 : 0] axi_arsize,         //Transfer size. Number of bytes per transfer                
        output logic axi_arvalid,                                            
                           
        
        input wire [255 : 0] axi_rdata,          //data   
        input wire [5 : 0] axi_rid,     
        input wire axi_rlast,                   //Last read data   
        output logic axi_rready,  
        input wire [1 : 0] axi_rresp,           //Read response                           
        input wire axi_rvalid                                          
    );
    
    assign axi_awaddr = 0;
    assign axi_awburst = 0;
    assign axi_awlen = 0;
    assign axi_awid = 0;
    assign axi_awsize = 0;
    assign axi_awvalid = 0;
    
    assign axi_wdata = 0;
    assign axi_wlast = 0;
    assign axi_wstrb = 0;
    assign axi_wvalid = 0;
    
    assign axi_bready = 0;
    
    assign axi_araddr = 0;
    assign axi_arburst = 0;
    assign axi_arid = 0;
    assign axi_arlen = 0;
    assign axi_arsize = 0;
    assign axi_arvalid = 0;
    
    assign axi_rready = 0;
endmodule
