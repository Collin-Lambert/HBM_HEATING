`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2023 11:05:09 AM
// Design Name: 
// Module Name: BIST
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
typedef enum logic [1:0] {OPTION_READ, OPTION_WRITE} PortSetting;

module BIST #(parameter bist_num = 0) (
        input wire axi_aclk,
        
        //SHARED CSRs
        //input wire [31:0] csr_port_mask,        //Defines which ports are set to read/write
        input wire csr_start,                   //Tells the BIST when to begin/end
        //input wire [31:0] csr_data_pattern,     //The pattern of data to be written     
        input wire read_or_write,               //0 for read, 1 for write     
        
        
        //INDIVIDUAL CSRs
        output logic csr_exec_done_status,      //Signal indicating if the port is in the wait state
        output logic [31:0] csr_total_reads,    //Total number of reads
        output logic [31:0] csr_total_writes,   //Total number of writes
        output logic [31:0] csr_ticks,          //Number of clock cycles taken per transaction
        //input wire [31:0] address_readwrite,    //Address to read and write to
        //input wire [31:0] delay_ctr_max,        //32 bit signal to set the number of clock cycles to delay after every transaction of reading/writing
        output logic delay_stat_fsm,            //Signal indicating if the port is in the pause state
               
               
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
        input wire axi_rvalid,                                               
        
        input wire axi_aresetn                 //global reset                   
//        input wire axi_init_axi_txn,            //       
//        output wire axi_txn_done,                      
//        output wire axi_error                         
        
    );
    
    //NUM_BYTES = fff = 4095
    //BEATS_PER_BURST = 16
    //BYTES_PER_BEAT = 32
    
    
    //num_bursts = (((num_bytes + (bytes_per_beat - 1)) / bytes_per_beat) + (beats_per_burst - 1)) / beats_per_burst
    //num_bursts = (((15 + 31)) / 32) + (15)) / 16
    //num_bursts = 8
    
    //burst_quantity = num_bursts
    
    //last_burst_beats = ((num_bytes + (BYTES_PER_BEAT -1)) / BYTES_PER_BEAT) % BEATS_PER_BURST; 
    //last_burst_beats = 0
    
    //last_burst_len = last_busrt_beats;
    
    
    //total bytes = length * size
    //Length is the number of transfers per transaction
    
    wire csr_port_setting;  //indivdual csr to specify if the port is reading or writing
    wire [3:0] burst_len;   //The number of bursts in a transaction. This is defaulted to 16
    assign burst_len = 16;
    
    wire [3:0] last_burst_len;  //The number of bursts in the last transaction   32 bytes
    assign last_burst_len = 0; 
    
    wire [31:0] burst_quantity; //The number of transactions per reading or writing command.
    assign burst_quantity = 15; 
    assign axi_arlen = burst_quantity;
    assign axi_awlen = burst_quantity;
    
    assign axi_arsize = 5; //log2 (axi_port.data_width / 8)
    assign axi_awsize = 5;
   
    
    logic [31:0] burst_counter;
    logic [31:0] beat_counter;
    logic [31:0] delay_counter;
    
    
    
    
    typedef enum logic [7:0] {WAIT_, READ_VALID, READ_BEAT, READ_PAUSE, WRITE_VALID, WRITE_BEAT, WRITE_LAST, WRITE_PAUSE, ERR} State;
    State cs, ns;
    
    
    logic ticks_incr; //Used to increment the ticks counter
    logic burst_incr;
    logic reads_incr;
    logic writes_incr;
    logic beat_incr;
    logic delay_incr;
    
    logic beat_counter_rst;
    logic burst_counter_rst;
    logic delay_counter_rst;
    logic reads_rst;
    logic writes_rst;
    logic ticks_rst;
    
    logic [31:0] delay_ctr_max;        //32 bit signal to set the number of clock cycles to delay after every transaction of reading/writing
    assign delay_ctr_max = 0;
    
    logic [31:0] csr_data_pattern;     //The pattern of data to be written  
    assign csr_data_pattern = 32'ha5a5a5a5;
    assign axi_wdata = {8{csr_data_pattern}};
    assign axi_wstrb = 'hF;
    assign axi_arburst = 'b01;  //Set burst type to INCR
    assign axi_awburst = 'b01;
    
    logic [32:0] address_readwrite;    //Address to read and write to
    
    //Increment to the next start address
    assign address_readwrite = 33'h0 + (bist_num * 33'h10000000); 
    
    //Bottom 5 bits of the address are unused as per the HBM IP specification
    
    
    
    
    
    assign axi_awaddr = address_readwrite;
    assign axi_araddr = address_readwrite;
    
    assign csr_port_setting = read_or_write;
    
    assign axi_arid = 0;
    assign axi_awid = 0;
    assign axi_rid = 0;
    
    logic reset_dbg;
    logic wait_dbg;
    
    
    always_comb
    begin
    csr_exec_done_status = 0;
    axi_arvalid = 0;
    axi_rready = 0;
    ticks_incr = 0;
    burst_incr = 0;
    reads_incr = 0;
    writes_incr = 0;
    axi_awvalid = 0;
    axi_wvalid = 0;
    axi_wlast = 0;
    axi_bready = 0;
    beat_incr = 0;
    delay_incr = 0;
    beat_counter_rst = 0;
    burst_counter_rst = 0;
    delay_counter_rst = 0;
    reads_rst = 0;
    writes_rst = 0;
    ticks_rst = 0;
    ns = WAIT_;
    
    //for debugging
    reset_dbg = 0;
    wait_dbg = 0;
    
    //--------------
    
    if (!axi_aresetn)
        begin
            ns = WAIT_;
            reset_dbg = 1;
        end
    else
        begin
            case(cs)
                WAIT_:
                    begin
                        wait_dbg = 1;
                        csr_exec_done_status = 1;
                        if (csr_start && (csr_port_setting == 0)) //READ
                            begin
                                ns = READ_VALID;
                            end
                        else if (csr_start && (csr_port_setting == 1)) //WRITE
                            begin
                                ns = WRITE_VALID;
                            end
                        else
                            begin
                                ns = cs;
                            end
                    end
                WRITE_VALID:
                    begin
                        axi_awvalid = 1;
                        axi_wvalid = 1;
                        ticks_incr = 1;
                        if (!csr_start)
                            begin
                                ns = WAIT_;
                            end
                        else if (axi_awready && axi_wready && (axi_awlen > 0))
                            begin
                                writes_incr = 1;
                                beat_incr = 1;
                                ns = WRITE_BEAT;
                            end
                        else if (axi_awready && axi_wready)
                            begin
                                axi_wlast = 1;
                                writes_incr = 1;
                                burst_incr = 1;
                                ns = WRITE_LAST;
                            end
                        else
                            begin
                                ns = WRITE_VALID;
                            end
                    end
                    
                WRITE_BEAT:
                    begin
                        axi_wvalid = 1;
                        ticks_incr = 1;
                        if (axi_wready && (beat_counter < axi_awlen))
                            begin
                                writes_incr = 1;
                                beat_incr = 1;
                                ns = WRITE_BEAT;
                            end
                        else if (axi_wready && (beat_counter == axi_awlen))
                            begin
                                axi_wlast = 1;
                                writes_incr = 1;
                                beat_counter_rst = 1;
                                burst_incr = 1;
                                ns = WRITE_LAST;
                            end
                        else
                            begin
                                ns = WRITE_BEAT;
                            end
                    end
                
                WRITE_LAST:
                    begin
                        axi_wvalid = 1;
                        axi_bready = 1;
                        ticks_incr = 1;
                        if (axi_bvalid && (burst_counter >= burst_quantity))
                            begin
                                if (!csr_start)
                                    begin
                                        ns = WAIT_;
                                    end
                                else if (delay_ctr_max > 0)
                                    begin
                                        beat_counter_rst = 1;
                                        burst_counter_rst = 1;
                                        delay_counter_rst = 1;
                                        ns = WRITE_VALID;
                                    end
                                else
                                    begin
                                        beat_counter_rst = 1;
                                        burst_counter_rst = 1;
                                        ticks_rst = 1;
                                        writes_rst = 1;
                                        ns = WRITE_VALID;
                                    end
                            end
                        else if (axi_bvalid)
                            begin
                                beat_counter_rst = 1;
                                ns = WRITE_VALID;
                            end
                        else
                            begin
                                ns = WRITE_LAST;
                            end
                    end
                
                WRITE_PAUSE:
                    begin
                        if (delay_ctr_max > 0)
                            begin
                                delay_incr = 1;
                            end
                        if (!csr_start)
                            begin
                                ns = WAIT_;
                            end
                        else if (delay_ctr_max == 0)
                            begin
                                ns = WRITE_VALID;
                            end
                        else if ((delay_counter + 1) >= delay_ctr_max)
                            begin
                                ticks_rst = 1;
                                writes_rst = 1;
                                ns = WRITE_VALID;
                            end
                    end
    
                READ_VALID:
                    begin
                        axi_arvalid = 1;
                        ticks_incr = 1;
                        if (!csr_start)
                            begin
                                ns = WAIT_;
                            end
                        else if (axi_arready)
                            begin
                                ns = READ_BEAT;
                            end
                        else
                            begin
                                ns = READ_VALID;
                            end
                    end
                READ_BEAT:
                    begin
                        axi_rready = 1;
                        ticks_incr = 1;
                        if (!csr_start)
                            begin
                                ns = WAIT_;
                            end
                        else if (axi_rvalid && axi_rlast)
                            begin
                                burst_incr = 1;
                                if ((burst_counter + 1) >= burst_quantity)
                                    begin
                                        if (!csr_start)
                                            begin
                                                reads_incr = 1;
                                                ns = WAIT_;
                                            end
                                        else if (delay_ctr_max > 0)
                                            begin
                                                reads_incr = 1;
                                                beat_counter_rst = 1;
                                                burst_counter_rst = 1;
                                                delay_counter_rst = 1;
                                                ns = READ_PAUSE;
                                            end
                                        else
                                            begin
                                                beat_counter_rst = 1;
                                                burst_counter_rst = 1;
                                                ticks_rst = 1;
                                                reads_rst = 1;
                                                ns = READ_VALID;
                                            end
                                    end
                                else
                                    begin
                                        reads_incr = 1;
                                        beat_counter_rst = 1;
                                        ns = READ_VALID;
                                    end
                            end
                        else if (axi_rvalid)
                            begin
                                reads_incr = 1;
                                ns = READ_BEAT;
                            end
                        else
                            begin
                                ns = cs;
                            end
                    end
                
                READ_PAUSE:
                    begin
                        if (delay_ctr_max > 0)
                            begin
                                delay_incr = 1;
                            end
                        if (!csr_start)
                            begin
                                ns = WAIT_;
                            end
                        else if (delay_ctr_max == 0)
                            begin
                                ns = READ_VALID;
                            end
                        else if ((delay_counter + 1) >= delay_ctr_max)
                            begin
                                ticks_rst = 1;
                                reads_rst = 1;
                                ns = READ_VALID;
                            end
                    end
            endcase
        end   
    end
    
    
    
    always_ff @(posedge axi_aclk)
    begin
        cs = ns;
        
        if (!axi_aresetn)
            begin
                csr_total_reads <= 0;
                csr_total_writes <= 0;
                csr_ticks <= 0;
                burst_counter <= 0;
                beat_counter <= 0;
                delay_counter <= 0;
            end
        else
            begin
                if (ticks_incr)
                    csr_ticks <= csr_ticks + 1;
                if (reads_incr)
                    csr_total_reads <= csr_total_reads + 1;
                if (writes_incr)
                    csr_total_writes <= csr_total_writes + 1;
                if (burst_incr)
                    burst_counter <= burst_counter + 1;
                if (beat_incr)
                    beat_counter <= beat_counter + 1;
                if (delay_incr)
                    delay_counter <= delay_counter + 1;
                    
                if (burst_counter_rst)
                    burst_counter <= 0;
                if (beat_counter_rst)
                    beat_counter <= 0;
                if (delay_counter_rst)
                    delay_counter <= 0;
                if (reads_rst)
                    csr_total_reads <= 0;
                if (writes_rst)
                    csr_total_writes <= 0;
                if (ticks_rst)
                    csr_ticks <= 0;
                    
            end
    end
         



endmodule

