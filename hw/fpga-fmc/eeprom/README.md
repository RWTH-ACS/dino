# Programming the embedded eeprom on the DINO FMC Interface

## EEPROM Technical Information
According to the VITA 57.1 FMC Standard, FMC Boards need to provide FRU information via an eeprom connected to the FMC I2C bus (some public information can be found [here](https://ohwr.org/project/fmc-projects/wikis/FMC-standard).
We use a m24c02 2kbit/256byte device as recommended by [CERN](https://ohwr.org/project/fmc-projects/wikis/eeprom_24c02).
The address of the eeprom is defined by the FMC carrier board using the FMC signals GA0 and GA1 (GA0 being connected to A1 and GA1 being connected to A0). A2 is tied to GND on FMC Board.

## Connecting the FMC Board to the Xilinx ZCU106

The Xilinx ZCU106 Eval Board ties the address pins GA0 and GA1 for both FMC connectors to GND as the connecters use different channels on a I2C switch.
This means that the I2C address for the FMC board is alway 0x50 when connected to the ZCU106.
Accoridng to Xilinx UG1244 the two I2C buses for the FMC connecters are connected to PS I2C1, PL I2C1 and the MSP430 System Controller.
Using the SCUI Utility we can read the EEPROM via the System Controller but not write to it.
Using the PS we can access the I2C bus using Linux utilties such as i2c-tools.


## Generate EEPROM Image
Use [this](https://ohwr.org/project/fmc-bus/tree/master/) python2 (!) tool from CERN to generate an EEPROM image. Make sure to modify the VADJ voltage to 1.8V.
I found no other tool that worked properly.

```
python2 fru-generator.py > fmceeprom.bin
```

## Using PS and Petalinux to read the EEPROM
- active i2c-tools using `petalinux-config -c rootfs` and activate the individual tools using `petalinux-config -c busybox` (e.g., i2cdetect, i2cdump, i2cread, ...)
- build SDK `petalinux-build --sdk`

Once booted we can inspect the available i2c buses using
```
/ # i2cdetect -l
i2c-3	i2c       	i2c-0-mux (chan_id 1)           	I2C adapter
i2c-20	i2c       	i2c-1-mux (chan_id 6)           	I2C adapter
i2c-10	i2c       	i2c-1-mux (chan_id 4)           	I2C adapter
i2c-1	i2c       	Cadence I2C at ff030000         	I2C adapter
i2c-19	i2c       	i2c-1-mux (chan_id 5)           	I2C adapter
i2c-17	i2c       	i2c-1-mux (chan_id 3)           	I2C adapter
i2c-8	i2c       	i2c-1-mux (chan_id 2)           	I2C adapter
i2c-15	i2c       	i2c-1-mux (chan_id 1)           	I2C adapter
i2c-6	i2c       	i2c-1-mux (chan_id 0)           	I2C adapter
i2c-13	i2c       	i2c-1-mux (chan_id 7)           	I2C adapter
i2c-4	i2c       	i2c-0-mux (chan_id 2)           	I2C adapter
i2c-21	i2c       	i2c-1-mux (chan_id 7)           	I2C adapter
i2c-11	i2c       	i2c-1-mux (chan_id 5)           	I2C adapter
i2c-2	i2c       	i2c-0-mux (chan_id 0)           	I2C adapter
i2c-0	i2c       	Cadence I2C at ff020000         	I2C adapter
i2c-18	i2c       	i2c-1-mux (chan_id 4)           	I2C adapter
i2c-9	i2c       	i2c-1-mux (chan_id 3)           	I2C adapter
i2c-16	i2c       	i2c-1-mux (chan_id 2)           	I2C adapter
i2c-7	i2c       	i2c-1-mux (chan_id 1)           	I2C adapter
i2c-14	i2c       	i2c-1-mux (chan_id 0)           	I2C adapter
i2c-5	i2c       	i2c-0-mux (chan_id 3)           	I2C adapter
i2c-22	i2c       	ZynqMP DP AUX                   	I2C adapter
i2c-12	i2c       	i2c-1-mux (chan_id 6)           	I2C adapter
```

i2c-1 channel 0 is the FMC_HPC0 i2c bus and i2c-1 channel 1 os tje FMC_HPC1 i2c bus (see UG1244 Page 65).
We can read the content of the FMC_HPC1 eeprom using `i2cdump 15 0x50`.

## Program the EEPROM
- use a cross-compiler to compile `fmceeprom_write.c` for the Petalinux arch or use the pre-compiled `fmceeprom_write`.
- run `./fmceeprom_wirte fmceeprom.bin` and validate that the read back is correct.

## Verify FRU Data
- use the [FMC FRU EEPROM Utility](https://wiki.analog.com/resources/tools-software/linux-software/fru_dump) from analog devices to check the FRU data from the PS
- Cross-compile the tool and copy it to the PS.
- On PS load Linux EEPROM driver:
```
/ # echo 24c02 0x50 > /sys/bus/i2c/devices/i2c-15/new_device
```
- Verify correct output:
```
/ # ./fru-dump /sys/bus/i2c/devices/15-0050/eeprom -b
read 199 bytes from /sys/bus/i2c/devices/15-0050/eeprom
Date of Man	: Tue May 31 19:06:00 2022
Manufacturer	: RWTH ACS
Product Name	: DINO
Serial Number	: 0001
Part Number	: FMC Interface
FRU File ID	: 2022-05-31 19:06:18.444767
Custom Fields:

/ # ./fru-dump /sys/bus/i2c/devices/15-0050/eeprom -p
read 199 bytes from /sys/bus/i2c/devices/15-0050/eeprom
DC Load
  Output number: 0 (P1 VADJ)
  Nominal Volts:         1800 (mV)
  minimum voltage:       1720 (mV)
  maximum voltage:       1870 (mV)
  Ripple and Noise pk-pk 0000 (mV)
  Minimum current load   0000 (mA)
  Maximum current load   4000 (mA)
DC Load
  Output number: 1 (P1 3P3V)
  Nominal Volts:         3300 (mV)
  minimum voltage:       3130 (mV)
  maximum voltage:       3460 (mV)
  Ripple and Noise pk-pk 0000 (mV)
  Minimum current load   0000 (mA)
  Maximum current load   3000 (mA)
DC Load
  Output number: 2 (P1 12P0V)
  Nominal Volts:         12000 (mV)
  minimum voltage:       11400 (mV)
  maximum voltage:       12600 (mV)
  Ripple and Noise pk-pk 0000 (mV)
  Minimum current load   0000 (mA)
  Maximum current load   1000 (mA)
DC Output
  Output Number: 3 (P1 VIO_B_M2C)
  All Zeros
DC Output
  Output Number: 4 (P1 VREF_A_M2C)
  All Zeros
DC Output
  Output Number: 5 (P1 VREF_B_M2C)
  All Zeros
```
- unload Linux EEPROM driver if not needed anymore:
```
/ # echo 0x50 > /sys/bus/i2c/devices/i2c-15/delete_device
```
- we could also instatiate the device using the device tree: see [kernel documentation](https://www.kernel.org/doc/html/latest/i2c/instantiating-devices.html)
