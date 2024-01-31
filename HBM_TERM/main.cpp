#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <chrono>
#include <thread>
#include <deque>
#include <vector>
#include <sstream>
#include <bitset>
#include <iomanip>
#include <cstdlib>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>

#define MINUTE_AMOUNT 120
#define ADDRESS_OFFSET 4

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

void configureSerialPort(int fd, speed_t baudRate)
{
    struct termios options;
    tcgetattr(fd, &options);

    // Set baud rate
    cfsetispeed(&options, baudRate);
    cfsetospeed(&options, baudRate);

    // Enable receiver and set local mode
    options.c_cflag |= (CLOCAL | CREAD);

    // Set parity, data bits, and stop bitsQuick Access
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

void writeSerialPort(int fd, const std::string &data)
{
    write(fd, data.c_str(), data.length());
}

// convert binary number string to hex string
std::string binaryToHex(const std::string &binary)
{
    if (binary.length() % 4 != 0)
    {
        std::cerr << "Invalid binary string. Length must be a multiple of 4." << std::endl;
        return "";
    }

    std::string hex;
    for (size_t i = 0; i < binary.length(); i += 4)
    {
        std::bitset<4> bits(binary.substr(i, 4));
        hex += static_cast<char>(bits.to_ulong() + (bits.to_ulong() > 9 ? 'A' - 10 : '0'));
    }

    return hex;
}

std::deque<std::string> readRawSerialPort(int fd)
{
    const int bufferSize = 256;
    char buffer[bufferSize];
    std::stringstream ss;
    std::bitset<8> bits;
    std::deque<std::string> throughput;

    int i = 0;
    bool status = true;

    while (status)
    {

        int bytesRead = read(fd, buffer, bufferSize - 1);
        if (bytesRead > 0)
        {
            buffer[bytesRead] = '\0';
            for (int i = 31; i >= 0; --i)
            {
                for (int j = 3; j >= 0; --j)
                {
                    bits = buffer[(i * 4) + j];
                    ss << std::hex << bits.to_string();
                }
                throughput.push_front(ss.str());
                // std::cout << ss.str() << std::endl;
                ss.clear();
                ss.str("");
            }
            status = false;
        }
    }
    return throughput;
}

// Function to read data from the serial port
std::string readSerialPort(int fd, bool printErrors = true)
{
    const int bufferSize = 256;
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
        data != "H" && data != "I" && data != "J" && data != "L" && data != "K" && data != "M" && data != "N" &&
        data != "O" && data != "P" && data != "Q" && data != "R" && printErrors)
    {
        for (int j = 0; j < data.length(); ++j)
        {
            std::cout << "Received unknown bytes: [" << static_cast<int>(data.at(j)) << "]" << std::endl;
        }
    }
    return data;
}

// Function to read data from the serial port
int readSerialPortBinary(int fd)
{
    const int bufferSize = 256;
    char buffer[bufferSize];

    int i = 0;
    bool status = true;
    int value;
    while (status)
    {

        int bytesRead = read(fd, buffer, bufferSize - 1);
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

void PrintHelp()
{
    std::cout << "Commands:" << std::endl;
    std::cout << "\t help               - displays this list" << std::endl;
    std::cout << "\t start              - enables reading / writing test" << std::endl;
    std::cout << "\t stop               - halts reading / writing test" << std::endl
              << std::endl;
    std::cout << "\t write_set          - enables writing" << std::endl;
    std::cout << "\t read_set           - enables reading" << std::endl;
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
    std::cout << "\t reset                  - resets" << std::endl;
    std::cout << "\t port_select            - 32 bit hex number for which ports to enable" << std::endl;
    std::cout << "\t transaction_length_set - 4 bit hex number for length of transaction" << std::endl
              << std::endl;
    std::cout << "\t clk_set_550  - set clock speed to 550 MHz" << std::endl;
    std::cout << "\t clk_set_450  - set clock speed to 450 MHz" << std::endl;
    std::cout << "\t clk_set_325  - set clock speed to 325 MHz" << std::endl
              << std::endl;
    std::cout << "\t sample             - sample data rate from each axi port" << std::endl;
    std::cout << "\t poll_temp          - get time stamped readout of HBM temps" << std::endl;
    std::cout << "\t poll_temp_once     - get current temperature" << std::endl;
    std::cout << "\t poll_fpga_temp_once - get current FPGA temperature" << std::endl;
    std::cout << "\t run_tests          - polls temp for all configurations" << std::endl
              << std::endl;
    std::cout << "\t load_defaults - initializes system with default settings" << std::endl
              << std::endl;
    std::cout << "\t exit - to exit" << std::endl;
}

void PrintROHelp()
{
    std::cout << "Commands:" << std::endl;
    std::cout << "\t help                - displays this list" << std::endl;
    std::cout << "\t start               - enables reading / writing test" << std::endl;
    std::cout << "\t stop                - halts reading / writing test" << std::endl;
    std::cout << "\t poll_temp           - get time stamped readout of HBM temps" << std::endl;
    std::cout << "\t poll_temp_once      - get current HBM temperature" << std::endl;
    std::cout << "\t poll_fpga_temp_once - get current FPGA temperature" << std::endl
              << std::endl;
    std::cout << "\t exit - to exit" << std::endl;
}

// Encode instruction to form that is readable by the UART
std::string encodeInstruction(std::string input, std::string mode = "HBM")
{
    if (mode == "HBM")
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
        else if (input == "reset")
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
        else if (input == "clk_set_550")
        {
            return "<";
        }
        else if (input == "clk_set_450")
        {
            return "=";
        }
        else if (input == "clk_set_325")
        {
            return ">";
        }
        else if (input == "poll_temp" || input == "poll_temp_once")
        {
            return "/";
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
    else
    {
        if (input == "start")
        {
            return "0";
        }
        else if (input == "stop")
        {
            return "1";
        }
        else if (input == "reset")
        {
            return "@";
        }
        else if (input == "poll_temp")
        {
            return "/";
        }
        else
        {
            if (input != "help")
            {
                std::cout << std::endl
                          << "Invalid Command!" << std::endl;
            }
            PrintROHelp();
            return "";
        }
    }
}

// Decode response from UART to something a little more readable
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
        return "Reset";
    }
    else if (response == "L")
    {
        return "Set transaction length";
    }
    else if (response == "M")
    {
        return "Sampling...";
    }
    else if (response == "N")
    {
        return "Setting Clock To 550MHz...";
    }
    else if (response == "O")
    {
        return "Setting Clock To 450MHz...";
    }
    else if (response == "P")
    {
        return "Setting Clock To 325MHz...";
    }
    else if (response == "Q")
    {
        return "Locked";
    }
    else if (response == "R")
    {
        return "RO mode enabled";
    }
    else if (response == "?")
        return "[ERROR : ?]";
    else
    {
        return "[ERROR : unkown response]";
    }
}

// Convert Hex String to Ascii String. This is necessary because of the way the WriteSerialPort() function works
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

long int hexToInt(const std::string &hex)
{
    long int value;
    std::stringstream ss;
    ss << std::hex << hex;
    ss >> value;
    return value;
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

    // std::this_thread::sleep_for(std::chrono::milliseconds(100));
    //  Read and display response
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

int StringToInt(std::string str)
{
    unsigned int output = 0;
    // std::cout << str << std::endl;
    for (int j = 0; j < str.length(); ++j)
    {
        // output += (j + 1) * static_cast<unsigned int>(str.at(j));
        output += static_cast<unsigned int>(str.at(j));
    }
    return output;
}

void PollTempOnce(int fd)
{
    std::string response;
    writeSerialPort(fd, "/"); // Poll
    response = readSerialPort(fd, false);
    std::cout << "\t" << StringToInt(response) << " °C" << std::endl;
}

void PollFPGATempOnce(int fd)
{
    writeSerialPort(fd, "."); // Poll
    int response = readSerialPortBinary(fd);
    std::cout << "\t" << (((response * 509.3140064) / 65536) - 280.23087870) << " °C" << std::endl;
}

void PollTemp(int fd, int poll_duration, std::string suffix = "")
{
    std::vector<double> rawTemperatureList;
    std::vector<double> rawFPGATemperatureList;
    std::ofstream temperatures;
    temperatures.open("rawTemperatures" + suffix + ".csv");
    temperatures << "Time,Temperature_HBM,Temperature_FPGA" << std::endl;

    double timeMs = -2000;
    double displayTime;
    double FPGAidleTemp;
    double FPGAfinalTemp;
    int HBMidleTemp;
    int HBMfinalTemp;
    std::string response;
    double FPGATempResponse;

    int poll_cycles = poll_duration * 2 + 1;

    if (suffix == "")
    {
        // Check FPGA temp

        writeSerialPort(fd, ".");
        temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
        std::cout << "\t Current FPGA Temp: " << temperature << " °C" << std::endl;

        while (temperature < -35)
        {
            writeSerialPort(fd, "."); // Poll
            temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
            std::cout << "\t Current FPGA Temp: " << temperature << " °C" << std::endl;
            std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        }
    }

    std::cout << std::endl
              << "Time Relative to Start  |  Temperature (°C) HBM  |  Temperature (°C) FPGA" << std::endl;

    // Pre Start
    for (int i = 0; i < 4; ++i)
    {
        // Send command to the device
        displayTime = timeMs / 1000.0;
        writeSerialPort(fd, "/"); // Poll
        response = readSerialPort(fd, false);
        writeSerialPort(fd, "."); // Poll FPGA temp
        FPGATempResponse = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
        printf("%22.1f -> %20.1d °C %20.1f °C\n", displayTime, StringToInt(response), FPGATempResponse);

        rawTemperatureList.push_back(StringToInt(response));
        rawFPGATemperatureList.push_back(FPGATempResponse);

        temperatures << displayTime << "," << StringToInt(response) << "," << FPGATempResponse << std::endl;

        if (i == 0)
        {
            FPGAidleTemp = FPGATempResponse;
            HBMidleTemp = StringToInt(response);
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        timeMs += 500;
    }

    std::cout << std::fixed << std::setw(22) << std::setprecision(1);
    std::cout << std::endl
              << "Start" << std::endl
              << std::endl;

    writeSerialPort(fd, "0"); // Start
    response = readSerialPort(fd, false);

    for (int i = 0; i < poll_cycles; ++i)
    {
        // Send command to the device
        displayTime = timeMs / 1000.0;
        writeSerialPort(fd, "/"); // Poll
        response = readSerialPort(fd, false);
        writeSerialPort(fd, "."); // Poll FPGA temp
        FPGATempResponse = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);

        // Output formatted temperatures
        printf("%22.1f -> %20.1d °C %20.1f °C\n", displayTime, StringToInt(response), FPGATempResponse);

        rawTemperatureList.push_back(StringToInt(response));
        rawFPGATemperatureList.push_back(FPGATempResponse);

        temperatures << displayTime << "," << StringToInt(response) << "," << FPGATempResponse << std::endl;

        std::this_thread::sleep_for(std::chrono::milliseconds(500));
        timeMs += 500;

        if (i == (poll_cycles - 1))
        {
            FPGAfinalTemp = FPGATempResponse;
            HBMfinalTemp = StringToInt(response);
        }
    }
    std::cout << std::endl;

    std::ofstream dataSummary;
    dataSummary.open("data_summary" + suffix + ".txt");

    std::cout << "FPGA Idle Temp:  " << FPGAidleTemp << " °C" << std::endl;
    std::cout << "FPGA Final Temp: " << FPGAfinalTemp << " °C" << std::endl;
    std::cout << "FPGA Difference: " << FPGAfinalTemp - FPGAidleTemp << " °C" << std::endl
              << std::endl;

    dataSummary << "FGPA Idle Temp:  " << FPGAidleTemp << " °C" << std::endl;
    dataSummary << "FPGA Final Temp: " << FPGAfinalTemp << " °C" << std::endl;
    dataSummary << "FPGA Difference: " << FPGAfinalTemp - FPGAidleTemp << " °C" << std::endl
                << std::endl;

    std::cout << "HBM Idle Temp:  " << HBMidleTemp << " °C" << std::endl;
    std::cout << "HBM Final Temp: " << HBMfinalTemp << " °C" << std::endl;
    std::cout << "HBM Difference: " << HBMfinalTemp - HBMidleTemp << " °C" << std::endl
              << std::endl;

    dataSummary << "HBM Idle Temp:  " << HBMidleTemp << " °C" << std::endl;
    dataSummary << "HBM Final Temp: " << HBMfinalTemp << " °C" << std::endl;
    dataSummary << "HBM Difference: " << HBMfinalTemp - HBMidleTemp << " °C" << std::endl
                << std::endl;

    writeSerialPort(fd, "1"); // Stop
    response = readSerialPort(fd, false);

    temperatures.close();

    // Report average degrees per minute and average degrees per second per minute

    int HBMdegreesPerMinute;
    int FPGAdegreesPerMinute;

    if (poll_duration >= 60)
    {
        int numCompleteMinutes = (poll_duration - (poll_duration % 60)) / 60;

        for (int i = 0; i < numCompleteMinutes; ++i)
        {
            HBMdegreesPerMinute = rawTemperatureList[((MINUTE_AMOUNT * (i + 1)) - 2 + ADDRESS_OFFSET)] - rawTemperatureList[((MINUTE_AMOUNT * i) + ADDRESS_OFFSET)];
            FPGAdegreesPerMinute = rawFPGATemperatureList[((MINUTE_AMOUNT * (i + 1)) - 2 + ADDRESS_OFFSET)] - rawFPGATemperatureList[((MINUTE_AMOUNT * i) + ADDRESS_OFFSET)];
            std::cout << std::fixed << std::setprecision(3) << "FPGA °C per Minute in Minute: " << i + 1 << "  ->  " << FPGAdegreesPerMinute << std::endl;
            std::cout << std::fixed << std::setprecision(3) << "FPGA °C per Second in Minute: " << i + 1 << "  ->  " << FPGAdegreesPerMinute / 60.0 << std::endl
                      << std::endl;

            dataSummary << std::fixed << std::setprecision(3) << "FPGA °C per Minute in Minute: " << i + 1 << "  ->  " << FPGAdegreesPerMinute << std::endl;
            dataSummary << std::fixed << std::setprecision(3) << "FPGA °C per Second in Minute: " << i + 1 << "  ->  " << FPGAdegreesPerMinute / 60.0 << std::endl
                        << std::endl;

            std::cout << std::fixed << std::setprecision(3) << "HBM °C per Minute in Minute: " << i + 1 << "  ->  " << HBMdegreesPerMinute << std::endl;
            std::cout << std::fixed << std::setprecision(3) << "HBM °C per Second in Minute: " << i + 1 << "  ->  " << HBMdegreesPerMinute / 60.0 << std::endl
                      << std::endl;

            dataSummary << std::fixed << std::setprecision(3) << "HBM °C per Minute in Minute: " << i + 1 << "  ->  " << HBMdegreesPerMinute << std::endl;
            dataSummary << std::fixed << std::setprecision(3) << "HBM °C per Second in Minute: " << i + 1 << "  ->  " << HBMdegreesPerMinute / 60.0 << std::endl
                        << std::endl;
        }
    }

    dataSummary.close();

    // Create Smoothed Temperature List

    // std::vector<double> smoothTemperatureList;
    // std::vector<double> smoothFPGATemperatureList;

    // // Used to keep track of where in rawTemperatureList changes occur
    // std::vector<int> changeIndicies;
    // std::vector<int> FPGAchangeIndicies;

    // // The following two push_backs are to prevent the idle temps from affecting the active temps during smoothing
    // changeIndicies.push_back(0);
    // changeIndicies.push_back(4);

    // FPGAchangeIndicies.push_back(0);
    // FPGAchangeIndicies.push_back(4);

    // int previousRawTemp = rawTemperatureList[5];
    // int currentRawTemp;

    // double previousFPGARawTemp = rawFPGATemperatureList[5];
    // double currentFPGARawTemp;

    // // Find all positive changes in rawTemperatureList and mark them
    // for (int i = 4; i < rawTemperatureList.size(); ++i)
    // {
    //     currentRawTemp = rawTemperatureList[i];
    //     if (currentRawTemp > previousRawTemp)
    //     {
    //         changeIndicies.push_back(i);
    //     }
    //     previousRawTemp = currentRawTemp;
    // }
    // changeIndicies.push_back(rawTemperatureList.size() - 1);

    // int previousChangeIndex = changeIndicies[0];
    // int currentChangeIndex;
    // int indexDiff;

    // double temperatureIncVal;

    // // Create Smooth Values inbetween changes, interpolate
    // for (int i = 1; i < changeIndicies.size(); ++i)
    // {
    //     currentChangeIndex = changeIndicies[i];
    //     indexDiff = currentChangeIndex - previousChangeIndex;
    //     temperatureIncVal = (rawTemperatureList[currentChangeIndex] - rawTemperatureList[previousChangeIndex]) / static_cast<double>(indexDiff);

    //     for (int j = 0; j < indexDiff; ++j)
    //     {
    //         smoothTemperatureList.push_back((rawTemperatureList[previousChangeIndex]) + (temperatureIncVal * j));
    //     }
    //     previousChangeIndex = currentChangeIndex;
    // }
    // // Add final raw tempurature to the smooth temperatures
    // smoothTemperatureList.push_back(rawTemperatureList[rawTemperatureList.size() - 1]);

    // // Now do it for the FPGA temperatures

    // // Find all positive changes in rawFPGATemperatureList and mark them
    // for (int i = 4; i < rawFPGATemperatureList.size(); ++i)
    // {
    //     currentFPGARawTemp = rawFPGATemperatureList[i];
    //     if (currentFPGARawTemp > previousFPGARawTemp)
    //     {
    //         FPGAchangeIndicies.push_back(i);
    //     }
    //     previousFPGARawTemp = currentFPGARawTemp;
    // }
    // FPGAchangeIndicies.push_back(rawFPGATemperatureList.size() - 1);

    // int previousFPGAChangeIndex = FPGAchangeIndicies[0];
    // int currentFPGAChangeIndex;
    // int FPGAindexDiff;

    // double FPGAtemperatureIncVal;

    // // Create Smooth Values inbetween changes, interpolate
    // for (int i = 1; i < FPGAchangeIndicies.size(); ++i)
    // {
    //     currentFPGAChangeIndex = FPGAchangeIndicies[i];
    //     FPGAindexDiff = currentFPGAChangeIndex - previousFPGAChangeIndex;
    //     FPGAtemperatureIncVal = (rawFPGATemperatureList[currentFPGAChangeIndex] - rawFPGATemperatureList[previousFPGAChangeIndex]) / static_cast<double>(FPGAindexDiff);

    //     for (int j = 0; j < FPGAindexDiff; ++j)
    //     {
    //         smoothFPGATemperatureList.push_back((rawFPGATemperatureList[previousFPGAChangeIndex]) + (FPGAtemperatureIncVal * j));
    //     }
    //     previousFPGAChangeIndex = currentFPGAChangeIndex;
    // }
    // // Add final raw tempurature to the smooth temperatures
    // smoothFPGATemperatureList.push_back(rawFPGATemperatureList[rawFPGATemperatureList.size() - 1]);

    // // Create smoothTemperatures.csv
    // std::ofstream smoothTemperaturesCsv;
    // smoothTemperaturesCsv.open("smoothTemperatures" + suffix + ".csv");
    // smoothTemperaturesCsv << "Time,Temperature_HBM,Temperature_FPGA" << std::endl;

    // double listedTime = -2.0;

    // for (int i = 0; i < smoothTemperatureList.size(); ++i)
    // {
    //     smoothTemperaturesCsv << listedTime << "," << smoothTemperatureList[i] << "," << smoothFPGATemperatureList[i] << std::endl;
    //     listedTime += 0.5;
    // }
    // smoothTemperaturesCsv.close();

    // Create Rate of Change List

    // std::vector<double> rocList;

    // double rocPreviousTemp = smoothTemperatureList[0];
    // double rocCurrentTemp;
    // for (int i = 1; i < smoothTemperatureList.size(); ++i)
    // {
    //     rocCurrentTemp = smoothTemperatureList[i];
    //     rocList.push_back(((rocCurrentTemp - rocPreviousTemp) / 0.5));
    //     rocPreviousTemp = rocCurrentTemp;
    // }

    // // Create smoothTemperaturesRate.csv

    // std::ofstream smoothTemperaturesRate;
    // smoothTemperaturesRate.open("smoothTemperaturesRate" + suffix + ".csv");
    // smoothTemperaturesRate << "Time,Rate" << std::endl;

    // listedTime = -2.0;
    // for (int i = 0; i < rocList.size(); ++i)
    // {
    //     smoothTemperaturesRate << listedTime << "," << rocList[i] << std::endl;
    //     listedTime += 0.5;
    // }

    // smoothTemperaturesRate.close();
}

void Sample(int fd)
{
    writeSerialPort(fd, ";");

    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
    std::deque<std::string> throughput = readRawSerialPort(fd);
    std::string hexConversion;
    long int decimalConversion;
    double throughputCalc;
    double totalThroughput = 0;
    double stack1Throughput = 0;
    double stack2Throughput = 0;

    std::cout << "AXI port  |  Transactions (0x)  |  Transactions (0d) |  Throughput" << std::endl;

    for (int i = 0; i < throughput.size(); ++i)
    {
        hexConversion = binaryToHex(throughput[i]);
        decimalConversion = hexToInt(hexConversion);
        throughputCalc = (decimalConversion * 32.0 * 16.0 * 1000) / (1000000000.0);
        std::cout << std::fixed << std::setw(13) << std::left << i
                  << std::setw(17) << hexConversion << " ->  "
                  << std::setw(16) << decimalConversion << " ->  "
                  << std::setw(7) << std::setprecision(2) << throughputCalc << " GB/s" << std::endl;

        totalThroughput += throughputCalc;

        if (i < 16)
        {
            stack1Throughput += throughputCalc;
        }
        else
        {
            stack2Throughput += throughputCalc;
        }
    }
    std::cout << std::endl
              << "Stack 1 Throughput -> " << stack1Throughput << " GB/s" << std::endl
              << "Stack 2 Throughput -> " << stack2Throughput << " GB/s" << std::endl
              << std::endl
              << "Total Throughput -> " << totalThroughput << " GB/s" << std::endl
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

void LoadDefaults(int fd)
{
    // queued_read_set
    writeSerialPort(fd, "5");

    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    // port_select
    PortSelect(fd, "FFFFFFFF");

    // address_inc_set
    AddressingMode(fd, "inc");

    // clk_set_550
    // writeSerialPort(fd, "<");

    // Read and display response
    // response = readSerialPort(fd);
    // std::cout << " - " << decodeResponse(response) << std::endl
    //           << std::endl;
}

void Cooldown(int fd)
{
    std::string temperatureString;
    double temperature;
    writeSerialPort(fd, "/"); // Poll
    temperatureString = readSerialPort(fd, false);
    temperature = StringToInt(temperatureString);

    std::cout << std::endl
              << "Cooling Down..." << std::endl
              << std::endl;

    // Check HBM temp

    while (temperature > 0)
    {
        writeSerialPort(fd, "/"); // Poll
        temperatureString = readSerialPort(fd, false);
        temperature = StringToInt(temperatureString);
        std::cout << "\t Current HBM Temp: " << temperature << " °C" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(20000));
    }

    writeSerialPort(fd, "/"); // Poll
    temperatureString = readSerialPort(fd, false);
    temperature = StringToInt(temperatureString);

    std::cout << std::endl
              << "Verifying HBM Cooldown..." << std::endl;

    while (temperature > 0)
    {
        writeSerialPort(fd, "/"); // Poll
        temperatureString = readSerialPort(fd, false);
        temperature = StringToInt(temperatureString);
        std::cout << "\t Current HBM Temp: " << temperature << " °C" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(10000));
    }

    // Check FPGA temp

    writeSerialPort(fd, ".");
    temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
    std::cout << "\t Current FPGA Temp: " << temperature << " °C" << std::endl;

    // Check HBM temp

    while (temperature > -30)
    {
        writeSerialPort(fd, "."); // Poll
        temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
        std::cout << "\t Current FPGA Temp: " << temperature << " °C" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(20000));
    }

    writeSerialPort(fd, "."); // Poll
    temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);

    std::cout << std::endl
              << "Verifying FPGA Cooldown..." << std::endl;

    while (temperature > -30)
    {
        writeSerialPort(fd, "."); // Poll
        temperature = (((readSerialPortBinary(fd) * 509.3140064) / 65536) - 280.23087870);
        std::cout << "\t Current FPGA Temp: " << temperature << " °C" << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(10000));
    }

    std::cout << std::endl
              << "Cooldown Complete" << std::endl
              << std::endl;
}

void RunTests(int fd)
{
    std::string clkRate;
    std::string addressingMode;
    std::string configuration;
    std::string testNum;
    std::string suffix;
    int pollDuration = 300;

    std::cout << "Test Configuration [HBM, RO, RO_+_HBM]: ";
    std::getline(std::cin, configuration);

    std::cout << "Test Number: ";
    std::getline(std::cin, testNum);

    std::cout << "Starting Tests..." << std::endl
              << std::endl;

    // Initialize
    //  queued_read_set
    writeSerialPort(fd, "5");

    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    // port_select
    PortSelect(fd, "FFFFFFFF");

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 325 inc
    std::cout << "Starting Test: 325 MHz, INC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "inc");

    // clk_set_325
    writeSerialPort(fd, ">");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "325_inc_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 325 static
    std::cout << "Starting Test: 325 MHz, STATIC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "static");

    // clk_set_325
    writeSerialPort(fd, ">");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "325_static_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 450 inc
    std::cout << "Starting Test: 450 MHz, INC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "inc");

    // clk_set_450
    writeSerialPort(fd, "=");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "450_inc_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 450 static
    std::cout << "Starting Test: 450 MHz, STATIC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "static");

    // clk_set_450
    writeSerialPort(fd, "=");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "450_static_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 550 inc
    std::cout << "Starting Test: 550 MHz, INC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "inc");

    // clk_set_550
    writeSerialPort(fd, "<");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "550_inc_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    Cooldown(fd);

    //-----------------------------------------------------------------------
    // TEST: 550 static
    std::cout << "Starting Test: 550 MHz, STATIC" << std::endl
              << std::endl;

    // address_inc_set
    AddressingMode(fd, "static");

    // clk_set_550
    writeSerialPort(fd, "<");

    // Read and display response
    response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    suffix = "550_static_" + configuration + "_" + testNum;
    PollTemp(fd, pollDuration, suffix);

    std::cout << std::endl
              << "Tests Complete." << std::endl
              << std::endl;
}

int main()
{
    const char *serialPort = "/dev/ttyUSB1"; // 4 for other port. 2 for main
    speed_t baudRate = B19200;

    std::string mode = "HBM";

    // Open the serial port
    int fd = openSerialPort(serialPort);

    // Configure the serial port
    configureSerialPort(fd, baudRate);
    std::string userInput;

    // Reset
    writeSerialPort(fd, "@");

    std::string response = readSerialPort(fd);
    std::cout << " - " << decodeResponse(response) << std::endl
              << std::endl;

    if (decodeResponse(response) == "RO mode enabled")
    {
        mode = "RO";
    }

    std::vector<std::string> args;

    // Main loop
    while (true)
    {
        // Read user input
        if (mode == "HBM") // HBM heater
        {

            std::cout << "\033[33mHBM "
                      << "\033[39m> ";
        }
        else // Ring oscillator heater
        {
            std::cout << "\033[33mRO "
                      << "\033[39m> ";
        }
        std::getline(std::cin, userInput);

        // Check for exit condition
        if (userInput == "exit")
        {
            break;
        }

        args = ParseArgs(userInput);
        if (mode == "HBM")
        {
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
            else if (args[0] == "sample")
            {
                Sample(fd);
            }
            else if (args[0] == "clk_set_550" || args[0] == "clk_set_450" || args[0] == "clk_set_325")
            {
                std::string encodedInstruction = encodeInstruction(args[0]);

                // Send command to the device
                writeSerialPort(fd, encodedInstruction);

                // Read and display response
                std::string response = readSerialPort(fd);
                std::cout << " - " << decodeResponse(response) << std::endl
                          << std::endl;
            }
            else if (args[0] == "poll_temp")
            {
                std::string poll_duration;
                std::cout << "Poll Duration in seconds: ";
                std::getline(std::cin, poll_duration);

                PollTemp(fd, stoi(poll_duration));
            }
            else if (args[0] == "poll_temp_once")
            {
                PollTempOnce(fd);
            }
            else if (args[0] == "poll_fpga_temp_once")
            {
                PollFPGATempOnce(fd);
            }
            else if (args[0] == "load_defaults")
            {
                LoadDefaults(fd);
            }
            else if (args[0] == "run_tests")
            {
                RunTests(fd);
            }
            else
            {
                std::string encodedInstruction = encodeInstruction(args[0], mode);

                if (!encodedInstruction.empty())
                {
                    if (encodedInstruction == "9" && mode == "HBM") // Port Select
                    {
                        PortSelect(fd);
                    }
                    else if (encodedInstruction == ":" && mode == "HBM") // Length Select
                    {
                        LengthSelect(fd);
                    }
                    else
                    {
                        // Send command to the device
                        writeSerialPort(fd, encodedInstruction);

                        // Read and display response
                        std::string response = readSerialPort(fd);
                        std::cout << " - " << decodeResponse(response) << std::endl
                                  << std::endl;
                    }
                }
            }
        }
        else if (args[0] == "poll_temp")
        {
            std::string poll_duration;
            std::cout << "Poll Duration in seconds: ";
            std::getline(std::cin, poll_duration);

            PollTemp(fd, stoi(poll_duration));
        }
        else if (args[0] == "poll_temp_once")
        {
            PollTempOnce(fd);
        }
        else if (args[0] == "poll_fpga_temp_once")
        {
            PollFPGATempOnce(fd);
        }
        else
        {
            std::string encodedInstruction = encodeInstruction(args[0], mode);

            if (!encodedInstruction.empty())
            {
                if (encodedInstruction == "9" && mode == "HBM") // Port Select
                {
                    PortSelect(fd);
                }
                else if (encodedInstruction == ":" && mode == "HBM") // Length Select
                {
                    LengthSelect(fd);
                }
                else
                {
                    // Send command to the device
                    writeSerialPort(fd, encodedInstruction);

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