`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Brigham Young University
// Engineer: Collin Lambert
// 
// Create Date: 07/17/2023 11:05:09 AM
// Design Name: 
// Module Name: AXI_MASTER
// Project Name: HBM_HEATING
// Target Devices: 
// Tool Versions: 
// Description: AXI 4 LITE MASTER
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module AXI_MASTER (
        input wire axi_aclk,
        
        //SHARED CSRs
        input wire transact,
        input wire read_or_write,          //0 for read, 1 for write
        input wire [10:0] addr,
        input wire [31:0] write_data,
        output logic [31:0] read_data,
        
        output logic transaction_complete,
               
               
        //AXI
        output logic [10 : 0] axi_awaddr,        //Transaction address   (base address)
        input wire axi_awready,   
        output logic axi_awvalid,                                    
        
        output logic [31 : 0] axi_wdata,         //data        
        input wire axi_wready,     
        output logic [3 : 0] axi_wstrb,          //write data strobes. Default 1s                   
        output logic axi_wvalid,                                              
                           
        output logic axi_bready, 
        input wire [1 : 0] axi_bresp,           //write response                      
        input wire axi_bvalid,                                                
                 
        output logic [10 : 0] axi_araddr,        //Transaction address   
        input wire axi_arready,            
        output logic axi_arvalid,                                            
                           
        
        input wire [31 : 0] axi_rdata,          //data   
        output logic axi_rready,  
        input wire [1 : 0] axi_rresp,           //Read response                           
        input wire axi_rvalid,                                               
        
        input wire axi_aresetn                 //global reset                            
        
    );
    

    assign axi_arid = 0;
    assign axi_awid = 0;
    
    logic [3:0] axi_len;
    logic [2:0] axi_size;
    
    
    typedef enum logic [3:0] {AR_WAIT, AR_VALID, AR_TRANSACT_WAIT} ARState;
    typedef enum logic [3:0] {R_WAIT, R_BEAT, R_TRANSACT_WAIT} RState;
    typedef enum logic [3:0] {AW_WAIT, AW_VALID, AW_TRANSACT_WAIT} AWState;
    typedef enum logic [3:0] {W_WAIT, W_BEAT, W_LAST, W_TRANSACT_WAIT} WState;

    ARState arcs, arns; // address read current state / next state
    RState rcs, rns;    // read current state / next state
    AWState awcs, awns; // address write current state / next state
    WState wcs, wns;    // write current state / next state
    
    
    assign axi_wdata = write_data;
    assign read_data = axi_rdata;
    assign axi_wstrb = 4'hF;
    assign axi_arburst = 2'b01;  //Set burst type to INCR
    assign axi_awburst = 2'b01;
    
    
    assign axi_awaddr = addr;
    assign axi_araddr = addr;
    
    //read state machine and write state machine
    always_comb
    begin
    
    arns = AR_WAIT;
    rns = R_WAIT;
    awns = AW_WAIT;
    wns = W_WAIT;
    
    axi_arvalid = 0;
    axi_rready = 0;
    
    axi_awvalid = 0;
    axi_wvalid = 0;
    axi_bready = 0;
    
    transaction_complete = 0;
                
                case(arcs)
                    AR_WAIT:
                        begin
                            if (transact && !read_or_write)
                                begin
                                    arns = AR_VALID;
                                end
                            else
                                arns = arcs;
                        end
                    AR_VALID:
                        begin
                            axi_arvalid = 1;
                            if (axi_arready)
                                begin
                                    arns = AR_TRANSACT_WAIT;
                                end
                            else
                                begin
                                    arns = AR_VALID;
                                end
                        end
                    AR_TRANSACT_WAIT:   
                        begin
                            if (!transact)
                                arns = AR_WAIT;
                            else
                                arns = AR_TRANSACT_WAIT;
                        end
                        
                endcase
                
                case(rcs)
                    R_WAIT:
                        begin
                            if (transact && !read_or_write)
                                begin
                                    rns = R_BEAT;
                                end
                            else
                                begin
                                    rns = rcs;
                                end
                        end
                    R_BEAT:
                        begin
                            axi_rready = 1;
                            if (axi_rvalid)
                                begin
                                    rns = R_TRANSACT_WAIT;
                                end
                            else
                                rns = R_BEAT;
                        end
                    R_TRANSACT_WAIT:
                        begin
                            transaction_complete = 1;
                            if (!transact)
                                rns = R_WAIT;
                            else
                                rns = R_TRANSACT_WAIT;
                        end
                endcase
    
                case(awcs)
                    AW_WAIT:
                        begin
                            if (transact && read_or_write)
                                begin
                                    awns = AW_VALID;
                                end
                            else
                                awns = awcs;
                        end
                    AW_VALID:
                        begin
                            axi_awvalid = 1;
                            if (axi_awready)
                                begin
                                    awns = AW_TRANSACT_WAIT;
                                end
                            else
                                begin
                                    awns = AW_VALID;
                                end
                        end
                    AW_TRANSACT_WAIT:
                        begin
                            if (!transact)
                                awns = AW_WAIT;
                            else
                                awns = AW_TRANSACT_WAIT;
                        end
                endcase
                
                case(wcs)
                    W_WAIT:
                        begin
                            if (transact && read_or_write)
                                begin
                                    wns = W_BEAT;
                                end
                            else
                                wns = wcs;
                        end
    
                    W_BEAT:
                        begin
                            axi_wvalid = 1;
                            if (axi_wready)
                                begin
                                    wns = W_LAST;
                                end
                            else
                                wns = W_BEAT;
                        end
                    W_LAST:
                        begin
                            if (axi_bvalid)
                                begin
                                    axi_bready = 1;
                                    wns = W_TRANSACT_WAIT;
                                end
                        end
                    W_TRANSACT_WAIT:
                        begin
                            transaction_complete = 1;
                            if (!transact)
                                wns = W_WAIT;
                            else
                                wns = W_TRANSACT_WAIT;
                        end
    
                endcase 
    end
    
    
    
    always_ff @(posedge axi_aclk)
    begin
        arcs <= arns;
        rcs <= rns;
        awcs <= awns;
        wcs <= wns;
                    
    end
         

    



endmodule