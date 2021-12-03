#include <Wire.h>


int SDO = 10;
int CLK = 11;
int CONV = 12; 


#define I2C_IO_ADDR (0x20) //Address of TCA9534 when A1=A2=A3=Low
#define I2C_IO_CONFIG_VALUE (1<<(uint8_t)(I2C_I_PORT_SAT))

#define ADC_INPUT_DIVIDER_RATIO (5.29822)//89)

enum i2c_io_registers {
  I2C_IO_INPUT = 0x00,
  I2C_IO_OUTPUT = 0x01,
  I2C_IO_POLARITY = 0x02,
  I2C_IO_CONFIG = 0x03,
};

enum i2c_io_ports {
  I2C_O_PORT_CLK_DIR = 0,
  I2C_O_PORT_DATA_DIR = 1,
  I2C_O_PORT_NC = 2,
  I2C_O_PORT_N_WE = 3,
  I2C_O_PORT_INPUT_ZERO = 4,
  I2C_I_PORT_SAT = 5,
  I2C_O_PORT_GAIN_LSB = 6,
  I2C_O_PORT_GAIN_MSB = 7,
};

enum i2c_gain {
  I2C_GAIN_1=1,
  I2C_GAIN_2=2,
  I2C_GAIN_5=5,
  I2C_GAIN_10=10,
};

static enum i2c_gain i2c_gain_val = I2C_GAIN_1;

static uint8_t i2c_io_port_val = 0x00;

static uint16_t adc_zero_offset = 0;

int i2c_io_set_register(enum i2c_io_registers reg_addr, uint8_t value)
{
  int err = 0;
  Wire.beginTransmission(I2C_IO_ADDR);  
  Wire.write((uint8_t)(reg_addr));              //Set register
  Wire.write(value);                 //Set register value

  if ((err = Wire.endTransmission()) != 0) {
    Serial.print("i2c error: ");
    Serial.println(err);
  }
  return err;
}

int i2c_io_read_register(enum i2c_io_registers reg_addr, uint8_t *value)
{
  int err = 0;
  if (value == NULL) {
    return 1;
  }
  
  Wire.beginTransmission(I2C_IO_ADDR);
  Wire.write((uint8_t)(reg_addr));              //Set register
  if ((err = Wire.endTransmission()) != 0) {
    Serial.print("i2c error: ");
    Serial.println(err);
    return err;
  }
  Wire.requestFrom(I2C_IO_ADDR, 1);              //request from register
  if (!Wire.available()) {
    Serial.print("i2c error.");
    err = 1;
  } else {
    *value = Wire.read();                 //Set register value
  }
  return err;
}

void i2c_o_port_set(enum i2c_io_ports port, uint8_t value)
{
  if (value & 1) { //set value?
    i2c_io_port_val |= (1 << (uint8_t)(port));
  } else { //unset value?
    i2c_io_port_val &= ~(1 << (uint8_t)(port));
  }
}

int i2c_o_port_update(void)
{
  return i2c_io_set_register(I2C_IO_OUTPUT, i2c_io_port_val);
}

int i2c_set_gain(enum i2c_gain gain)
{
  switch(gain) {
    case I2C_GAIN_1:
      i2c_o_port_set(I2C_O_PORT_GAIN_LSB, 0);
      i2c_o_port_set(I2C_O_PORT_GAIN_MSB, 0);
      break;
    case I2C_GAIN_2:
      i2c_o_port_set(I2C_O_PORT_GAIN_LSB, 1);
      i2c_o_port_set(I2C_O_PORT_GAIN_MSB, 0);
      break;
    case I2C_GAIN_5:
      i2c_o_port_set(I2C_O_PORT_GAIN_LSB, 0);
      i2c_o_port_set(I2C_O_PORT_GAIN_MSB, 1);
      break;
    case I2C_GAIN_10:
      i2c_o_port_set(I2C_O_PORT_GAIN_LSB, 1);
      i2c_o_port_set(I2C_O_PORT_GAIN_MSB, 1);
      break;
  }
  i2c_gain_val = gain;
  return 1;
}

int adc_read_val(uint16_t *val)
{
  if (val == NULL) return 1;
  *val = 0;
   //trigger conv
  digitalWrite(CONV, 1);
  delayMicroseconds(100);
  digitalWrite(CONV, 0);
  delayMicroseconds(100);


  for (int i=0;i<14;i++){
    
    digitalWrite(CLK, 0);
    delayMicroseconds(100); 
    digitalWrite(CLK, 1);
    delayMicroseconds(100);
    *val |= (digitalRead(SDO))<<(13-i);
    delayMicroseconds(100);  
  }
  return 0;
}

void adc_raw_to_float(float *result, uint16_t raw)
{
  if (result == NULL) return;

  int32_t s = (int32_t)raw - (int32_t)adc_zero_offset;
  *result = (float(s)*ADC_INPUT_DIVIDER_RATIO); //Voltage Divider
  *result *= (4.096/16384);  //14 bit ADC
  *result /= (float)(i2c_gain_val);

  
}

void setup()
{

  pinMode(SDO, INPUT);
  pinMode(CLK, OUTPUT);
  pinMode(CONV, OUTPUT);
  Serial.begin(9600);
  Wire.begin(); // join i2c bus (address optional for master)
  Wire.setClock(100000);

  if (i2c_io_set_register(I2C_IO_CONFIG, I2C_IO_CONFIG_VALUE) != 0) { //Set all ports as output
  }

  i2c_o_port_set(I2C_O_PORT_CLK_DIR, 0);
  i2c_o_port_set(I2C_O_PORT_DATA_DIR, 1);
  i2c_o_port_set(I2C_O_PORT_N_WE, 1);        //Set gain to high for falling flank
  i2c_o_port_set(I2C_O_PORT_INPUT_ZERO, 0);  //Set analog in to 0V
  
  i2c_set_gain(I2C_GAIN_1);

  if (i2c_o_port_update()) {
    
  }
  i2c_o_port_set(I2C_O_PORT_N_WE, 0);        //Set gain to low for falling flank
  if (i2c_o_port_update()) {
    
  }
  
  digitalWrite(CONV, 0);
  digitalWrite(CLK, 1);

  uint16_t adc_val = 0;
  //warm up ADC
  for (int i=0; i < 10; i++) {
    if(adc_read_val(&adc_val)!=0) {
      Serial.println("error: adc_read_val warmup");
    }
  }

  uint32_t adc_sum = 0;
  for (int i=0; i < 256; i++) {
    if(adc_read_val(&adc_val)!=0) {
      Serial.println("error: adc_read_val zero offset");
    }
    adc_sum += adc_val;
  }
  adc_zero_offset = adc_sum / 256;
  Serial.print("zero offset: "); Serial.println((float)adc_zero_offset/4000., 5);

  i2c_o_port_set(I2C_O_PORT_INPUT_ZERO, 1);  //Set analog in to 0V
  if (i2c_o_port_update()) {
    
  }
  
}
void loop()
{
  int err;
  uint8_t i2c_i_read = 0x00;
  uint16_t adc_val;
  uint32_t adc_sum = 0;
  float adc_float;
  
  err = i2c_io_read_register(I2C_IO_INPUT, &i2c_i_read);
  if (err != 0) {
    
  }
  Serial.print("Saturation: ");
  Serial.print(i2c_i_read);Serial.print(", ");
  Serial.println((i2c_i_read >> I2C_I_PORT_SAT) & 1);

  for (int i=0; i < 8; i++) {
    if (adc_read_val(&adc_val) != 0) {
      Serial.println("error: adc_read_val");
    }
    adc_sum += adc_val;
  }
  adc_val = adc_sum / 8;
  adc_raw_to_float(&adc_float, adc_val);
  Serial.print(adc_val);
  Serial.print(" offset: ");
  Serial.print((float)adc_zero_offset/4000., 5);
  Serial.print(" adc_in: ");
  Serial.print((float)(adc_val)/4000., 5);
  Serial.print("V; in: ");
  Serial.print(adc_float,5);
  Serial.println("V");

  delay(100);  
}
