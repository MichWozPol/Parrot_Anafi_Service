import olympe
import requests


class Streaming:
    def __init__(self, drone, endpoint):
        self.drone = drone
        self.endpoint = endpoint


    def start(self):
        # Setup your callback functions to do some live video processing
        self.drone.streaming.set_callbacks(
            h264_cb=self.h264_frame_cb
        )

        # Start video streaming
        self.drone.streaming.start()


    def stop(self):
        self.drone.streaming.stop()



    def h264_frame_cb(self, h264_frame):
        """
        This function will be called by Olympe for each new h264 frame.
            :type yuv_frame: olympe.VideoFrame
        """
        frame_array = h264_frame.as_ndarray()
        requests.post(url=self.endpoint, json={'stream': frame_array})
