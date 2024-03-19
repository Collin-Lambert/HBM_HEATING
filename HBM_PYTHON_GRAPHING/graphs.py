import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
plt.rcParams["figure.figsize"] = [10.50, 6.00]
plt.rcParams["figure.autolayout"] = True
#columns = ["Time", "Temperature"]
#columns_1 = ["Time", "Temperature"]
#columns_2 = ["Time", "Rate"]
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.ylim([20, 90])


# df = pd.read_csv("rawTemperatures.csv", usecols=columns)
# df_1 = pd.read_csv("smoothTemperatures.csv", usecols=columns_1)
# df_2 = pd.read_csv("smoothTemperaturesRate.csv", usecols=columns_2)

# temperatures = df["Temperature"]
# time = df["Time"]

# plt.ylim([30, 90])
# plt.ylabel("Degrees C")
# plt.xlabel("Time in Seconds")
# plt.plot(df.Time, df.Temperature, color = "darkolivegreen")
# plt.plot(df_1.Time, df_1.Temperature, color = "darkgoldenrod")
# plt.show()

# plt.ylim([30, 90])
# plt.ylabel("Degrees C")
# plt.xlabel("Time in Seconds")
# plt.plot(df_1.Time, df_1.Temperature, color = "darkgoldenrod")
# plt.plot(df_2.Time, df_2.Rate, color = "darkslategray")
# plt.show()

# plt.ylim([0, 30])
# plt.ylabel("Degrees C")
# plt.xlabel("Time in Seconds")
# plt.plot(df_2.Time, df_2.Rate, color = "darkslategray")
# plt.show()

# plt.ylim([0, 90])
# plt.ylabel("Degrees C")
# plt.xlabel("Time in Seconds")
# plt.plot(df.Time, df.Temperature, color = "darkolivegreen")
# plt.show()

SUFFIX = "RO_+_HBM_FK_FREEZER_0"

#Do Comparisons
columns = ["Time", "Temperature_HBM", "Temperature_FPGA"]
df_325inc_raw = pd.read_csv("rawTemperatures325_inc_" + SUFFIX + ".csv", usecols=columns)
df_325static_raw = pd.read_csv("rawTemperatures325_static_" + SUFFIX + ".csv", usecols=columns)
df_450inc_raw = pd.read_csv("rawTemperatures450_inc_" + SUFFIX + ".csv", usecols=columns)
df_450static_raw = pd.read_csv("rawTemperatures450_static_" + SUFFIX + ".csv", usecols=columns)
df_550inc_raw = pd.read_csv("rawTemperatures550_inc_" + SUFFIX + ".csv", usecols=columns)
df_550static_raw = pd.read_csv("rawTemperatures550_static_" + SUFFIX + ".csv", usecols=columns)

df_325inc_smooth = pd.read_csv("smoothTemperatures325_inc_" + SUFFIX + ".csv", usecols=columns)
df_325static_smooth = pd.read_csv("smoothTemperatures325_static_" + SUFFIX + ".csv", usecols=columns)
df_450inc_smooth = pd.read_csv("smoothTemperatures450_inc_" + SUFFIX + ".csv", usecols=columns)
df_450static_smooth = pd.read_csv("smoothTemperatures450_static_" + SUFFIX + ".csv", usecols=columns)
df_550inc_smooth = pd.read_csv("smoothTemperatures550_inc_" + SUFFIX + ".csv", usecols=columns)
df_550static_smooth = pd.read_csv("smoothTemperatures550_static_" + SUFFIX + ".csv", usecols=columns)

df_550inc_raw_RO_HBM_standalone = pd.read_csv("rawTemperatures550_inc_RO_+_HBM_FK_FREEZER_STANDALONE.csv", usecols=columns)
df_550inc_raw_HBM_standalone = pd.read_csv("rawTemperatures550_inc_HBM_FK_FREEZER_STANDALONE.csv", usecols=columns)
df_450inc_raw_RO_HBM_standalone = pd.read_csv("rawTemperatures450_inc_RO_+_HBM_FK_FREEZER_STANDALONE.csv", usecols=columns)
df_450inc_raw_RO_HBM_standalone_2 = pd.read_csv("rawTemperatures450_inc_RO_+_HBM_FK_FREEZER_STANDALONE_2.csv", usecols=columns)
df_450inc_raw_RO_HBM_FK_1 = pd.read_csv("rawTemperatures450_inc_RO_+_HBM_FK_1.csv", usecols=columns)

plt.ylim([-35, 15])
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.plot(df_550inc_raw.Time, df_550inc_raw.Temperature_HBM, color = "darkcyan", label = "HBM_550_inc")
plt.plot(df_550inc_raw.Time, df_550inc_raw.Temperature_FPGA, color = "cadetblue", label = "FPGA_550_inc")
#plt.plot(df_550static_raw.Time, df_550static_raw.Temperature_HBM, color = "olivedrab", label = "HBM_550_static_raw")
#plt.plot(df_550static_raw.Time, df_550static_raw.Temperature_FPGA, color = "yellowgreen", label = "FPGA_550_static_raw")

plt.plot(df_450inc_raw.Time, df_450inc_raw.Temperature_HBM, color = "darkgoldenrod", label = "HBM_450_inc")
plt.plot(df_450inc_raw.Time, df_450inc_raw.Temperature_FPGA, color = "goldenrod", label = "FPGA_450_inc")
#plt.plot(df_450static_raw.Time, df_450static_raw.Temperature_HBM, color = "gold", label = "HBM_450_static_raw")
#plt.plot(df_450static_raw.Time, df_450static_raw.Temperature_FPGA, color = "khaki", label = "FPGA_450_static_raw")

plt.plot(df_325inc_raw.Time, df_325inc_raw.Temperature_HBM, color = "darkslategrey", label = "HBM_325_inc")
plt.plot(df_325inc_raw.Time, df_325inc_raw.Temperature_FPGA, color = "slategrey", label = "FPGA_325_inc")
#plt.plot(df_325static_raw.Time, df_325static_raw.Temperature_HBM, color = "silver", label = "HBM_325_static_raw")
#plt.plot(df_325static_raw.Time, df_325static_raw.Temperature_FPGA, color = "gainsboro", label = "FPGA_325_static_raw")


plt.legend()
plt.title(SUFFIX)
plt.savefig(SUFFIX + '.png')
plt.close()

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

plt.ylim(-40, 45)
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.plot(df_550inc_raw_HBM_standalone.Time, df_550inc_raw_HBM_standalone.Temperature_HBM, color = "darkgoldenrod", label = "HBM_550_inc_HBM_standalone")
plt.plot(df_550inc_raw_HBM_standalone.Time, df_550inc_raw_HBM_standalone.Temperature_FPGA, color = "darkslategrey", label = "FPGA_550_inc_HBM_standalone")
plt.legend()
plt.title("550_inc_HBM_STANDALONE")
plt.savefig("550_inc_HBM_STANDALONE.png")
plt.close()

# 450 standalone
plt.ylim(-40, 45)
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.plot(df_450inc_raw_RO_HBM_standalone.Time, df_450inc_raw_RO_HBM_standalone.Temperature_HBM, color = "darkgoldenrod", label = "HBM_450_inc_RO_HBM_standalone")
plt.plot(df_450inc_raw_RO_HBM_standalone.Time, df_450inc_raw_RO_HBM_standalone.Temperature_FPGA, color = "darkslategrey", label = "FPGA_450_inc_RO_HBM_standalone")
plt.legend()
plt.title("450_inc_RO_+_HBM_STANDALONE")
plt.savefig("450_inc_RO_+_HBM_STANDALONE.png")
plt.close()

# 450 w 550 standalone
plt.ylim(-40, 45)
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.plot(df_450inc_raw_RO_HBM_standalone.Time, df_450inc_raw_RO_HBM_standalone.Temperature_HBM, color = "darkgoldenrod", label = "HBM_450_inc_RO_HBM_standalone")
plt.plot(df_450inc_raw_RO_HBM_standalone.Time, df_450inc_raw_RO_HBM_standalone.Temperature_FPGA, color = "goldenrod", label = "FPGA_450_inc_RO_HBM_standalone")
plt.plot(df_550inc_raw_RO_HBM_standalone.Time, df_550inc_raw_RO_HBM_standalone.Temperature_HBM, color = "darkslategrey", label = "HBM_550_inc_RO_HBM_standalone")
plt.plot(df_550inc_raw_RO_HBM_standalone.Time, df_550inc_raw_RO_HBM_standalone.Temperature_FPGA, color = "slategrey", label = "FPGA_550_inc_RO_HBM_standalone")
plt.plot(df_450inc_raw_RO_HBM_standalone_2.Time, df_450inc_raw_RO_HBM_standalone_2.Temperature_HBM, color = "darkcyan", label = "HBM_450_inc_RO_HBM_standalone_2")
plt.plot(df_450inc_raw_RO_HBM_standalone_2.Time, df_450inc_raw_RO_HBM_standalone_2.Temperature_FPGA, color = "cadetblue", label = "FPGA_450_inc_RO_HBM_standalone_2")

plt.legend()
plt.title("450_W_550_inc_RO_+_HBM_STANDALONE")
plt.savefig("450_W_550_inc_RO_+_HBM_STANDALONE.png")
plt.close()

# 450 FK1
plt.ylim(-40, 45)
plt.ylabel("Degrees C")
plt.xlabel("Time in Seconds")
plt.plot(df_450inc_raw_RO_HBM_FK_1.Time, df_450inc_raw_RO_HBM_FK_1.Temperature_HBM, color = "darkgoldenrod", label = "HBM_450_inc_RO_HBM_FK_1")
plt.plot(df_450inc_raw_RO_HBM_FK_1.Time, df_450inc_raw_RO_HBM_FK_1.Temperature_FPGA, color = "darkslategrey", label = "FPGA_450_inc_RO_HBM_FK_1")
plt.legend()
plt.title("450_inc_RO_+_HBM_FK_1")
plt.savefig("450_inc_RO_+_HBM_FK_1.png")
plt.close()

# if (0):
#     # RO + HBM

#     df_325inc_RO_HBM = pd.read_csv("rawTemperatures325_inc_RO_+_HBM.csv", usecols=columns)
#     df_325static_RO_HBM = pd.read_csv("rawTemperatures325_static_RO_+_HBM.csv", usecols=columns)
#     df_450inc_RO_HBM = pd.read_csv("rawTemperatures450_inc_RO_+_HBM.csv", usecols=columns)
#     df_450static_RO_HBM = pd.read_csv("rawTemperatures450_static_RO_+_HBM.csv", usecols=columns)
#     df_650inc_RO_HBM = pd.read_csv("rawTemperatures650_inc_RO_+_HBM.csv", usecols=columns)
#     df_650static_RO_HBM = pd.read_csv("rawTemperatures650_static_RO_+_HBM.csv", usecols=columns)

#     df_smooth325inc_RO_HBM = pd.read_csv("smoothTemperatures325_inc_RO_+_HBM.csv", usecols=columns_1)
#     df_smooth325static_RO_HBM = pd.read_csv("smoothTemperatures325_static_RO_+_HBM.csv", usecols=columns_1)
#     df_smooth450inc_RO_HBM = pd.read_csv("smoothTemperatures450_inc_RO_+_HBM.csv", usecols=columns_1)
#     df_smooth450static_RO_HBM = pd.read_csv("smoothTemperatures450_static_RO_+_HBM.csv", usecols=columns_1)
#     df_smooth650inc_RO_HBM = pd.read_csv("smoothTemperatures650_inc_RO_+_HBM.csv", usecols=columns_1)
#     df_smooth650static_RO_HBM = pd.read_csv("smoothTemperatures650_static_RO_+_HBM.csv", usecols=columns_1)

#     df_rate325inc_RO_HBM = pd.read_csv("smoothTemperaturesRate325_inc_RO_+_HBM.csv", usecols=columns_2)
#     df_rate325static_RO_HBM = pd.read_csv("smoothTemperaturesRate325_static_RO_+_HBM.csv", usecols=columns_2)
#     df_rate450inc_RO_HBM = pd.read_csv("smoothTemperaturesRate450_inc_RO_+_HBM.csv", usecols=columns_2)
#     df_rate450static_RO_HBM = pd.read_csv("smoothTemperaturesRate450_static_RO_+_HBM.csv", usecols=columns_2)
#     df_rate650inc_RO_HBM = pd.read_csv("smoothTemperaturesRate650_inc_RO_+_HBM.csv", usecols=columns_2)
#     df_rate650static_RO_HBM = pd.read_csv("smoothTemperaturesRate650_static_RO_+_HBM.csv", usecols=columns_2)

#     # RO + HBM 2

#     df_325inc_RO_HBM_0 = pd.read_csv("rawTemperatures325_inc_RO_+_HBM_0.csv", usecols=columns)
#     df_325static_RO_HBM_0 = pd.read_csv("rawTemperatures325_static_RO_+_HBM_0.csv", usecols=columns)
#     df_450inc_RO_HBM_0 = pd.read_csv("rawTemperatures450_inc_RO_+_HBM_0.csv", usecols=columns)
#     df_450static_RO_HBM_0 = pd.read_csv("rawTemperatures450_static_RO_+_HBM_0.csv", usecols=columns)
#     df_650inc_RO_HBM_0 = pd.read_csv("rawTemperatures650_inc_RO_+_HBM_0.csv", usecols=columns)
#     df_650static_RO_HBM_0 = pd.read_csv("rawTemperatures650_static_RO_+_HBM_0.csv", usecols=columns)

#     df_smooth325inc_RO_HBM_0 = pd.read_csv("smoothTemperatures325_inc_RO_+_HBM_0.csv", usecols=columns_1)
#     df_smooth325static_RO_HBM_0 = pd.read_csv("smoothTemperatures325_static_RO_+_HBM_0.csv", usecols=columns_1)
#     df_smooth450inc_RO_HBM_0 = pd.read_csv("smoothTemperatures450_inc_RO_+_HBM_0.csv", usecols=columns_1)
#     df_smooth450static_RO_HBM_0 = pd.read_csv("smoothTemperatures450_static_RO_+_HBM_0.csv", usecols=columns_1)
#     df_smooth650inc_RO_HBM_0 = pd.read_csv("smoothTemperatures650_inc_RO_+_HBM_0.csv", usecols=columns_1)
#     df_smooth650static_RO_HBM_0 = pd.read_csv("smoothTemperatures650_static_RO_+_HBM_0.csv", usecols=columns_1)

#     df_rate325inc_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate325_inc_RO_+_HBM_0.csv", usecols=columns_2)
#     df_rate325static_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate325_static_RO_+_HBM_0.csv", usecols=columns_2)
#     df_rate450inc_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate450_inc_RO_+_HBM_0.csv", usecols=columns_2)
#     df_rate450static_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate450_static_RO_+_HBM_0.csv", usecols=columns_2)
#     df_rate650inc_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate650_inc_RO_+_HBM_0.csv", usecols=columns_2)
#     df_rate650static_RO_HBM_0 = pd.read_csv("smoothTemperaturesRate650_static_RO_+_HBM_0.csv", usecols=columns_2)



#     # HBM ONLY

#     df_325inc_hbm = pd.read_csv("rawTemperatures325_inc_hbm.csv", usecols=columns)
#     df_325static_hbm = pd.read_csv("rawTemperatures325_static_hbm.csv", usecols=columns)
#     df_450inc_hbm = pd.read_csv("rawTemperatures450_inc_hbm.csv", usecols=columns)
#     df_450static_hbm = pd.read_csv("rawTemperatures450_static_hbm.csv", usecols=columns)
#     df_650inc_hbm = pd.read_csv("rawTemperatures650_inc_hbm.csv", usecols=columns)
#     df_650static_hbm = pd.read_csv("rawTemperatures650_static_hbm.csv", usecols=columns)

#     df_smooth325inc_hbm = pd.read_csv("smoothTemperatures325_inc_hbm.csv", usecols=columns_1)
#     df_smooth325static_hbm = pd.read_csv("smoothTemperatures325_static_hbm.csv", usecols=columns_1)
#     df_smooth450inc_hbm = pd.read_csv("smoothTemperatures450_inc_hbm.csv", usecols=columns_1)
#     df_smooth450static_hbm = pd.read_csv("smoothTemperatures450_static_hbm.csv", usecols=columns_1)
#     df_smooth650inc_hbm = pd.read_csv("smoothTemperatures650_inc_hbm.csv", usecols=columns_1)
#     df_smooth650static_hbm = pd.read_csv("smoothTemperatures650_static_hbm.csv", usecols=columns_1)

#     df_rate325inc_hbm = pd.read_csv("smoothTemperaturesRate325_inc_hbm.csv", usecols=columns_2)
#     df_rate325static_hbm = pd.read_csv("smoothTemperaturesRate325_static_hbm.csv", usecols=columns_2)
#     df_rate450inc_hbm = pd.read_csv("smoothTemperaturesRate450_inc_hbm.csv", usecols=columns_2)
#     df_rate450static_hbm = pd.read_csv("smoothTemperaturesRate450_static_hbm.csv", usecols=columns_2)
#     df_rate650inc_hbm = pd.read_csv("smoothTemperaturesRate650_inc_hbm.csv", usecols=columns_2)
#     df_rate650static_hbm = pd.read_csv("smoothTemperaturesRate650_static_hbm.csv", usecols=columns_2)

#     # HBM ONLY 2

#     df_325inc_HBM_0 = pd.read_csv("rawTemperatures325_inc_HBM_0.csv", usecols=columns)
#     df_325static_HBM_0 = pd.read_csv("rawTemperatures325_static_HBM_0.csv", usecols=columns)
#     df_450inc_HBM_0 = pd.read_csv("rawTemperatures450_inc_HBM_0.csv", usecols=columns)
#     df_450static_HBM_0 = pd.read_csv("rawTemperatures450_static_HBM_0.csv", usecols=columns)
#     df_650inc_HBM_0 = pd.read_csv("rawTemperatures650_inc_HBM_0.csv", usecols=columns)
#     df_650static_HBM_0 = pd.read_csv("rawTemperatures650_static_HBM_0.csv", usecols=columns)

#     df_smooth325inc_HBM_0 = pd.read_csv("smoothTemperatures325_inc_HBM_0.csv", usecols=columns_1)
#     df_smooth325static_HBM_0 = pd.read_csv("smoothTemperatures325_static_HBM_0.csv", usecols=columns_1)
#     df_smooth450inc_HBM_0 = pd.read_csv("smoothTemperatures450_inc_HBM_0.csv", usecols=columns_1)
#     df_smooth450static_HBM_0 = pd.read_csv("smoothTemperatures450_static_HBM_0.csv", usecols=columns_1)
#     df_smooth650inc_HBM_0 = pd.read_csv("smoothTemperatures650_inc_HBM_0.csv", usecols=columns_1)
#     df_smooth650static_HBM_0 = pd.read_csv("smoothTemperatures650_static_HBM_0.csv", usecols=columns_1)

#     df_rate325inc_HBM_0 = pd.read_csv("smoothTemperaturesRate325_inc_HBM_0.csv", usecols=columns_2)
#     df_rate325static_HBM_0 = pd.read_csv("smoothTemperaturesRate325_static_HBM_0.csv", usecols=columns_2)
#     df_rate450inc_HBM_0 = pd.read_csv("smoothTemperaturesRate450_inc_HBM_0.csv", usecols=columns_2)
#     df_rate450static_HBM_0 = pd.read_csv("smoothTemperaturesRate450_static_HBM_0.csv", usecols=columns_2)
#     df_rate650inc_HBM_0 = pd.read_csv("smoothTemperaturesRate650_inc_HBM_0.csv", usecols=columns_2)
#     df_rate650static_HBM_0 = pd.read_csv("smoothTemperaturesRate650_static_HBM_0.csv", usecols=columns_2)



#     # RO + HBM GRAPHS

#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_650inc_RO_HBM.Time, df_650inc_RO_HBM.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_650static_RO_HBM.Time, df_650static_RO_HBM.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_450inc_RO_HBM.Time, df_450inc_RO_HBM.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_450static_RO_HBM.Time, df_450static_RO_HBM.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_325inc_RO_HBM.Time, df_325inc_RO_HBM.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_325static_RO_HBM.Time, df_325static_RO_HBM.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO RAW")
#     plt.savefig('HBM_+_RO_RAW.png')
#     plt.show()
#     plt.close()


#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_smooth650inc_RO_HBM.Time, df_smooth650inc_RO_HBM.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_smooth650static_RO_HBM.Time, df_smooth650static_RO_HBM.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_smooth450inc_RO_HBM.Time, df_smooth450inc_RO_HBM.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_smooth450static_RO_HBM.Time, df_smooth450static_RO_HBM.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_smooth325inc_RO_HBM.Time, df_smooth325inc_RO_HBM.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_smooth325static_RO_HBM.Time, df_smooth325static_RO_HBM.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO SMOOTHED")
#     plt.savefig('HBM_+_RO_SMOOTHED.png')
#     plt.show()
#     plt.close()


#     plt.ylim([0, 30])
#     plt.xlim([-2, 10])
#     plt.ylabel("Degrees C per Second")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_rate650inc_RO_HBM.Time, df_rate650inc_RO_HBM.Rate, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_rate650static_RO_HBM.Time, df_rate650static_RO_HBM.Rate, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_rate450inc_RO_HBM.Time, df_rate450inc_RO_HBM.Rate, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_rate450static_RO_HBM.Time, df_rate450static_RO_HBM.Rate, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_rate325inc_RO_HBM.Time, df_rate325inc_RO_HBM.Rate, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_rate325static_RO_HBM.Time, df_rate325static_RO_HBM.Rate, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO RATE")
#     plt.savefig('HBM_+_RO_RATE.png')
#     plt.show()
#     plt.close()



#     # RO + HBM GRAPHS 2

#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_650inc_RO_HBM_0.Time, df_650inc_RO_HBM_0.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_650static_RO_HBM_0.Time, df_650static_RO_HBM_0.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_450inc_RO_HBM_0.Time, df_450inc_RO_HBM_0.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_450static_RO_HBM_0.Time, df_450static_RO_HBM_0.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_325inc_RO_HBM_0.Time, df_325inc_RO_HBM_0.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_325static_RO_HBM_0.Time, df_325static_RO_HBM_0.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO RAW 2")
#     plt.savefig('HBM_+_RO_RAW_2.png')
#     plt.show()
#     plt.close()


#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_smooth650inc_RO_HBM_0.Time, df_smooth650inc_RO_HBM_0.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_smooth650static_RO_HBM_0.Time, df_smooth650static_RO_HBM_0.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_smooth450inc_RO_HBM_0.Time, df_smooth450inc_RO_HBM_0.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_smooth450static_RO_HBM_0.Time, df_smooth450static_RO_HBM_0.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_smooth325inc_RO_HBM_0.Time, df_smooth325inc_RO_HBM_0.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_smooth325static_RO_HBM_0.Time, df_smooth325static_RO_HBM_0.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO SMOOTHED 2")
#     plt.savefig('HBM_+_RO_SMOOTHED_2.png')
#     plt.show()
#     plt.close()


#     plt.ylim([0, 30])
#     plt.xlim([-2, 10])
#     plt.ylabel("Degrees C per Second")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_rate650inc_RO_HBM_0.Time, df_rate650inc_RO_HBM_0.Rate, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_rate650static_RO_HBM_0.Time, df_rate650static_RO_HBM_0.Rate, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_rate450inc_RO_HBM_0.Time, df_rate450inc_RO_HBM_0.Rate, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_rate450static_RO_HBM_0.Time, df_rate450static_RO_HBM_0.Rate, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_rate325inc_RO_HBM_0.Time, df_rate325inc_RO_HBM_0.Rate, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_rate325static_RO_HBM_0.Time, df_rate325static_RO_HBM_0.Rate, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM + RO RATE 2")
#     plt.savefig('HBM_+_RO_RATE_2.png')
#     plt.show()
#     plt.close()

#     # RO + HBM TEST 1 AND 2 GRAPHS

#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_smooth650inc_RO_HBM.Time, df_smooth650inc_RO_HBM.Temperature, color = "darkcyan", label = "650 Mhz inc 1")
#     plt.plot(df_smooth650static_RO_HBM.Time, df_smooth650static_RO_HBM.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static 1")
#     plt.plot(df_smooth450inc_RO_HBM.Time, df_smooth450inc_RO_HBM.Temperature, color = "darkgoldenrod", label = "450 Mhz inc 1")
#     plt.plot(df_smooth450static_RO_HBM.Time, df_smooth450static_RO_HBM.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static 1")
#     plt.plot(df_smooth325inc_RO_HBM.Time, df_smooth325inc_RO_HBM.Temperature, color = "darkslategray", label = "325 Mhz inc 1")
#     plt.plot(df_smooth325static_RO_HBM.Time, df_smooth325static_RO_HBM.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static 1")
#     plt.plot(df_smooth650inc_RO_HBM_0.Time, df_smooth650inc_RO_HBM_0.Temperature, color = "darkturquoise", label = "650 Mhz inc 2")
#     plt.plot(df_smooth650static_RO_HBM_0.Time, df_smooth650static_RO_HBM_0.Temperature, color = "darkturquoise", linestyle='dashed', label = "650 Mhz static 2")
#     plt.plot(df_smooth450inc_RO_HBM_0.Time, df_smooth450inc_RO_HBM_0.Temperature, color = "goldenrod", label = "450 Mhz inc 2")
#     plt.plot(df_smooth450static_RO_HBM_0.Time, df_smooth450static_RO_HBM_0.Temperature, color = "goldenrod", linestyle='dashed', label = "450 Mhz static 2")
#     plt.plot(df_smooth325inc_RO_HBM_0.Time, df_smooth325inc_RO_HBM_0.Temperature, color = "slategray", label = "325 Mhz inc 2")
#     plt.plot(df_smooth325static_RO_HBM_0.Time, df_smooth325static_RO_HBM_0.Temperature, color = "slategray", linestyle='dashed', label = "325 Mhz static 2")


#     plt.legend()
#     plt.title("HBM + RO SMOOTHED TEST 1 & 2")
#     plt.savefig('HBM_+_RO_SMOOTHED_1_&_2.png')
#     plt.show()
#     plt.close()


#     # HBM ONLY GRAPHS

#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_650inc_hbm.Time, df_650inc_hbm.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_650static_hbm.Time, df_650static_hbm.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_450inc_hbm.Time, df_450inc_hbm.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_450static_hbm.Time, df_450static_hbm.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_325inc_hbm.Time, df_325inc_hbm.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_325static_hbm.Time, df_325static_hbm.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM RAW")
#     plt.savefig('HBM_RAW.png')
#     plt.show()
#     plt.close()


#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_smooth650inc_hbm.Time, df_smooth650inc_hbm.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_smooth650static_hbm.Time, df_smooth650static_hbm.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_smooth450inc_hbm.Time, df_smooth450inc_hbm.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_smooth450static_hbm.Time, df_smooth450static_hbm.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_smooth325inc_hbm.Time, df_smooth325inc_hbm.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_smooth325static_hbm.Time, df_smooth325static_hbm.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM SMOOTHED")
#     plt.savefig('HBM_SMOOTHED.png')
#     plt.show()
#     plt.close()


#     plt.ylim([0, 30])
#     plt.xlim([-2, 10])
#     plt.ylabel("Degrees C per Second")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_rate650inc_hbm.Time, df_rate650inc_hbm.Rate, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_rate650static_hbm.Time, df_rate650static_hbm.Rate, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_rate450inc_hbm.Time, df_rate450inc_hbm.Rate, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_rate450static_hbm.Time, df_rate450static_hbm.Rate, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_rate325inc_hbm.Time, df_rate325inc_hbm.Rate, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_rate325static_hbm.Time, df_rate325static_hbm.Rate, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM RATE")
#     plt.savefig('HBM_RATE.png')
#     plt.show()
#     plt.close()



#     # HBM ONLY GRAPHS 2

#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_650inc_HBM_0.Time, df_650inc_HBM_0.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_650static_HBM_0.Time, df_650static_HBM_0.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_450inc_HBM_0.Time, df_450inc_HBM_0.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_450static_HBM_0.Time, df_450static_HBM_0.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_325inc_HBM_0.Time, df_325inc_HBM_0.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_325static_HBM_0.Time, df_325static_HBM_0.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM 2 RAW")
#     plt.savefig('HBM_2_RAW.png')
#     plt.show()
#     plt.close()


#     plt.ylim([30, 90])
#     plt.ylabel("Degrees C")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_smooth650inc_HBM_0.Time, df_smooth650inc_HBM_0.Temperature, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_smooth650static_HBM_0.Time, df_smooth650static_HBM_0.Temperature, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_smooth450inc_HBM_0.Time, df_smooth450inc_HBM_0.Temperature, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_smooth450static_HBM_0.Time, df_smooth450static_HBM_0.Temperature, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_smooth325inc_HBM_0.Time, df_smooth325inc_HBM_0.Temperature, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_smooth325static_HBM_0.Time, df_smooth325static_HBM_0.Temperature, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM 2 SMOOTHED")
#     plt.savefig('HBM_2_SMOOTHED.png')
#     plt.show()
#     plt.close()


#     plt.ylim([0, 30])
#     plt.xlim([-2, 10])
#     plt.ylabel("Degrees C per Second")
#     plt.xlabel("Time in Seconds")
#     plt.plot(df_rate650inc_HBM_0.Time, df_rate650inc_HBM_0.Rate, color = "darkcyan", label = "650 Mhz inc")
#     plt.plot(df_rate650static_HBM_0.Time, df_rate650static_HBM_0.Rate, color = "darkcyan", linestyle='dashed', label = "650 Mhz static")
#     plt.plot(df_rate450inc_HBM_0.Time, df_rate450inc_HBM_0.Rate, color = "darkgoldenrod", label = "450 Mhz inc")
#     plt.plot(df_rate450static_HBM_0.Time, df_rate450static_HBM_0.Rate, color = "darkgoldenrod", linestyle='dashed', label = "450 Mhz static")
#     plt.plot(df_rate325inc_HBM_0.Time, df_rate325inc_HBM_0.Rate, color = "darkslategray", label = "325 Mhz inc")
#     plt.plot(df_rate325static_HBM_0.Time, df_rate325static_HBM_0.Rate, color = "darkslategray", linestyle='dashed', label = "325 Mhz static")

#     plt.legend()
#     plt.title("HBM 2 RATE")
#     plt.savefig('HBM_2_RATE.png')
#     plt.show()
#     plt.close()