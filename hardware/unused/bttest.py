import uos
import machine
import utime


print(uos.uname())
uart0 = machine.UART(0,baudrate=9600)
    
def clartBuf(uart=uart0):
    print("Clear UART buffer "+ str(uart))
    while uart.any():
        print(uart.read(1))

#indicate program started visually
led_onboard = machine.Pin(25, machine.Pin.OUT)
led_onboard.value(0)     # onboard LED OFF/ON for 0.5/1.0 sec
utime.sleep(0.5)
led_onboard.value(1)
utime.sleep(1.0)
led_onboard.value(0)

print(uart0)



prvMills = utime.ticks_ms()
bUart0 = ''

while (utime.ticks_ms()-prvMills)<10000:
    if uart0.any():
        b0 = uart0.read(1)
        bUart0 += b0.decode('utf-8')
        print("UART(0): " + b0.decode('utf-8'))
        uart0.write(b0.upper().decode('utf-8'))


print("UART0: ")
print(bUart0)

    
print("- Done -")
