package com.server.parrot_anafi_server.controller;

import lombok.Getter;
import lombok.Setter;
import org.jcodec.codecs.h264.H264Decoder;
import org.jcodec.common.model.ColorSpace;
import org.jcodec.common.model.Picture;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;
import java.util.stream.Stream;
import org.apache.commons.lang3.ArrayUtils;

@RestController
@CrossOrigin(origins="*")
@RequestMapping("/api")
public class DataController {

    @Getter
    @Setter
    private int batteryCharge = 0;
    @Getter
    @Setter
    private double altitude = 0;
    @Getter
    @Setter
    private boolean connectedToDrone = false;
    @Getter
    @Setter
    private Queue<Byte[]> videoStream = new LinkedList<Byte[]>();
    @Getter
    @Setter
    private Map<String, Double> GPSLocation = new HashMap<>() {{put("longitude", 0d); put("latitude", 0d);}};

    @PostMapping("/battery")
    public HttpStatus addBatteryCharge(@RequestBody Map<String, Object> batteryCharge) {
        Integer currentBatteryCharge = (Integer)batteryCharge.get("batteryCharge");
        setBatteryCharge(currentBatteryCharge);
        return HttpStatus.OK;
    }

    @PostMapping("/altitude")
    public HttpStatus addAltitude(@RequestBody Map<String, Object> altitude) {
        Double currentAltitude = (Double) altitude.get("altitude");
        setAltitude(currentAltitude);
        return HttpStatus.OK;
    }

    @PostMapping("/connection")
    public HttpStatus addConnection(@RequestBody Map<String, Object> connectedToDrone) {
        Boolean isConnectedToDrone = (Boolean) connectedToDrone.get("connection");
        setConnectedToDrone(isConnectedToDrone);
        return HttpStatus.OK;
    }

    @PostMapping("/gpslocation")
    public HttpStatus addGPSLocation(@RequestBody Map<String, Object> gpsLocation) {
        Double currentLatitude = ((Double) gpsLocation.get("latitude"));
        Double currentLongitude = (Double) gpsLocation.get("longitude");
        Map<String, Double> currentGPSLocation = new HashMap<>();
        currentGPSLocation.put("latitude", currentLatitude);
        currentGPSLocation.put("longitude", currentLongitude);
        setGPSLocation(currentGPSLocation);
        return HttpStatus.OK;
    }

    @PostMapping("/stream")
    public HttpStatus readSteam(@RequestBody Map<String, Byte[]> stream) throws IOException {
        Byte[] streamValue = stream.get("stream");
        videoStream.add(streamValue);
        return HttpStatus.OK;
    }

    @GetMapping("/connection")
    public Map<String, Boolean> getConnection() {
        Map<String, Boolean> connection = new HashMap<String, Boolean>();
        connection.put("connection", isConnectedToDrone());
        return connection;
    }

    @GetMapping("/battery")
    public Map<String, Integer> getBattery() {
        Map<String, Integer> battery = new HashMap<String, Integer>();
        battery.put("batteryCharge", getBatteryCharge());
        return battery;
    }

    @GetMapping("/altitude")
    public Map<String, Double> getCurrentAltitude() {
        Map<String, Double> altitude = new HashMap<String, Double>();
        altitude.put("altitude", getAltitude());
        return altitude;
    }

    @GetMapping("/gpslocation")
    public Map<String, Double> getCurrentGPSLocation() {
        Map<String, Double> gpsLocation = new HashMap<>();
        gpsLocation.put("latitude", getGPSLocation().get("latitude"));
        gpsLocation.put("longitude", getGPSLocation().get("longitude"));
        return gpsLocation;
    }

    @GetMapping("/stream")
    public Map<String, Byte[]> getStream() {
        Map<String, Byte[]> currentStream = new HashMap<>();
        if (!videoStream.isEmpty()) {
            currentStream.put("stream", videoStream.poll());
        }
        else {
            currentStream.put("stream", null);
        }
        return currentStream;
    }

    private byte[][] decodeImage(Byte[] imageArray) {
        ByteBuffer bb = ByteBuffer.wrap(ArrayUtils.toPrimitive(imageArray)); // Your frame data is stored in this buffer
        H264Decoder decoder = new H264Decoder();
        Picture out = Picture.create(1280, 720, ColorSpace.RGB); // Allocate output frame of max size
        Picture real = decoder.decodeFrame(bb, out.getData());
        return real.getData();
    }

    @GetMapping("/stream2")
    public Map<String, Byte[]> getStream2() {
        Map<String, Byte[]> currentStream = new HashMap<>();
        if (!videoStream.isEmpty()) {
            byte[][] currentBytesArray = decodeImage(videoStream.poll());
            Byte[] streamArray = Stream.of(currentBytesArray).flatMap(Stream::of).toArray(Byte[]::new);
            currentStream.put("stream", streamArray);
        }
        else {
            currentStream.put("stream", null);
        }
        return currentStream;
    }
}
