# Pin # | HX711
# ------|-----------
# 17    | data_pin
# 16    | clock_pin
#
import time
from hx711 import HX711
from machine import Pin

# --------------------------------------------------- #
# INIT
# --------------------------------------------------- #
pin_OUT = Pin(17, Pin.IN, pull=Pin.PULL_DOWN)
pin_SCK = Pin(16, Pin.OUT)

hx711 = HX711(pin_SCK, pin_OUT, gain=128)

hx711.set_time_constant(0)
zero_sensor = -81400                                    
one_gram = 11960

def work_hx711():
    cur_data = hx711.read_average()
    tared_data = (zero_sensor - cur_data) / one_gram
    if tared_data < 1:
        tared_data = 0
    tared_data = round(tared_data, 1)

    return tared_data
