import olympe
import time
from olympe.messages.skyctrl.CoPiloting import setPilotingSource
from olympe.messages.ardrone3.PilotingSettingsState import MaxTiltChanged
from olympe.messages.ardrone3.Piloting import TakeOff, Landing
from olympe.messages.common.CommonState import BatteryStateChanged

DRONE_IP = "192.168.53.1"

if __name__ == "__main__":
    drone = olympe.Drone(DRONE_IP)
    drone.connect()
    print(drone.get_state(BatteryStateChanged)['percent'])
    drone(setPilotingSource(source="Controller")).wait()
    assert drone(TakeOff()).wait().success()
    print(drone.connection_state())
    print("Drone MaxTilt = ", drone.get_state(MaxTiltChanged)["current"])
    time.sleep(5)
    print(drone.get_state(BatteryStateChanged)['percent'])
    assert drone(Landing()).wait().success()
    drone.disconnect()
    print(drone.connection_state())
