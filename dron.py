import olympe
from stream import Stream
import requests
import threading
import signal

from olympe.messages.ardrone3.Piloting import TakeOff
from olympe.messages.common.CommonState import BatteryStateChanged
from olympe.messages.ardrone3.PilotingState import AltitudeAboveGroundChanged, FlyingStateChanged


olympe.log.update_config({"loggers": {"olympe": {"level": "ERROR"}}})

DRONE_IP = "192.168.53.1"
URL = "http://localhost:8080/api"
CONNECTION_URL = URL + "/connection"
BATTERY_URL = URL + "/battery"
POSITION_URL = URL + "/position"

battery = 0
connection = False
altitude = 0,

stop_thread = False


def check_position(device):
    return device.get_state(AltitudeAboveGroundChanged)['altitude']


def check_battery(device):
    return device.get_state(BatteryStateChanged)['percent']


def check_connection(device):
    return device.connection_state()


def check_battery_thread(device):
    global battery
    global stop_thread

    while True:
        if stop_thread:
            break
        local_battery = check_battery(device)
        if local_battery != battery:
            battery = local_battery
            requests.post(BATTERY_URL, json={'batteryCharge': battery})


def check_position_thread(device):
    global altitude
    global stop_thread

    while True:
        if stop_thread:
            break
        local_position = check_position(device)
        if local_position != altitude:
            altitude = local_position
            requests.post(POSITION_URL, json={'altitude': altitude})


def keyboardInterruptHandler(signal, frame):
    global connection

    print(connection)
    connection = False
    response = requests.post(CONNECTION_URL, json={'connection': connection})
    print(response.json())

    exit(0)

signal.signal(signal.SIGINT, keyboardInterruptHandler)


if __name__ == '__main__':

    try:
        drone = olympe.Drone(DRONE_IP)

        connection = check_connection(drone)
        requests.post(CONNECTION_URL, json={'connection': connection})

        drone.connect()
        connection = check_connection(drone)
        requests.post(CONNECTION_URL, json={'connection': connection})


        assert drone(TakeOff()).wait().success()


        battery_thread = threading.Thread(target=check_battery_thread, args=(drone,))
        position_thread = threading.Thread(target=check_position_thread, args=(drone,))

        battery_thread.start()
        position_thread.start()

        while True:
            stop = str(drone.get_state(FlyingStateChanged)["state"])
            if stop == "FlyingStateChanged_State.landed":
                print("STOPPING APP")
                stop_thread = True
                break
        
        battery_thread.join()
        position_thread.join()
    
    finally:
        drone.disconnect()
        connection = check_connection(drone)
        requests.post(CONNECTION_URL, json={'connection': connection})
