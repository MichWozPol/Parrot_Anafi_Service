import olympe
import requests
import threading
import signal

from olympe.messages.ardrone3.Piloting import TakeOff
from olympe.messages.common.CommonState import BatteryStateChanged
from olympe.messages.ardrone3.PilotingState import AltitudeAboveGroundChanged, FlyingStateChanged, PositionChanged
from olympe.messages.ardrone3.GPSSettingsState import GPSFixStateChanged
from olympe.messages.camera import (
    set_camera_mode,
    take_photo,
    photo_progress,
)


olympe.log.update_config({"loggers": {"olympe": {"level": "ERROR"}}})

DRONE_IP = "192.168.53.1"

ANAFI_URL = "http://{}/".format(DRONE_IP)
MEDIA_URL =  ANAFI_URL + "api/v1/media/medias/"

URL = "http://localhost:8080/api"
CONNECTION_URL = URL + "/connection"
BATTERY_URL = URL + "/battery"
ALTITUDE_URL = URL + "/altitude"
GPS_URL = URL + "/gpslocation"
STREAM_URL = URL + "/stream"



battery = 0
connection = False
altitude = 0
longitude = 0
latitude = 0

stop_thread = False


def check_position(device):
    return device.get_state(AltitudeAboveGroundChanged)['altitude']


def check_battery(device):
    return device.get_state(BatteryStateChanged)['percent']


def check_connection(device):
    return device.connection_state()


def check_gps(device):
    return device.get_state(PositionChanged)


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


def check_gps_thread(device):
    global latitude
    global longitude
    global stop_thread

    while True:
        if stop_thread:
            break
        local_gps = check_gps(device)
        latitude = local_gps['latitude']
        longitude = local_gps['longitude']
        requests.post(GPS_URL, json={'latitude': latitude, 'longitude': longitude})


def check_position_thread(device):
    global altitude
    global stop_thread

    while True:
        if stop_thread:
            break
        local_position = check_position(device)
        if local_position != altitude:
            altitude = local_position
            requests.post(ALTITUDE_URL, json={'altitude': altitude}) 

def take_image_thread(device):
    global stop_thread

    while True:
        if stop_thread:
            break

        photo_saved = device(photo_progress(result="photo_saved", _policy="wait"))
        device(take_photo(cam_id=0)).wait()
        photo_saved.wait()
        media_id = photo_saved.received_events().last().args["media_id"]

        # download the photos associated with this media id
        media_info_response = requests.get(MEDIA_URL + media_id)
        media_info_response.raise_for_status()

        for resource in media_info_response.json()["resources"]:
            image_response = requests.get(ANAFI_URL + resource["url"], stream=True)
            image_response.raise_for_status()
            requests.post(url=STREAM_URL, json={'stream': image_response.raw})

# def take_photo(drone):
#     # take a photo and get the associated media_id
#     photo_saved = drone(photo_progress(result="photo_saved", _policy="wait"))
#     drone(take_photo(cam_id=0)).wait()
#     photo_saved.wait()
#     media_id = photo_saved.received_events().last().args["media_id"]

#     # download the photos associated with this media id
#     media_info_response = requests.get(MEDIA_URL + media_id)
#     media_info_response.raise_for_status()
#     download_dir = tempfile.mkdtemp()
#     for resource in media_info_response.json()["resources"]:
#         image_response = requests.get(ANAFI_URL + resource["url"], stream=True)
#         download_path = os.path.join(download_dir, resource["resource_id"])
#         image_response.raise_for_status()
#         with open(download_path, "wb") as image_file:
#             shutil.copyfileobj(image_response.raw, image_file)

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

        drone(GPSFixStateChanged(_policy = 'wait'))

        drone(set_camera_mode(cam_id=0, value="photo")).wait()



        assert drone(TakeOff()).wait().success()


        battery_thread = threading.Thread(target=check_battery_thread, args=(drone,))
        position_thread = threading.Thread(target=check_position_thread, args=(drone,))
        gps_thread = threading.Thread(target=check_gps_thread, args=(drone,))
        image_thread = threading.Thread(target=take_image_thread, args=(drone,))

        battery_thread.start()
        position_thread.start()
        gps_thread.start()
        image_thread.start()

        while True:
            stop = str(drone.get_state(FlyingStateChanged)["state"])
            if stop == "FlyingStateChanged_State.landed":
                print("STOPPING APP")
                stop_thread = True
                break
        

        battery_thread.join()
        position_thread.join()
        gps_thread.join()
        image_thread.join()
    
    finally:
        drone.disconnect()
        connection = check_connection(drone)
        requests.post(CONNECTION_URL, json={'connection': connection})
