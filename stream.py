import olympe
import requests
import numpy as np


class Streaming:
    def __init__(self, drone, endpoint):
        self.drone = drone
        self.endpoint = endpoint


    def start(self):
        # Setup your callback functions to do some live video processing
        self.drone.streaming.set_callbacks(
            raw_cb=self.yuv_frame_cb
            #h264_cb=self.h264_frame_cb

        )

        # Start video streaming
        self.drone.streaming.start()


    def stop(self):
        self.drone.streaming.stop()


    def yuv_frame_cb(self, yuv_frame):
        """
        This function will be called by Olympe for each decoded YUV frame.
            :type yuv_frame: olympe.VideoFrame
        """
        frame_array = yuv_frame.as_ndarray()
        print(np.shape(frame_array))
        frame_array = frame_array.tolist()
        requests.post(url=self.endpoint, json={'stream': frame_array})


    def h264_frame_cb(self, h264_frame):
        """
        This function will be called by Olympe for each new h264 frame.
            :type yuv_frame: olympe.VideoFrame
        """
        frame_array = h264_frame.as_ndarray()
        requests.post(url=self.endpoint, json={'stream': frame_array})
