#include <iostream>
#include <string>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <chrono>
#include <thread>

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
    if (data != "A" && data != "B" && data != "C" && data != "D" && data != "E" && data != "F" && data != "G" && printErrors)
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
    else
    {
        if (input != "help")
        {
            std::cout << std::endl
                      << "Invalid Command!" << std::endl;
        }
        std::cout << "Commands:" << std::endl;
        std::cout << "\t help      - displays this list" << std::endl;
        std::cout << "\t start     - enables reading / writing test" << std::endl;
        std::cout << "\t stop      - halts reading / writing test" << std::endl;
        std::cout << "\t write_set - sets port mode to write" << std::endl;
        std::cout << "\t read_set  - sets port mode to read" << std::endl;
        std::cout << "\t exit      - to exit" << std::endl;
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
        return "set mode to \"queued write\"";
    else if (response == "?")
        return "[ERR] : ?";
    else
    {
        return "[ERR]";
    }
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

    std::cout << "Do you want to run initialization? [y/n]: ";
    std::getline(std::cin, userInput);

    if (userInput == "y")
    {
        // Initialize
        std::cout << "Initializing" << std::flush;
        std::string loadingBar = "";
        std::string temp;

        // Do some interesting toggleing of start and stop.For some reason this makes the reads ramp up to their max speed.
        for (int i = 0; i < 12; ++i)
        {
            writeSerialPort(fd, "0\n");
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
            writeSerialPort(fd, "1\n");
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        }
        std::cout << std::endl
                  << "Initialization Complete." << std::endl
                  << std::endl;
        readSerialPort(fd, false);
    }

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
            // Send command to the device
            writeSerialPort(fd, encodedInstruction + "\n");

            // Read and display response
            std::string response = readSerialPort(fd);
            std::cout << " - " << decodeResponse(response) << std::endl
                      << std::endl;
        }
    }

    // Close the serial port
    close(fd);

    return 0;
}
