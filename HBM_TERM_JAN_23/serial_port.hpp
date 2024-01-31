#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <chrono>
#include <thread>
#include <deque>
#include <vector>
#include <iomanip>
#include <cstdlib>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>

#define BUFFER_SIZE 256

class SerialPort
{
public:
    SerialPort();
    ~SerialPort();
    void openSerialPort();
    void closeSerialPort();
    void configureSerialPort();
    void writeSerialPort(const char *data);
    void writeSerialPortHex(const unsigned char hexVal);
    void readSerialPort(bool print_data = true);
    int readSerialPortBinary();
    void send_reset();
    void send_start();
    void send_stop();
    void send_write_set();
    void send_read_set();
    void send_queued_read_set();
    void send_queued_write_set();
    void send_address_inc_set();
    void send_address_static_set();
    void send_port_select();
    void send_transaction_length_set();
    void send_clk_set_550();
    void send_clk_set_450();
    void send_clk_set_325();
    void send_run_tests();
    void get_axi_throughput();
    void log_temp();
    unsigned char get_HBM_temperature(bool print_data = true);
    double get_FPGA_temperature(bool print_data = true);
    int get_fd()
    {
        return fd;
    }

private:
    int fd;
    char *buffer;

    const char *PORT = "/dev/ttyUSB1";
    const speed_t BAUD_RATE = B19200;

    std::string decodeResponse(char *response);
};