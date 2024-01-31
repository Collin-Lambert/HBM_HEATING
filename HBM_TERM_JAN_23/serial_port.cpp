#include "serial_port.hpp"

SerialPort::SerialPort()
{
    // std::cout << "SerialPort constructor called" << std::endl;
    this->openSerialPort();
    this->configureSerialPort();
    this->buffer = new char[BUFFER_SIZE];
}

SerialPort::~SerialPort()
{
    // std::cout << "Running SerialPort destructor" << std::endl;
    delete buffer;
}

void SerialPort::openSerialPort()
{
    int fd = open(PORT, O_RDWR | O_NOCTTY | O_NDELAY);
    if (fd == -1)
    {
        perror("openSerialPort: Unable to open serial port");
        exit(EXIT_FAILURE);
    }
    this->fd = fd;
}

void SerialPort::configureSerialPort()
{
    struct termios options;
    tcgetattr(fd, &options);

    // Set baud rate
    cfsetispeed(&options, BAUD_RATE);
    cfsetospeed(&options, BAUD_RATE);

    // Enable receiver and set local mode
    options.c_cflag |= (CLOCAL | CREAD);

    // Set parity, data bits, and stop bitsQuick Access
    options.c_cflag |= PARENB;  // Enable parity bit
    options.c_cflag |= PARODD;  // Set odd parity
    options.c_cflag &= ~CSTOPB; // Set 1 stop bit
    options.c_cflag &= ~CSIZE;  // Clear data bits
    options.c_cflag |= CS8;     // Set 8 data bits

    // Disable canonical mode, echo, signals
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);

    // Disable software flow control
    options.c_iflag &= ~(IXON | IXOFF | IXANY);

    // Disable output processing
    options.c_oflag &= ~OPOST;

    // Apply the modified options
    tcsetattr(fd, TCSANOW, &options);
}

void SerialPort::closeSerialPort()
{
    close(this->fd);
}

void SerialPort::writeSerialPort(const char *data)
{
    write(this->fd, data, strlen(data));
}

void SerialPort::writeSerialPortHex(const unsigned char hexVal)
{
    write(this->fd, &hexVal, sizeof(hexVal));
}

// Function to read data from the serial port
void SerialPort::readSerialPort(bool print_data)
{
    bool status = true;
    int bytesRead;
    while (status)
    {

        bytesRead = read(this->fd, buffer, BUFFER_SIZE - 1);

        if (bytesRead > 0)
        {
            buffer[bytesRead] = '\0';
            status = false;
        }
    }
    // printf("Bytes Read: %d\n", bytesRead);
    if (print_data)
    {
        std::cout << " - " << decodeResponse(buffer) << std::endl
                  << std::endl;
    }
}

// Function to read data from the serial port
int SerialPort::readSerialPortBinary()
{

    bool status = true;
    int value;
    while (status)
    {

        int bytesRead = read(this->fd, buffer, BUFFER_SIZE - 1);
        if (bytesRead > 0)
        {
            buffer[bytesRead] = '\0';
            status = false;
            value = static_cast<unsigned char>(buffer[1]);
            value = value << 8;
            value = value | static_cast<unsigned char>(buffer[0]);
        }
    }
    return value;
}

// Decode response from UART to something a little more readable
std::string SerialPort::decodeResponse(char *response)
{
    switch (response[0])
    {
    case 'A':
        return "started test";
    case 'B':
        return "stopped test";
    case 'C':
        return "set mode to \"write\"";
    case 'D':
        return "set mode to \"read\"";
    case 'E':
        return "set mode to \"concurrent reads and writes\"";
    case 'F':
        return "set mode to \"queued reads\"";
    case 'G':
        return "set mode to \"queued write\"";
    case 'H':
        return "Enabled address incrementing";
    case 'I':
        return "Disabled address incrementing";
    case 'J':
        return "Set ports";
    case 'K':
        return "Reset";
    case 'L':
        return "Set transaction length";
    case 'M':
        return "Sampling...";
    case 'N':
        return "Setting Clock To 550MHz...";
    case 'O':
        return "Setting Clock To 450MHz...";
    case 'P':
        return "Setting Clock To 325MHz...";
    case 'Q':
        return "Locked";
    case 'R':
        return "RO mode enabled";
    case '?':
        return "[ERROR : ?]";
    default:
        return ("[ERROR : unknown response");
    }
}

void SerialPort::send_reset()
{
    // Reset
    writeSerialPort("@");
    readSerialPort();
}
void SerialPort::send_start()
{
    // Start
    writeSerialPort("0");
    readSerialPort();
}
void SerialPort::send_stop()
{
    // Stop
    writeSerialPort("1");
    readSerialPort();
}
void SerialPort::send_write_set()
{
    writeSerialPort("2");
    readSerialPort();
}
void SerialPort::send_read_set()
{
    writeSerialPort("3");
    readSerialPort();
}
void SerialPort::send_queued_read_set()
{
    writeSerialPort("5");
    readSerialPort();
}
void SerialPort::send_queued_write_set()
{
    writeSerialPort("6");
    readSerialPort();
}
void SerialPort::send_address_inc_set()
{
    writeSerialPort("7");
    readSerialPort();
}
void SerialPort::send_address_static_set()
{
    writeSerialPort("8");
    readSerialPort();
}
void SerialPort::send_port_select()
{
    writeSerialPort("9");
}
void SerialPort::send_transaction_length_set()
{
    writeSerialPort(":");
}
void SerialPort::send_clk_set_550()
{
    writeSerialPort("<");
    readSerialPort();
}
void SerialPort::send_clk_set_450()
{
    writeSerialPort("=");
    readSerialPort();
}
void SerialPort::send_clk_set_325()
{
    writeSerialPort(">");
    readSerialPort();
}
void SerialPort::send_run_tests() {}

void SerialPort::get_axi_throughput()
{
    writeSerialPort(";");
    readSerialPort();
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    readSerialPort(false);

    unsigned int data = 0;
    double total_throughput = 0;

    std::cout << "AXI port  |  Transactions (0x)  |  Transactions (0d) |  Throughput" << std::endl;
    // for (int i = 0; i < 128; ++i)
    // {
    //     printf("%02X\n", (unsigned char)buffer[i]);
    // }

    for (int i = 0; i < 32; ++i)
    {
        data = static_cast<unsigned char>(buffer[(i * 4) + 3]);
        data = data << 8 | static_cast<unsigned char>(buffer[(i * 4) + 2]);
        data = data << 8 | static_cast<unsigned char>(buffer[(i * 4) + 1]);
        data = data << 8 | static_cast<unsigned char>(buffer[(i * 4)]);
        printf("%-12d %08X          ->  %-16d ->  %-4.2f GB/s\n", i, data, data, ((data * 32.0 * 16.0 * 1000) / 1000000000.0));
        total_throughput += ((data * 32.0 * 16.0 * 1000) / 1000000000.0);
    }
    printf("\nTotal Throughput -> %3.2f GB/s\n", total_throughput);
}
void SerialPort::log_temp()
{
    std::vector<double> rawHBMTemperatureList;
    std::vector<double> rawFPGATemperatureList;
    std::ofstream temperatures;

    std::string suffix;
    std::cout << "Enter Test Name: ";
    std::getline(std::cin, suffix);

    int duration;
    std::cout << "Enter Test Duration: ";
    scanf("%d", &duration);

    // The following cleans up the standard input
    std::string junk;
    std::getline(std::cin, junk);

    temperatures.open("raw_temperatures_" + suffix + ".csv");
    temperatures << "Time,Temperature_HBM,Temperature_FPGA" << std::endl;

    double timeMs = -2000;
    double displayTime;
    double FPGA_idle_temp;
    double FPGA_final_temp;
    double FPGA_current_temp;
    int HBM_idle_temp;
    int HBM_final_temp;
    int HBM_current_temp;

    int poll_cycles = duration * 2 + 1;

    std::cout << std::endl
              << "Time Relative to Start  |  Temperature (°C) HBM  |  Temperature (°C) FPGA" << std::endl;

    // Pre Start
    for (int i = 0; i < 4; ++i)
    {
        // Send command to the device
        displayTime = timeMs / 1000.0;
        HBM_current_temp = get_HBM_temperature(false);
        FPGA_current_temp = get_FPGA_temperature(false);
        printf("%22.1f -> %20.1d °C %20.1f °C\n", displayTime, HBM_current_temp, FPGA_current_temp);

        rawHBMTemperatureList.push_back(HBM_current_temp);
        rawFPGATemperatureList.push_back(FPGA_current_temp);

        temperatures << displayTime << "," << HBM_current_temp << "," << FPGA_current_temp << std::endl;

        if (i == 0)
        {
            FPGA_idle_temp = FPGA_current_temp;
            HBM_idle_temp = HBM_current_temp;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        timeMs += 500;
    }

    std::cout << std::fixed << std::setw(22) << std::setprecision(1);
    std::cout << std::endl
              << std::endl;

    send_start();

    for (int i = 0; i < poll_cycles; ++i)
    {
        // Send command to the device
        displayTime = timeMs / 1000.0;
        HBM_current_temp = get_HBM_temperature(false);
        FPGA_current_temp = get_FPGA_temperature(false);

        // Output formatted temperatures
        printf("%22.1f -> %20.1d °C %20.1f °C\n", displayTime, HBM_current_temp, FPGA_current_temp);

        rawHBMTemperatureList.push_back(HBM_current_temp);
        rawFPGATemperatureList.push_back(FPGA_current_temp);

        temperatures << displayTime << "," << HBM_current_temp << "," << FPGA_current_temp << std::endl;

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        timeMs += 500;

        if (i == (poll_cycles - 1))
        {
            FPGA_final_temp = FPGA_current_temp;
            HBM_final_temp = HBM_current_temp;
        }
    }

    std::cout << std::endl;

    std::ofstream dataSummary;
    dataSummary.open("data_summary_" + suffix + ".txt");

    std::cout << "FPGA Idle Temp:  " << FPGA_idle_temp << " °C" << std::endl;
    std::cout << "FPGA Final Temp: " << FPGA_final_temp << " °C" << std::endl;
    std::cout << "FPGA Difference: " << FPGA_final_temp - FPGA_idle_temp << " °C" << std::endl
              << std::endl;

    dataSummary << "FGPA Idle Temp:  " << FPGA_idle_temp << " °C" << std::endl;
    dataSummary << "FPGA Final Temp: " << FPGA_final_temp << " °C" << std::endl;
    dataSummary << "FPGA Difference: " << FPGA_final_temp - FPGA_idle_temp << " °C" << std::endl
                << std::endl;

    std::cout << "HBM Idle Temp:  " << HBM_idle_temp << " °C" << std::endl;
    std::cout << "HBM Final Temp: " << HBM_final_temp << " °C" << std::endl;
    std::cout << "HBM Difference: " << HBM_final_temp - HBM_idle_temp << " °C" << std::endl
              << std::endl;

    dataSummary << "HBM Idle Temp:  " << HBM_idle_temp << " °C" << std::endl;
    dataSummary << "HBM Final Temp: " << HBM_final_temp << " °C" << std::endl;
    dataSummary << "HBM Difference: " << HBM_final_temp - HBM_idle_temp << " °C" << std::endl
                << std::endl;

    send_stop();

    temperatures.close();
}

unsigned char SerialPort::get_HBM_temperature(bool print_data)
{
    writeSerialPort("/"); // Poll HBM temp
    readSerialPort(false);
    if (print_data)
        printf("\tHBM temperature: %d°C\n", buffer[0]);
    return buffer[0];
}
double SerialPort::get_FPGA_temperature(bool print_data)
{
    writeSerialPort("."); // Poll FPTGA temp
    readSerialPort(false);
    int temperature = static_cast<unsigned char>(buffer[1]);
    temperature = temperature << 8;
    temperature |= static_cast<unsigned char>(buffer[0]);
    if (print_data)
        printf("\tFPGA temperature: %.2f°C\n", (((temperature * 509.3140064) / 65536.0) - 280.23087870));
    return (((temperature * 509.3140064) / 65536.0) - 280.23087870);
}