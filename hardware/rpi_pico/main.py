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
def _collect_sensor_datas(reed_data:int) -> str:
    # Collect Humidity, Temperature
    dht_data = dht.work_dht()
    if dht_data == False:
        dht_data = [0,0]
    # Collect Weight
    weight_data = hx711m.work_hx711()
    # Make data string // 리드 / 온도 / 무게 / 습도
    send_data_str = str(reed_data) + '/' + str(dht_data[1]) + '/' + str(weight_data) + '/' + str(dht_data[0])  

    return send_data_str

# --------------------------------------------------- #
# LOOP ENTRYPOINT
# --------------------------------------------------- #
def _run():
    # INIT REED STATE
    reed_data = -1
    display4.off_tm1637()
    # LOOP
    while True:
        # ------------------------------------------- #
        # DEFAULT LOOP
        # ------------------------------------------- #
        # Get data using BT(Standby)
        input_data = bto.recv_data_bt()

        # Get reed data from reed sensor
        current_reed_data = reed.work_reed()

        # ------------------------------------------- #
        # IF CONDITION MET
        # ------------------------------------------- #
        if input_data != '' or reed_data != current_reed_data:
            # Refine BT data
            input_data = input_data.strip()
            # Test code
            # print('INPUT FOUND ', input_data)
            
            # IF INPUT MEANS GET MESSAGE or MEDICINE LID STATUS CHANGED
            if input_data == 'REQ' or reed_data != current_reed_data:
                # Send data using BT
                bto.send_data_bt(_collect_sensor_datas(current_reed_data))
            else:
                # Refine BT data
                input_data = input_data.strip()
                display4.work_tm1637(input_data)
                neopixel.work_led()
                display4.off_tm1637()
                # Send data using BT
                bto.send_data_bt(_collect_sensor_datas(current_reed_data))
            
            # Update reed state
            reed_data = current_reed_data



if __name__ == '__main__':
    _run()