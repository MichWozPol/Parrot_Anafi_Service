import time
import olympe
from stream import Stream
import requests
from olympe.messages.common.CommonState import BatteryStateChanged
from olympe.messages.ardrone3.PilotingState import PositionChanged, GpsLocationChanged, AltitudeAboveGroundChanged

DRONE_IP = "192.168.53.1"
URL = "http://localhost:8000/api"
CONNECTION_URL = URL + "/connection"
BATTERY_URL = URL + "/battery"
POSITION_URL = URL + "/position"

battery = 0
connection = False
altitude = 0,

battery_data = {'battery': battery}
connection_data = {'connection': connection}
position_data = {'altitude': altitude}

class FlightListener(olympe.EventListener):
    
    @olympe.listen_event(BatteryStateChanged())
    def onBatteryChange(self, event, scheduler):
        battery = event.args['percent']
        requests.post(POSITION_URL, json=battery_data)
    
    @olympe.listen_event(AltitudeAboveGroundChanged())
    def onBatteryChange(self, event, scheduler):
        altitude = event.args['altitude']
        print(position_data)
    # @olympe.listen_event(connection_state())
    # def onConnectionChange(self, event, scheduler):
    #     connection = event.args
    #     print("Connnection changed", connection)
    #     # requests.post(CONNECTION_URL, json=connection_data)
    

if __name__ == '__main__':
    print('Creating drone')
    drone = olympe.Drone(DRONE_IP)
    with FlightListener(drone):
        try:
            # print('Creating drone')
            # drone = olympe.Drone(DRONE_IP)
            time.sleep(2)


            drone.connect()
            print('Established connection')
            time.sleep(2)

            print(drone.get_state(GpsLocationChanged))
            # print(drone.get_state(AltitudeAboveGroundChanged))

            print('Creating stream')
            stream = Stream(drone)
            time.sleep(5)


            # print('Starting stream')
            # stream.start()
            # time.sleep(5)

            stream.fly()

            # print('Stopping stream')
            # stream.stop()



        finally:

            time.sleep(5)

            drone.disconnect()
    