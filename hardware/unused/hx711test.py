# Pin # | HX711
# ------|-----------
# 17    | data_pin
# 16    | clock_pin
#
# RPI PICO테스트 완료
import time
from hx711 import HX711
from machine import Pin

pin_OUT = Pin(17, Pin.IN, pull=Pin.PULL_DOWN)
pin_SCK = Pin(16, Pin.OUT)

hx711 = HX711(pin_SCK, pin_OUT, gain=128)

# 1로 갈 수록 짧은 시간에 측정한 값, 0으로 갈 수록 길게 평균내 측정한 값
hx711.set_time_constant(0)
# 아무것도 올리지 않았을 때 센서값 -> 이건 센서마다 다를 수 있으니 직접 테스트 해야 됨-> 최초 값은 cur_data가져다 쓰면 됨
zero_sensor = -269000
# 1g당 무게 차이당 센서값 차이 -> 역시 센서마다 다를 수 있으니 직접 테스트 할 것
one_gram = 11670
while True:
    # 센서 값 읽어오기
    cur_data = hx711.read_average()
    # 센서 값을 실제 값으로 전환
    tared_data = (zero_sensor - cur_data) / one_gram
    # 실제 값이 마이너스라면 0으로 전환 (실제로는 -0.00013이런 형태가 많기에)
    if tared_data < 0:
        tared_data = 0
    # 소숫점 한자리까지만 표현하게 반올림 처리
    tared_data = round(tared_data, 1)
    # Test code
    print(tared_data)
    # 1초마다 반복
    time.sleep(1)

