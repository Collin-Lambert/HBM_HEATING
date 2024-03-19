import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
plt.rcParams["figure.figsize"] = [10.50, 6.00]
plt.rcParams["figure.autolayout"] = True
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.ylim([20, 90])



SUFFIX = "HBM_+_RO_VALIDATION"

#Do Comparisons
columns = ["Time", "Temperature_HBM", "Temperature_FPGA"]
# df_325inc_raw = pd.read_csv("rawTemperatures325_inc_" + SUFFIX + ".csv", usecols=columns)
# df_325static_raw = pd.read_csv("rawTemperatures325_static_" + SUFFIX + ".csv", usecols=columns)
# df_450inc_raw = pd.read_csv("rawTemperatures450_inc_" + SUFFIX + ".csv", usecols=columns)
# df_450static_raw = pd.read_csv("rawTemperatures450_static_" + SUFFIX + ".csv", usecols=columns)
# df_550inc_raw = pd.read_csv("rawTemperatures550_inc_" + SUFFIX + ".csv", usecols=columns)
# df_550static_raw = pd.read_csv("rawTemperatures550_static_" + SUFFIX + ".csv", usecols=columns)
df_VALIDATION = pd.read_csv("raw_temperatures_" + SUFFIX + ".csv", usecols = columns)

# VALIDATION
plt.ylim(0, 60)
plt.ylabel("Temperature (℃)", fontsize = 20)
plt.xlabel("Time in Seconds", fontsize = 20)
plt.plot(df_VALIDATION.Time, df_VALIDATION.Temperature_HBM, color = "darkgoldenrod", label = "HBM")
plt.plot(df_VALIDATION.Time, df_VALIDATION.Temperature_FPGA, color = "darkslategrey", label = "FPGA")
plt.legend(fontsize = 15)
plt.title("VALIDATION", fontsize = 20)
plt.savefig("VALIDATION.png")
plt.close()


# plt.ylim([-35, 15])
# plt.ylabel("Degrees C")
# plt.xlabel("Time in Seconds")
# plt.plot(df_550inc_raw.Time, df_550inc_raw.Temperature_HBM, color = "darkcyan", label = "HBM_550_inc")
# plt.plot(df_550inc_raw.Time, df_550inc_raw.Temperature_FPGA, color = "cadetblue", label = "FPGA_550_inc")

# plt.plot(df_450inc_raw.Time, df_450inc_raw.Temperature_HBM, color = "darkgoldenrod", label = "HBM_450_inc")
# plt.plot(df_450inc_raw.Time, df_450inc_raw.Temperature_FPGA, color = "goldenrod", label = "FPGA_450_inc")

# plt.plot(df_325inc_raw.Time, df_325inc_raw.Temperature_HBM, color = "darkslategrey", label = "HBM_325_inc")
# plt.plot(df_325inc_raw.Time, df_325inc_raw.Temperature_FPGA, color = "slategrey", label = "FPGA_325_inc")


# plt.legend()
# plt.title(SUFFIX)
# plt.savefig(SUFFIX + '.png')
# plt.close()

# 550 standalone
plt.ylim(-40, 45)
plt.ylabel("Temperature (℃)", fontsize = 20)
plt.xlabel("Time in Seconds", fontsize = 20)
plt.plot(df_550inc_raw_RO_HBM_standalone.Time, df_550inc_raw_RO_HBM_standalone.Temperature_HBM, color = "darkgoldenrod", label = "HBM")
plt.plot(df_550inc_raw_RO_HBM_standalone.Time, df_550inc_raw_RO_HBM_standalone.Temperature_FPGA, color = "darkslategrey", label = "FPGA")
plt.legend(fontsize = 15)
plt.title("550 RO + HBM", fontsize = 20)
plt.savefig("550_inc_RO_+_HBM_STANDALONE.png")
plt.close()

