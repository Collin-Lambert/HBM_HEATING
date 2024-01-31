#include <sstream>
#include <vector>
#include "serial_port.hpp"

void PrintHelp()
{
    std::cout << "Commands:" << std::endl;
    std::cout << "\t help               - displays this list" << std::endl;
    std::cout << "\t start              - enables reading / writing test" << std::endl;
    std::cout << "\t stop               - halts reading / writing test" << std::endl
              << std::endl;
    std::cout << "\t write_set              - enables sequential writing" << std::endl;
    std::cout << "\t read_set               - enables sequential reading" << std::endl;
    std::cout << "\t queued_read_set [qrs]  - enables queued reading" << std::endl;
    std::cout << "\t queued_write_set [qws] - enables queued writing" << std::endl
              << std::endl;
    std::cout << "\t write / read / queued_write / queued_read support the following options:" << std::endl;
    std::cout << "\t\t -ports [port_select]                    - 32 bit hex number for which ports to enable" << std::endl;
    std::cout << "\t\t -mode [addressing_mode (inc or static)] - specifies whether to increment address or not" << std::endl;
    std::cout << "\t\t -length [transaction_length]            - 4 bit hex number for length of transaction" << std::endl
              << std::endl;
    std::cout << "\t address_inc_set        - enables address incrementing" << std::endl;
    std::cout << "\t address_static_set     - disables address incrementing" << std::endl;
    std::cout << "\t reset                  - resets" << std::endl;
    std::cout << "\t port_select            - 32 bit hex number for which ports to enable" << std::endl;
    std::cout << "\t transaction_length_set - 4 bit hex number for length of transaction" << std::endl
              << std::endl;
    std::cout << "\t clk_set_550  - set clock speed to 550 MHz" << std::endl;
    std::cout << "\t clk_set_450  - set clock speed to 450 MHz" << std::endl;
    std::cout << "\t clk_set_325  - set clock speed to 325 MHz" << std::endl
              << std::endl;
    std::cout << "\t get_axi_throughput [gtp] - sample data rate from each axi port" << std::endl;
    std::cout << "\t log_temp                 - get time stamped readout of HBM temps" << std::endl;
    std::cout << "\t get_HBM_temp [hbmt]      - get current HBM temperature" << std::endl;
    std::cout << "\t get_FPGA_temp [fpgat]    - get current FPGA temperature" << std::endl;
    std::cout << std::endl;
    std::cout << "\t load_defaults [ld] - initializes system with default settings" << std::endl
              << std::endl;
    std::cout << "\t exit - to exit" << std::endl;
}

// Returns vector of arguments for command
std::vector<std::string> ParseArgs(std::string input)
{
    std::stringstream argStream(input);

    std::vector<std::string> args;
    std::string arg;

    while (!argStream.eof())
    {
        argStream >> arg;
        args.push_back(arg);
    }

    return args;
}

// Convert ascii character to hex counterpart. 'F' in ascii will turn into 'F' in hex
unsigned char ascii_to_hex(unsigned char ascii_char)
{
    unsigned char hex_char = 0;
    switch (ascii_char)
    {
    case '0':
        hex_char |= 0;
        break;
    case '1':
        hex_char |= 1;
        break;
    case '2':
        hex_char |= 2;
        break;
    case '3':
        hex_char |= 3;
        break;
    case '4':
        hex_char |= 4;
        break;
    case '5':
        hex_char |= 5;
        break;
    case '6':
        hex_char |= 6;
        break;
    case '7':
        hex_char |= 7;
        break;
    case '8':
        hex_char |= 8;
        break;
    case '9':
        hex_char |= 9;
        break;
    case 'A':
        hex_char |= 10;
        break;
    case 'B':
        hex_char |= 11;
        break;
    case 'C':
        hex_char |= 12;
        break;
    case 'D':
        hex_char |= 13;
        break;
    case 'E':
        hex_char |= 14;
        break;
    case 'F':
        hex_char |= 15;
        break;
    }
    return hex_char;
}

void port_select(SerialPort *serial_port, std::string ports = "")
{
    if (ports.empty())
    {
        std::cout << "\t Enter 32 bit port selection as a hex number [8 digits]" << std::endl;
        std::cout << "\t 0x";

        std::getline(std::cin, ports);
    }

    unsigned char digit_0 = ascii_to_hex(ports[0]);
    unsigned char digit_1 = ascii_to_hex(ports[1]);
    unsigned char digit_2 = ascii_to_hex(ports[2]);
    unsigned char digit_3 = ascii_to_hex(ports[3]);
    unsigned char digit_4 = ascii_to_hex(ports[4]);
    unsigned char digit_5 = ascii_to_hex(ports[5]);
    unsigned char digit_6 = ascii_to_hex(ports[6]);
    unsigned char digit_7 = ascii_to_hex(ports[7]);

    unsigned char byte_0 = (digit_0 << 4) | digit_1;
    unsigned char byte_1 = (digit_2 << 4) | digit_3;
    unsigned char byte_2 = (digit_4 << 4) | digit_5;
    unsigned char byte_3 = (digit_6 << 4) | digit_7;

    serial_port->send_port_select();

    serial_port->writeSerialPortHex(byte_0);
    serial_port->writeSerialPortHex(byte_1);
    serial_port->writeSerialPortHex(byte_2);
    serial_port->writeSerialPortHex(byte_3);

    // debugging
    // printf("byte_0: %02x\n", byte_0);
    // printf("byte_1: %02x\n", byte_1);
    // printf("byte_2: %02x\n", byte_2);
    // printf("byte_3: %02x\n", byte_3);

    // std::this_thread::sleep_for(std::chrono::milliseconds(100));
    //  Read and display response
    serial_port->readSerialPort();
    // std::cout << "made it this far" << std::endl;
}

void transaction_length_set(SerialPort *serial_port, std::string length = "")
{
    if (length.empty())
    {
        std::cout << "\t Enter 4 bit length selection as a hex number [1 digit]" << std::endl;
        std::cout << "\t 0x";

        std::getline(std::cin, length);
    }

    unsigned char hex_char = ascii_to_hex(length[0]);
    serial_port->send_transaction_length_set();

    serial_port->writeSerialPortHex(hex_char);

    // Read and display response
    serial_port->readSerialPort();
}

void addressing_mode_set(SerialPort *serial_port, std::string mode)
{
    if (mode == "inc")
    {
        serial_port->send_address_inc_set();
    }
    else if (mode == "static")
    {
        serial_port->send_address_static_set();
    }
    else
    {
        std::cout << std::endl
                  << "Invalid Command!" << std::endl;
        PrintHelp();
        return;
    }
}

void do_read_write_args(SerialPort *serial_port, std::vector<std::string> &args)
{
    for (int i = 1; i < args.size(); ++i)
    {
        if (args[i] == "-ports")
        {
            port_select(serial_port, args[i + 1]);
            ++i;
        }
        else if (args[i] == "-mode")
        {
            addressing_mode_set(serial_port, args[i + 1]);
            ++i;
        }
        else if (args[i] == "-length")
        {
            transaction_length_set(serial_port, args[i + 1]);
            ++i;
        }
        else
        {
            std::cout << std::endl
                      << "Invalid Command!" << std::endl;
            PrintHelp();
        }
    }
    // std::cout << "Finished read write args execution" << std::endl;
}

void load_defaults(SerialPort *serial_port)
{
    serial_port->send_queued_read_set();
    port_select(serial_port, "FFFFFFFF");
    addressing_mode_set(serial_port, "inc");
    serial_port->send_clk_set_450();
}

int main()
{
    // std::cout << "creating serial port" << std::endl;
    //  Create serial_port
    SerialPort *serial_port = new SerialPort();
    // std::cout << "created serial port" << std::endl;

    // std::cout << "reseting" << std::endl;
    serial_port->send_reset();
    // std::cout << "reset" << std::endl;

    std::vector<std::string> args;
    std::string user_input;

    // // Main loop
    while (true)
    {
        std::cout << "\033[33mHBM "
                  << "\033[39m> ";

        std::getline(std::cin, user_input);

        tcflush(serial_port->get_fd(), TCIFLUSH);

        // Check for exit condition
        if (user_input == "exit")
        {
            break;
        }

        args = ParseArgs(user_input);
        if (args[0] == "help")
        {
            PrintHelp();
        }
        else if (args[0] == "start")
        {
            serial_port->send_start();
        }
        else if (args[0] == "stop")
        {
            serial_port->send_stop();
        }
        else if (args[0] == "write_set")
        {
            serial_port->send_write_set();
            do_read_write_args(serial_port, args);
        }
        else if (args[0] == "read_set")
        {
            serial_port->send_read_set();
            do_read_write_args(serial_port, args);
        }
        else if (args[0] == "queued_write_set" || args[0] == "qws")
        {
            serial_port->send_queued_write_set();
            do_read_write_args(serial_port, args);
        }
        else if (args[0] == "queued_read_set" || args[0] == "qrs")
        {
            serial_port->send_queued_read_set();
            do_read_write_args(serial_port, args);
        }
        else if (args[0] == "address_inc_set")
        {
            serial_port->send_address_inc_set();
        }
        else if (args[0] == "address_static_set")
        {
            serial_port->send_address_static_set();
        }
        else if (args[0] == "reset")
        {
            serial_port->send_reset();
        }
        else if (args[0] == "port_select")
        {
            port_select(serial_port);
        }
        else if (args[0] == "transaction_length_set")
        {
            transaction_length_set(serial_port);
        }
        else if (args[0] == "clk_set_550")
        {
            serial_port->send_clk_set_550();
        }
        else if (args[0] == "clk_set_450")
        {
            serial_port->send_clk_set_450();
        }
        else if (args[0] == "clk_set_325")
        {
            serial_port->send_clk_set_325();
        }
        else if (args[0] == "get_axi_throughput" || args[0] == "gtp")
        {
            serial_port->get_axi_throughput();
        }
        else if (args[0] == "log_temp")
        {
            serial_port->log_temp();
        }
        else if (args[0] == "get_HBM_temp" || args[0] == "hbmt")
        {
            serial_port->get_HBM_temperature();
        }
        else if (args[0] == "get_FPGA_temp" || args[0] == "fpgat")
        {
            serial_port->get_FPGA_temperature();
        }
        else if (args[0] == "run_tests")
        {
            serial_port->send_run_tests();
        }
        else if (args[0] == "load_defaults" || args[0] == "ld")
        {
            load_defaults(serial_port);
        }
        else
        {
            PrintHelp();
        }
    }
    // std::cout << "End of program" << std::endl;
    //  Close the serial port
    serial_port->closeSerialPort();
}