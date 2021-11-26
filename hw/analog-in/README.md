# dino - analog in


### ADC Module - LTC2312-14bit


- Samplingrate: 500ksps <-> 4.5Msps
- Resolution: 14 bit
- Input Ranges:
  - 0 to 4.096V
  - ... 

- Input protection?
- Input isolation?
- Calibration?

## Module Interface

## Architecture

![](diagram.pdf)

## Components

| Tag               | Component      | Stock | Notes / Description |
|-------------------|----------------|-------|--------|
| ADC               | [LTC2312-14](https://www.analog.com/media/en/technical-documentation/data-sheets/231214fa.pdf)     | 2     |        |
| DC/DC             | [TDN3-1221WISM](https://www.tracopower.com/sites/default/files/products/datasheets/tdn1wism_datasheet.pdf)  | 5     |        |
| I2C Isolator      | [ADUM1250/1251](https://www.analog.com/media/en/technical-documentation/data-sheets/ADUM1250_1251.pdf)  | 1     |        |
| CONV Isolator     | [ADUM4120](https://www.analog.com/media/en/technical-documentation/data-sheets/ADuM4120-4120-1.pdf)       | 2     |        |
| CLK Isolator      | [ADM2486](https://www.analog.com/media/en/technical-documentation/data-sheets/ADM2486.pdf)       | 2     |        |
| Shift Register    | [TCA9534](https://www.ti.com/lit/ds/symlink/tca9534.pdf?ts=1607878079799&ref_url=https%253A%252F%252Fwww.ti.com%252Fproduct%252FTCA9534%253Futm_source%253Dgoogle%2526utm_medium%253Dcpc%2526utm_campaign%253Dasc-null-null-gpn_en-cpc-pf-google-wwe%2526utm_content%253Dtca9534%2526ds_k%253DTCA9534%2526dcm%253Dyes%2526gclid%253DCjwKCAiAlNf-BRB_EiwA2osbxSn2BJCqIPv8pv_chYE8HBU01zoYS7veeZFo8f20QknqdfCq58b9ORoCjIIQAvD_BwE%2526gclsrc%253Daw.ds)        | 0     |        |
| Instrumentation Amplifier  | [AD8250](https://www.analog.com/media/en/technical-documentation/data-sheets/AD8250.pdf)        | 0     |        |
| Analog Switch     | [MAX4564](https://datasheets.maximintegrated.com/en/ds/MAX4564.pdf)        |       |        |
| Voltage Reference | [LT6654](https://www.analog.com/media/en/technical-documentation/data-sheets/6654fh.pdf)         | 0     |        |
| ROHM              | [BR24T1MF-3AME2](https://fscdn.rohm.com/en/products/databook/datasheet/ic/memory/eeprom/br24t1m-3am-e.pdf) | 0     |        |
| RJ45 Connector    | -              |       |        |
|FUSE|           |       |        |
|Double D flip flop|[74HC74](https://docs.rs-online.com/0bd3/0900766b81620dd2.pdf)|0|[digi-key](https://www.digikey.de/product-detail/en/nexperia-usa-inc/74HC74D-653/1727-2824-2-ND/763094)|
|OR gate IC|[SN74LVC1G32](https://www.ti.com/lit/ds/symlink/sn74lvc1g32.pdf?ts=1616658660326&ref_url=https%253A%252F%252Fwww.google.com%252F)|0|no info about freq. [digi-key](https://www.digikey.de/product-detail/en/texas-instruments/SN74LVC1G32DCKR/296-9848-2-ND/381315)|
|AND gate IC|[SN74LVC1G08-Q1](https://www.ti.com/lit/ds/symlink/sn74lvc1g08-q1.pdf?ts=1616684039458&ref_url=https%253A%252F%252Fwww.google.com%252F)|0|no info about freq. [diig-key](https://www.digikey.de/product-detail/en/texas-instruments/SN74LVC1G08QDBVRQ1/296-24187-2-ND/1591986)|
