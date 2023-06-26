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
#include <vector>

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
        data != "H" && data != "I" && data != "J" && data != "L" && data != "K" && printErrors)
    {
        std::cout << "Received unknown bytes: [" << data << "]" << std::endl;
    }
    return data;
}

void PrintHelp()
{
    std::cout << "Commands:" << std::endl;
    std::cout << "\t help               - displays this list" << std::endl;
    std::cout << "\t start              - enables reading / writing test" << std::endl;
    std::cout << "\t stop               - halts reading / writing test" << std::endl
              << std::endl;
    std::cout << "\t write_set          - sets port mode to write" << std::endl;
    std::cout << "\t read_set           - sets port mode to read" << std::endl;
    std::cout << "\t queued_read_set    - enables queued reading" << std::endl;
    std::cout << "\t queued_write_set   - enables queued writing" << std::endl
              << std::endl;
    std::cout << "\t write / read / queued_write / queued_read support the following options:" << std::endl;
    std::cout << "\t\t -ports [port_select]                    - 32 bit hex number for which ports to enable" << std::endl;
    std::cout << "\t\t -mode [addressing_mode (inc or static)] - specifies whether to increment address or not" << std::endl;
    std::cout << "\t\t -length [transaction_length]            - 4 bit hex number for length of transaction" << std::endl
              << std::endl;
    std::cout << "\t address_inc_set        - enables address incrementing" << std::endl;
    std::cout << "\t address_static_set     - disables address incrementing" << std::endl;
    std::cout << "\t reset_uart             - resets the uart" << std::endl;
    std::cout << "\t port_select            - 32 bit hex number for which ports to enable" << std::endl;
    std::cout << "\t transaction_length_set - 4 bit hex number for length of transaction" << std::endl;
    std::cout << "\t exit                   - to exit" << std::endl;
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
    else if (input == "transaction_length_set")
    {
        return ":";
    }
    else
    {
        if (input != "help")
        {
            std::cout << std::endl
                      << "Invalid Command!" << std::endl;
        }
        PrintHelp();
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
    else if (response == "K")
    {
        return "Reset UART";
    }
    else if (response == "L")
    {
        return "Set transaction length";
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

void PortSelect(int fd, std::string ports = "")
{

    if (ports.empty())
    {
        std::cout << "\t Enter 32 bit port selection as a hex number [8 digits]" << std::endl;
        std::cout << "\t 0x";

        std::getline(std::cin, ports);
    }
    // hexToAscii() is necessary because writeSerialPort() accepts a string and converts it into ascii binary
    // If I were to put "F2" into writeSerialPort() it would write the asscii charater for F and 2 in binary
    // Instead of the intended "11110010"
    std::string asciiConversion = hexToAscii(ports);
    writeSerialPort(fd, "9");

    writeSerialPort(fd, asciiConversion);

    // Read and display response
    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;
}

void LengthSelect(int fd, std::string length = "")
{
    if (length.empty())
    {
        std::cout << "\t Enter 4 bit length selection as a hex number [1 digit]" << std::endl;
        std::cout << "\t 0x";

        std::getline(std::cin, length);
    }

    std::string asciiConversion = hexToAscii(length);
    writeSerialPort(fd, ":");

    writeSerialPort(fd, asciiConversion);

    // Read and display response
    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;
}

void AddressingMode(int fd, std::string mode)
{
    if (mode == "inc")
    {
        writeSerialPort(fd, "7");
    }
    else if (mode == "static")
    {
        writeSerialPort(fd, "8");
    }
    else
    {
        std::cout << std::endl
                  << "Invalid Command!" << std::endl;
        PrintHelp();
        return;
    }
    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;
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

    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    std::vector<std::string> args;

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

        args = ParseArgs(userInput);

        if (args[0] == "queued_read_set" || args[0] == "queued_write_set" || args[0] == "read_set" || args[0] == "write_set")
        {
            if (args[0] == "queued_read_set")
            {
                writeSerialPort(fd, "5");
            }
            else if (args[0] == "queued_write_set")
            {
                writeSerialPort(fd, "6");
            }
            else if (args[0] == "read_set")
            {
                writeSerialPort(fd, "3");
            }
            else if (args[0] == "write_set")
            {
                writeSerialPort(fd, "2");
            }

            std::string response = readSerialPort(fd);
            std::cout << " - " << decodeResponse(response) << std::endl
                      << std::endl;

            for (int i = 1; i < args.size(); ++i)
            {
                if (args[i] == "-ports")
                {
                    PortSelect(fd, args[i + 1]);
                    ++i;
                }
                else if (args[i] == "-mode")
                {
                    AddressingMode(fd, args[i + 1]);
                    ++i;
                }
                else if (args[i] == "-length")
                {
                    LengthSelect(fd, args[i + 1]);
                    ++i;
                }
                else
                {
                    std::cout << std::endl
                              << "Invalid Command!" << std::endl;
                    PrintHelp();
                }
            }
        }
        else
        {
            std::string encodedInstruction = encodeInstruction(args[0]);

            if (!encodedInstruction.empty())
            {
                if (encodedInstruction == "9") // Port Select
                {
                    PortSelect(fd);
                }
                else if (encodedInstruction == ":")
                {
                    LengthSelect(fd);
                }
                else
                {
                    // Send command to the device
                    writeSerialPort(fd, encodedInstruction + "\n");

                    // Read and display response
                    std::string response = readSerialPort(fd);
                    std::cout << " - " << decodeResponse(response) << std::endl
                              << std::endl;
                }
            }
        }
    }

    // Close the serial port
    close(fd);
}