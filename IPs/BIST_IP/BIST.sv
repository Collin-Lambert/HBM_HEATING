`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Brigham Young University
// Engineer: Collin Lambert
// 
// Create Date: 05/16/2023 11:05:09 AM
// Design Name: 
// Module Name: BIST
// Project Name: HBM_HEATING
// Target Devices: 
// Tool Versions: 
// Description: This is a state machine that allows for reading and writing to an HBM chip
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
<<<<<<< HEAD
        input wire csr_start,                    //Tells the BIST when to begin/end  
        //output logic start_out,                   //For staggered starts
        input wire [2:0] read_or_write,          //0 for read, 1 for write, 2 for read and write   
        input wire address_inc_csr,
        input wire [31:0] port_mask,
=======
        //input wire [31:0] csr_port_mask,        //Defines which ports are set to read/write
        input wire csr_start,                   //Tells the BIST when to begin/end
        //input wire [31:0] csr_data_pattern,     //The pattern of data to be written     
        input wire [2:0] read_or_write,               //0 for read, 1 for write, 2 for read and write    
        
        
        //INDIVIDUAL CSRs
        output logic [31:0] csr_total_reads,    //Total number of reads
        output logic [31:0] csr_total_writes,   //Total number of writes
        output logic [31:0] csr_read_ticks,          //Number of clock cycles taken per transaction
        output logic [31:0] csr_write_ticks,
        //input wire [31:0] address_readwrite,    //Address to read and write to
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
               
               
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
//    logic [5:0] transaction_id;
//    assign axi_arid = transaction_id;
//    assign axi_awid = transaction_id;

    assign axi_arid = 0;
    assign axi_awid = 0;
    
    //NUM_BYTES = fff = 4096
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
    
    wire [31:0] read_burst_quantity; //The number of transactions per reading or writing command.
    wire [31:0] write_burst_quantity;
    assign read_burst_quantity = 15;
    assign write_burst_quantity = 15; 
    assign axi_arlen = read_burst_quantity;
    assign axi_awlen = write_burst_quantity;
    
    assign axi_arsize = 5; //log2 (axi_port.data_width / 8)
    assign axi_awsize = 5;
   
   
    
    logic [4:0] read_burst_counter, write_burst_counter, read_beat_counter, write_beat_counter;
    
    
    
    
    typedef enum logic [3:0] {READ_WAIT, READ_VALID, READ_BEAT, READ_ERR} ReadState;
    typedef enum logic [3:0] {WRITE_WAIT, WRITE_VALID, WRITE_BEAT, WRITE_LAST, WRITE_ERR} WriteState;
    ReadState rcs, rns;
    WriteState wcs, wns;
   
    logic reads_incr;
    logic writes_incr;
    
    logic read_ticks_incr;
    logic read_burst_incr;
    logic read_beat_incr;
    
    logic write_ticks_incr;
    logic write_burst_incr;
    logic write_beat_incr;
    
    logic reads_rst;
    logic writes_rst;
    
    logic read_beat_counter_rst;
    logic read_burst_counter_rst;
    logic read_ticks_rst;
    
    logic write_beat_counter_rst;
    logic write_burst_counter_rst;
    logic write_ticks_rst;
    
    
    logic [31:0] csr_data_pattern;     //The pattern of data to be written  
    assign csr_data_pattern = 32'ha5a5a5a5;
    assign axi_wdata = {8{csr_data_pattern}};
    assign axi_wstrb = 'hF;
    assign axi_arburst = 'b01;  //Set burst type to INCR
    assign axi_awburst = 'b01;
    
    logic [32:0] address_read;    //Address to read from
    logic [32:0] address_write;        //Addres to write to
    
    //Increment to the next start address
    assign address_read = 33'h0 + (bist_num * 33'h10000000);
    assign address_write = address_read + 100; 
    
    //Bottom 5 bits of the address are unused as per the HBM IP specification
    
<<<<<<< HEAD
    logic [5:0] outstanding_reads, outstanding_writes;
    //logic [15:0] start_delay;
    logic outstanding_reads_inc, r_address_inc, outstanding_reads_dec, outstanding_writes_inc, w_address_inc, outstanding_writes_dec;
=======
    
    
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
    
    
    assign axi_awaddr = address_write;
    assign axi_araddr = address_read;
    
<<<<<<< HEAD
=======
    assign csr_port_setting = read_or_write;
    
    assign axi_arid = 0;
    assign axi_awid = 0;
    assign axi_rid = 0;
    
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
    //read state machine and write state machine
    always_comb
    begin
    axi_arvalid = 0;
    axi_rready = 0;
    read_ticks_incr = 0;
    read_burst_incr = 0;
    reads_incr = 0;
    read_beat_incr = 0;
    read_beat_counter_rst = 0;
    read_burst_counter_rst = 0;
    reads_rst = 0;
    read_ticks_rst = 0;
    rns = READ_WAIT;
    
    write_ticks_incr = 0;
    write_burst_incr = 0;
    writes_incr = 0;
    axi_awvalid = 0;
    axi_wvalid = 0;
    axi_wlast = 0;
    axi_bready = 0;
    write_beat_incr = 0;
    write_beat_counter_rst = 0;
    write_burst_counter_rst = 0;
    writes_rst = 0;
    write_ticks_rst = 0;
    wns = WRITE_WAIT;
<<<<<<< HEAD
    if (port_mask[bist_num])
    begin
        if (!axi_aresetn)
            begin
                rns = READ_WAIT;
                wns = WRITE_WAIT;
                qarns = AR_WAIT;
                qrns = R_WAIT;
            end
        else
            begin
                //Read portion
                case(rcs)
                    READ_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b000)) //READ
                                begin
                                    rns = READ_VALID;
                                end
                            else
                                rns = rcs;
                        end
                    READ_VALID:
                        begin
                            if (csr_start)
                                axi_arvalid = 1;
                            if (!csr_start)
                                begin
                                    rns = READ_WAIT;
                                end
                            else if (axi_arready)
                                begin
                                    rns = READ_BEAT;
                                end
                            else
                                begin
                                    rns = READ_VALID;
                                end
                        end
                    READ_BEAT:
                        begin
                            axi_rready = 1;
                            if (axi_rvalid && axi_rlast)
                                begin
                                    read_burst_incr = 1;
                                    if ((read_burst_counter + 1) >= read_burst_quantity)
                                        begin
                                            if (!csr_start)
                                                begin
                                                    rns = READ_WAIT;
                                                end
                                            else
                                                begin
                                                    read_beat_counter_rst = 1;
                                                    read_burst_counter_rst = 1;
                                                    rns = READ_VALID;
                                                end
                                        end
                                    else
                                        begin
                                            read_beat_counter_rst = 1;
                                            rns = READ_VALID;
                                        end
                                end
                            else if (axi_rvalid)
                                begin
                                    rns = READ_BEAT;
                                end
                            else
                                begin
                                    rns = rcs;
                                end
                        end
                endcase
                
                //Write portion
                case(wcs)
                    WRITE_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b001)) //WRITE
                                begin
                                    wns = WRITE_VALID;
                                end
                            else
                                wns = wcs;
                        end
                    WRITE_VALID:
                        begin
                            if (csr_start)
                                begin
                                axi_awvalid = 1;
                                axi_wvalid = 1;
                                end
                            if (!csr_start)
                                begin
                                    wns = WRITE_WAIT;
                                end
                            else if (axi_awready && (axi_awlen > 0))
                                begin
                                    if (axi_wready)
                                        write_beat_incr = 1;
                                    wns = WRITE_BEAT;
                                end
                            else if (axi_awready)
                                begin
                                    axi_wlast = 1;
                                    write_burst_incr = 1;
                                    wns = WRITE_LAST;
                                end
                            else
                                begin
                                    wns = WRITE_VALID;
                                end
                        end
                        
                    WRITE_BEAT:
                        begin
                            axi_wvalid = 1;
                            if (axi_wready && (write_beat_counter < axi_awlen))
                                begin
                                    write_beat_incr = 1;
                                    wns = WRITE_BEAT;
                                end
                            else if (write_beat_counter == axi_awlen)
                                begin
                                    axi_wlast = 1;
                                    if (axi_wready)
                                        begin
                                            write_beat_counter_rst = 1;
                                            write_burst_incr = 1;
                                            wns = WRITE_LAST;
                                        end
                                    else
                                        wns = wcs;
                                end
                            else
                                begin
                                    wns = WRITE_BEAT;
                                end
                        end
                    
                    WRITE_LAST:
                        begin
                            axi_bready = 1;
                            if (axi_bvalid && (write_burst_counter >= write_burst_quantity))
                                begin
                                    if (!csr_start)
                                        begin
                                            wns = WRITE_WAIT;
                                        end
                                    else
                                        begin
                                            write_beat_counter_rst = 1;
                                            write_burst_counter_rst = 1;
                                            wns = WRITE_VALID;
                                        end
                                end
                            else if (axi_bvalid)
                                begin
                                    write_beat_counter_rst = 1;
                                    wns = WRITE_VALID;
                                end
                            else
                                begin
                                    wns = WRITE_LAST;
                                end
                        end
                endcase
                
                case(qarcs)
                    AR_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b011))
                                begin
                                    qarns = AR_VALID;
                                end
                            else
                                qarns = qarcs;
                        end
                    AR_VALID:
                        begin
                            if (csr_start)
                                axi_arvalid = 1;
                            if (!csr_start)
                                begin
                                    qarns = AR_WAIT;
                                end
                            else if (axi_arready)
                                begin
                                    qarns = AR_INC;
                                end
                            else
                                begin
                                    qarns = AR_VALID;
                                end
                        end
                    AR_INC:
                        begin
                            r_address_inc = 1;
                            outstanding_reads_inc = 1;
                            qarns = AR_CHECK;
                        end
                    AR_CHECK:
                        begin
                            if (outstanding_reads <= 60)
                                begin
                                    qarns = AR_VALID;
                                end
                            else 
                                begin
                                    qarns = AR_CHECK;
                                end
                        end
                        
                endcase
                
                case(qrcs)
                    R_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b011))
                                begin
                                    qrns = R_BEAT;
                                end
                            else
                                begin
                                    qrns = qrcs;
                                end
                        end
                    R_BEAT:
                        begin
                            axi_rready = 1;
                            if (!csr_start && (outstanding_reads == 0))
                                begin
                                    qrns = R_WAIT;
                                end
                            else if (axi_rvalid && axi_rlast)
                                begin
                                    qrns = R_INC;
                                end
                            else if (axi_rvalid)
                                begin
                                    qrns = R_BEAT;
                                end
                            else
                                qrns = R_BEAT;
                        end
                    R_INC:
                        begin
                            outstanding_reads_dec = 1;
                            qrns = R_BEAT;
                        end
                endcase
    
                case(qawcs)
                    AW_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b100))
                                begin
                                    qawns = AW_VALID;
                                end
                            else
                                qawns = qawcs;
                        end
                    AW_VALID:
                        begin
                            if (csr_start)
                                axi_awvalid = 1;
                            if (!csr_start)
                                begin
                                    qawns = AW_WAIT;
                                end
                            else if (axi_awready)
                                begin
                                    qawns = AW_INC;
                                end
                            else
                                begin
                                    qawns = AW_VALID;
                                end
                        end
                    AW_INC:
                        begin
                            w_address_inc = 1;
                            outstanding_writes_inc = 1;
                            qawns = AW_CHECK;
                        end
                    AW_CHECK:
                        begin   
                            if (!csr_start)
                                qawns = AW_WAIT;
                            else
                                begin
                                    if (outstanding_writes <= 60)
                                        begin
                                            qawns = AW_VALID;
                                        end
                                    else 
                                        begin
                                            qawns = AW_CHECK;
                                        end
                                end
                        end
                endcase
                
                case(qwcs)
                    W_WAIT:
                        begin
                            if (csr_start && (csr_port_setting == 3'b100))
                                begin
                                    qwns = W_BEAT;
                                end
                            else
                                qwns = qwcs;
                        end
    
                    W_BEAT:
                        begin
                            axi_wvalid = 1;
                            if (!csr_start && (outstanding_writes == 0))
                                begin
                                    qwns = W_WAIT;
                                end
                            else if (axi_wready && (write_beat_counter < axi_awlen))
                                begin
                                    write_beat_incr = 1;
                                    qwns = W_BEAT;
                                end
                            else if (write_beat_counter == axi_awlen)
                                begin
                                    axi_wlast = 1;
                                    if (!csr_start)
                                        begin
                                            qwns = W_WAIT;
                                        end
                                    else if (axi_wready)
                                        begin
                                            write_beat_counter_rst = 1;
                                            qwns = W_LAST;
                                        end
                                    else
                                        qwns = qwcs;
                                end
                            else
                                qwns = W_BEAT;
                        end
                    
                    W_LAST:
                        begin
                            axi_bready = 1;
                            if (axi_wready)
                                begin
                                    axi_wlast = 1;
                                    axi_wvalid = 1;
                                end
                            if (!csr_start && (outstanding_writes == 0))
                                begin
                                    qwns = W_WAIT;
                                end
                            else if (axi_bvalid)
                                begin
                                    write_beat_counter_rst = 1;
                                    outstanding_writes_dec = 1;
                                    axi_wvalid = 0;
                                    if (csr_start || (outstanding_writes > 1))
                                        qwns = W_BEAT;
                                    else
                                        qwns = W_WAIT;
                                end
                            else
                                qwns = qwcs;
                        end
    
                endcase 
    
    
            end
=======
    
    if (!axi_aresetn)
        begin
            rns = READ_WAIT;
            wns = WRITE_WAIT;
        end
    else
        begin
            //Read portion
            case(rcs)
                READ_WAIT:
                    begin
                        if (csr_start && ((csr_port_setting == 0) || (csr_port_setting == 2))) //READ
                            begin
                                rns = READ_VALID;
                            end
                        else
                            rns = rcs;
                    end
                READ_VALID:
                    begin
                        axi_arvalid = 1;
                        read_ticks_incr = 1;
                        if (!csr_start)
                            begin
                                rns = READ_WAIT;
                            end
                        else if (axi_arready)
                            begin
                                rns = READ_BEAT;
                            end
                        else
                            begin
                                rns = READ_VALID;
                            end
                    end
                READ_BEAT:
                    begin
                        axi_rready = 1;
                        read_ticks_incr = 1;
                        if (!csr_start)
                            begin
                                rns = READ_WAIT;
                            end
                        else if (axi_rvalid && axi_rlast)
                            begin
                                read_burst_incr = 1;
                                if ((read_burst_counter + 1) >= read_burst_quantity)
                                    begin
                                        if (!csr_start)
                                            begin
                                                reads_incr = 1;
                                                rns = READ_WAIT;
                                            end
                                        else
                                            begin
                                                read_beat_counter_rst = 1;
                                                read_burst_counter_rst = 1;
                                                read_ticks_rst = 1;
                                                reads_rst = 1;
                                                rns = READ_VALID;
                                            end
                                    end
                                else
                                    begin
                                        reads_incr = 1;
                                        read_beat_counter_rst = 1;
                                        rns = READ_VALID;
                                    end
                            end
                        else if (axi_rvalid)
                            begin
                                reads_incr = 1;
                                rns = READ_BEAT;
                            end
                        else
                            begin
                                rns = rcs;
                            end
                    end
            endcase
            
            //Write portion
            case(wcs)
                WRITE_WAIT:
                    begin
                        if (csr_start && ((csr_port_setting == 1) || (csr_port_setting == 2))) //WRITE
                            begin
                                wns = WRITE_VALID;
                            end
                        else
                            wns = wcs;
                    end
                WRITE_VALID:
                    begin
                        axi_awvalid = 1;
                        axi_wvalid = 1;
                        write_ticks_incr = 1;
                        if (!csr_start)
                            begin
                                wns = WRITE_WAIT;
                            end
                        else if (axi_awready && axi_wready && (axi_awlen > 0))
                            begin
                                writes_incr = 1;
                                write_beat_incr = 1;
                                wns = WRITE_BEAT;
                            end
                        else if (axi_awready && axi_wready)
                            begin
                                axi_wlast = 1;
                                writes_incr = 1;
                                write_burst_incr = 1;
                                wns = WRITE_LAST;
                            end
                        else
                            begin
                                wns = WRITE_VALID;
                            end
                    end
                    
                WRITE_BEAT:
                    begin
                        axi_wvalid = 1;
                        write_ticks_incr = 1;
                        if (axi_wready && (write_beat_counter < axi_awlen))
                            begin
                                writes_incr = 1;
                                write_beat_incr = 1;
                                wns = WRITE_BEAT;
                            end
                        else if (axi_wready && (write_beat_counter == axi_awlen))
                            begin
                                axi_wlast = 1;
                                writes_incr = 1;
                                write_beat_counter_rst = 1;
                                write_burst_incr = 1;
                                wns = WRITE_LAST;
                            end
                        else
                            begin
                                wns = WRITE_BEAT;
                            end
                    end
                
                WRITE_LAST:
                    begin
                        axi_wvalid = 1;
                        axi_bready = 1;
                        write_ticks_incr = 1;
                        if (axi_bvalid && (write_burst_counter >= write_burst_quantity))
                            begin
                                if (!csr_start)
                                    begin
                                        wns = WRITE_WAIT;
                                    end
                                else
                                    begin
                                        write_beat_counter_rst = 1;
                                        write_burst_counter_rst = 1;
                                        write_ticks_rst = 1;
                                        writes_rst = 1;
                                        wns = WRITE_VALID;
                                    end
                            end
                        else if (axi_bvalid)
                            begin
                                write_beat_counter_rst = 1;
                                wns = WRITE_VALID;
                            end
                        else
                            begin
                                wns = WRITE_LAST;
                            end
                    end
            endcase
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
        end
    end
    
    
    
    always_ff @(posedge axi_aclk)
    begin
        rcs <= rns;
        wcs <= wns;
<<<<<<< HEAD
        qarcs <= qarns;
        qrcs <= qrns;
        qawcs <= qawns;
        qwcs <= qwns;
//        start_delay <= 0;
//        start_out <= 0;
=======
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
        
        if (!axi_aresetn)
            begin
                csr_total_reads <= 0;
                csr_total_writes <= 0;
                csr_read_ticks <= 0;
                csr_write_ticks <= 0;
                read_burst_counter <= 0;
                read_beat_counter <= 0;
                write_burst_counter <= 0;
                write_beat_counter <= 0;
<<<<<<< HEAD
                outstanding_reads <= 0;
                outstanding_writes <= 0;
                //transaction_id <= 0;
                address_read <= default_address;
                address_write <= default_address;
            end
        else
            begin
//                if (start_delay < 65000 && csr_start)
//                    begin
//                        start_delay <= start_delay + 1;
//                        start_out <= 0;
//                    end
//                else if (csr_start)
//                    begin
//                        start_delay <= start_delay;
//                        start_out <= 1;
//                    end
//                else
//                    begin
//                        start_delay <= 0;
//                        start_out <= 0;
//                    end
                //transaction_id <= transaction_id + 1;
=======
            end
        else
            begin
                if (read_ticks_incr)
                    csr_read_ticks <= csr_read_ticks + 1;
                if (write_ticks_incr)
                    csr_write_ticks <= csr_write_ticks + 1;
                if (reads_incr)
                    csr_total_reads <= csr_total_reads + 1;
                if (writes_incr)
                    csr_total_writes <= csr_total_writes + 1;
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
                if (read_burst_incr)
                    read_burst_counter <= read_burst_counter + 1;
<<<<<<< HEAD
                    if (address_inc_csr)
                        begin
                            //This prevents the address from exceeding 4096 above the base address
                            //For some reason this is required
                            if (address_read <= address_limit)
                                //Using burst type of INCR each burst uses up 32 addresses
                                //Since there are 16 bursts per transaction, each transaction uses 512 (0x200) addresses.
                                //The next sequential address should then be curr_address + 0x200
                                address_read <= address_read + 'h200;
                            else
                                address_read <= default_address;
                        end
                    else
                        address_read <= default_address;
                    end
=======
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
                if (read_beat_incr)
                    read_beat_counter <= read_beat_counter + 1;
                if (write_burst_incr)
                    write_burst_counter <= write_burst_counter + 1;
<<<<<<< HEAD
                    if (address_inc_csr)
                        begin
                            if (address_write <= address_limit)
                                address_write <= address_write + 'h200;
                            else
                                address_write <= default_address;
                        end
                    else
                        address_write <= default_address;
                    end
=======
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
                if (write_beat_incr)
                    write_beat_counter <= write_beat_counter + 1;
                    
                if (read_burst_counter_rst)
                    read_burst_counter <= 0;
                if (read_beat_counter_rst)
                    read_beat_counter <= 0;
                if (write_burst_counter_rst)
                    write_burst_counter <= 0;
                if (write_beat_counter_rst)
                    write_beat_counter <= 0;
<<<<<<< HEAD
                if (r_address_inc)
                    begin 
                        if (address_inc_csr)
                            begin
                                if (address_read <= address_limit)
                                    address_read <= address_read + 'h200;
                                else
                                    address_read <= default_address;
                                //address_read <= address_read;
                            end
                        else
                            address_read <= default_address;
                    end
                if (w_address_inc)
                    begin
                        if (address_inc_csr)
                            begin
                                if (address_write <= address_limit)
                                    address_write <= address_write + 'h200;
                                else
                                    address_write <= default_address;
                                //address_write <= address_write;
                            end
                        else
                            address_write <= default_address;
                    end
                if (outstanding_reads_inc)
                    outstanding_reads <= outstanding_reads + 1;
                if (outstanding_reads_dec && outstanding_reads >= 1)
                    outstanding_reads <= outstanding_reads - 1;
                if (outstanding_writes_inc)
                    outstanding_writes <= outstanding_writes + 1;
                if (outstanding_writes_dec && outstanding_writes >= 1)
                    outstanding_writes <= outstanding_writes - 1;
=======
                if (reads_rst)
                    csr_total_reads <= 0;
                if (writes_rst)
                    csr_total_writes <= 0;
                if (read_ticks_rst)
                    csr_read_ticks <= 0;
                if (write_ticks_rst)
                    csr_write_ticks <= 0;
>>>>>>> b29fe04f2901e3a7bb2196c344df2acd025f04df
                    
            end
    end
         



endmodule

