#include <iostream>
#include <string>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <chrono>
#include <thread>
#include <sstream>

// Yes, I did have chatGPT make the basic UART interface for me

// Function to open the serial port
int openSerialPort(const char *port)
{
    int fd = open(port, O_RDWR | O_NOCTTY | O_NDELAY);
    if (fd == -1)
    {
        perror("openSerialPort: Unable to open serial port");
        exit(EXIT_FAILURE);
    }
    return fd;
}

// Function to configure the serial port
void configureSerialPort(int fd, speed_t baudRate)
{
    struct termios options;
    tcgetattr(fd, &options);

    // Set baud rate
    cfsetispeed(&options, baudRate);
    cfsetospeed(&options, baudRate);

    // Enable receiver and set local mode
    options.c_cflag |= (CLOCAL | CREAD);

    // Set parity, data bits, and stop bits
    options.c_cflag |= PARENB;  // Enable parity
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

// Function to write data to the serial port
void writeSerialPort(int fd, const std::string &data)
{
    write(fd, data.c_str(), data.length());
}

// Function to read data from the serial port
std::string readSerialPort(int fd, bool printErrors = true)
{
    const int bufferSize = 128;
    char buffer[bufferSize];
    std::string data;

    int i = 0;
    bool status = true;
    while (status)
    {

        int bytesRead = read(fd, buffer, bufferSize - 1);
        if (bytesRead > 0)
        {
            buffer[bytesRead] = '\0';
            data = buffer;
            status = false;
        }
    }
    if (data != "A" && data != "B" && data != "C" && data != "D" && data != "E" && data != "F" && data != "G" &&
        data != "H" && data != "I" && data != "J" && printErrors)
    {
        std::cout << "Received unknown bytes: [" << data << "]" << std::endl;
    }
    return data;
}

std::string encodeInstruction(std::string input)
{
    if (input == "start")
    {
        return "0";
    }
    else if (input == "stop")
    {
        return "1";
    }
    else if (input == "write_set")
    {
        return "2";
    }
    else if (input == "read_set")
    {
        return "3";
    }
    else if (input == "rw_set")
    {
        return "4";
    }
    else if (input == "queued_read_set")
    {
        return "5";
    }
    else if (input == "queued_write_set")
    {
        return "6";
    }
    else if (input == "address_inc_set")
    {
        return "7";
    }
    else if (input == "address_static_set")
    {
        return "8";
    }
    else if (input == "reset_uart")
    {
        return "@";
    }
    else if (input == "port_select")
    {
        return "9";
    }
    else
    {
        if (input != "help")
        {
            std::cout << std::endl
                      << "Invalid Command!" << std::endl;
        }
        std::cout << "Commands:" << std::endl;
        std::cout << "\t help               - displays this list" << std::endl;
        std::cout << "\t start              - enables reading / writing test" << std::endl;
        std::cout << "\t stop               - halts reading / writing test" << std::endl;
        std::cout << "\t write_set          - sets port mode to write" << std::endl;
        std::cout << "\t read_set           - sets port mode to read" << std::endl;
        std::cout << "\t queued_write_set   - sets port mode to queued_write" << std::endl;
        std::cout << "\t queued_read_set    - sets port mode to queued_read" << std::endl;
        std::cout << "\t address_inc_set    - enables address incrementing" << std::endl;
        std::cout << "\t address_static_set - disables address incrementing" << std::endl;
        std::cout << "\t reset_uart         - resets the uart" << std::endl;
        std::cout << "\t port_select        - 32 bit hex number for which ports to enable" << std::endl;
        std::cout << "\t exit               - to exit" << std::endl;
        return "";
    }
}

std::string decodeResponse(std::string response)
{
    if (response == "A")
    {
        return "started test";
    }
    else if (response == "B")
    {
        return "stopped test";
    }
    else if (response == "C")
    {
        return "set mode to \"write\"";
    }
    else if (response == "D")
    {
        return "set mode to \"read\"";
    }
    else if (response == "E")
    {
        return "set mode to \"concurrent reads and writes\"";
    }
    else if (response == "F")
    {
        return "set mode to \"queued reads\"";
    }
    else if (response == "G")
    {
        return "set mode to \"queued write\"";
    }
    else if (response == "H")
    {
        return "Enabled address incrementing";
    }
    else if (response == "I")
    {
        return "Disabled address incrementing";
    }
    else if (response == "J")
    {
        return "Set ports";
    }
    else if (response == "?")
        return "[ERR] : ?";
    else
    {
        return "[ERR]";
    }
}

std::string hexToAscii(const std::string &hexString)
{
    std::stringstream ss;
    for (size_t i = 0; i < hexString.length(); i += 2)
    {
        std::string byteString = hexString.substr(i, 2);
        unsigned int byteValue;
        std::stringstream byteStream(byteString);
        byteStream >> std::hex >> byteValue;
        char asciiChar = static_cast<char>(byteValue);
        ss << asciiChar;
    }
    return ss.str();
}

int main()
{
    const char *serialPort = "/dev/ttyUSB2";
    speed_t baudRate = B19200;

    // Open the serial port
    int fd = openSerialPort(serialPort);

    // Configure the serial port
    configureSerialPort(fd, baudRate);
    std::string userInput;

    // Reset UART
    writeSerialPort(fd, "@\n");

    // Main loop

    while (true)
    {

        // Read user input
        std::cout << "\033[33mHBM "
                  << "\033[39m> ";
        std::getline(std::cin, userInput);

        // Check for exit condition
        if (userInput == "exit")
        {
            break;
        }

        std::string encodedInstruction = encodeInstruction(userInput);

        if (!encodedInstruction.empty())
        {
            if (encodedInstruction == "9") // Port Select
            {
                std::cout << "\t Enter 32 bit port selection as a hex number [8 digits]" << std::endl;
                std::cout << "\t 0x";

                std::string ports;
                std::getline(std::cin, ports);

                // hexToAscii() is necessary because writeSerialPort() accepts a string and converts it into ascii binary
                // If I were to put "F2" into writeSerialPort() it would write the asscii charater for F and 2 in binary
                // Instead of the intended "11110010"
                std::string asciiConversion = hexToAscii(ports);
                writeSerialPort(fd, encodedInstruction);

                writeSerialPort(fd, asciiConversion);

                // Read and display response
                std::string response = readSerialPort(fd);
                std::cout << " - " << decodeResponse(response) << std::endl
                          << std::endl;
            }
            else
            {
                // Send command to the device
                writeSerialPort(fd, encodedInstruction + "\n");

                if (encodedInstruction != "@") // UART reset. reset doesn't send a response
                {
                    // Read and display response
                    std::string response = readSerialPort(fd);
                    std::cout << " - " << decodeResponse(response) << std::endl
                              << std::endl;
                }
                else
                {
                    std::cout << std::endl;
                }
            }
        }
    }

    // Close the serial port
    close(fd);

    return 0;
}
