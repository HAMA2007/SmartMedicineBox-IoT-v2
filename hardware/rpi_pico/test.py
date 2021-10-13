import array, utime
from machine import Pin
import rp2

import neopixel
import dht
import bluetoooth as bto
import reed
import display4
import hx711m

# --------------------------------------------------- #
# FUNCTIONS
# --------------------------------------------------- #
def test_dht22():
    dht_data = dht.work_dht()
    print(dht_data)
    print('DHT DONE')

def test_weight():
    weight_data = hx711m.work_hx711()
    print(weight_data)
    print('WEIGHT DONE')

def test_display4():
    display4.work_tm1637('1234')
    display4.off_tm1637()
    print('TM1637 DONE')

def test_neopixel():
    neopixel.work_led()
    print('NEOPIXEL DONE')

def test_reed():
    current_reed_data = reed.work_reed()
    print('REED DONE')

def bt_receive():
    input_data = bto.recv_data_bt()
    if input_data != '':
        print('FOUND')
    print('BT RCV DONE')

def bt_send():
    bto.send_data_bt('1234')
    print('BT SD DONE')

# --------------------------------------------------- #
# LOOP ENTRYPOINT
# --------------------------------------------------- #
def _run():
    
    test_dht22()
    # test_display4()
    # test_neopixel()
    # test_reed()
    # test_weight()
    # bt_send()
    # bt_receive()



if __name__ == '__main__':
    _run()