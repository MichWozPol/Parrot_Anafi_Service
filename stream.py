import olympe
import requests
import numpy as np
import tempfile
import os
import csv
import queue
import threading


class Streaming:
    def __init__(self, drone, endpoint):
        self.drone = drone
        self.endpoint = endpoint

        self.tempd = tempfile.mkdtemp(prefix="olympe_streaming_test_")
        print("Olympe streaming example output dir: {}".format(self.tempd))
        self.h264_frame_stats = []
        self.h264_stats_file = open(os.path.join(self.tempd, "h264_stats.csv"), "w+")
        self.h264_stats_writer = csv.DictWriter(
            self.h264_stats_file, ["fps", "bitrate"]
        )
        self.h264_stats_writer.writeheader()
        

    def start(self):

        self.drone.streaming.set_output_files(
        video=os.path.join(self.tempd, "streaming.mp4"),
        metadata=os.path.join(self.tempd, "streaming_metadata.json"),
        )
        # Setup your callback functions to do some live video processing
        self.drone.streaming.set_callbacks(
            raw_cb=self.yuv_frame_cb
            # h264_cb=self.h264_frame_cb

        )

        # Start video streaming
        self.drone.streaming.start()


    def stop(self):
        self.drone.streaming.stop()
        self.h264_stats_file.close()



    def yuv_frame_cb(self, yuv_frame):
        """
        This function will be called by Olympe for each decoded YUV frame.
            :type yuv_frame: olympe.VideoFrame
        """
        if yuv_frame is not None:
            frame_array = yuv_frame.as_ndarray()
            frame_array = frame_array.tolist()
            requests.post(url=self.endpoint, json={'stream': frame_array})


    def h264_frame_cb(self, h264_frame):
        """
        This function will be called by Olympe for each new h264 frame.
            :type yuv_frame: olympe.VideoFrame
        """
        frame_array = h264_frame.as_ndarray()
        frame_array = frame_array.tolist()
        requests.post(url=self.endpoint, json={'stream': frame_array})

                # Get a ctypes pointer and size for this h264 frame
        frame_pointer, frame_size = h264_frame.as_ctypes_pointer()

        # For this example we will just compute some basic video stream stats
        # (bitrate and FPS) but we could choose to resend it over an another
        # interface or to decode it with our preferred hardware decoder..

        # Compute some stats and dump them in a csv file
        info = h264_frame.info()
        frame_ts = info["ntp_raw_timestamp"]
        if not bool(info["is_sync"]):
            while len(self.h264_frame_stats) > 0:
                start_ts, _ = self.h264_frame_stats[0]
                if (start_ts + 1e6) < frame_ts:
                    self.h264_frame_stats.pop(0)
                else:
                    break
            self.h264_frame_stats.append((frame_ts, frame_size))
            h264_fps = len(self.h264_frame_stats)
            h264_bitrate = 8 * sum(map(lambda t: t[1], self.h264_frame_stats))
            self.h264_stats_writer.writerow({"fps": h264_fps, "bitrate": h264_bitrate})
