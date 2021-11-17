package com.server.parrot_anafi_server.controller;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;

@RestController
@RequestMapping("/api")
public class DataController {

    private final int byteBufferSize = 1000;
    private int offset = 0;
    @Getter
    @Setter
    private int batteryCharge = 0;
    @Getter
    @Setter
    private float altitude = 0;
    @Getter
    @Setter
    private boolean connectedToDrone = false;
    @Getter
    @Setter
    private Queue<byte[]> videoStream;

    @PostMapping("/battery")
    public HttpStatus addBatteryCharge(@RequestBody Map<String, Object> batteryCharge) {
        Integer currentBatteryCharge = (Integer)batteryCharge.get("batteryCharge");
        setBatteryCharge(currentBatteryCharge);
        return HttpStatus.OK;
    }

    @PostMapping("/altitude")
    public HttpStatus addAltitude(@RequestBody Map<String, Object> altitude) {
        Float currentAltitude = (Float) altitude.get("altitude");
        setAltitude(currentAltitude);
        return HttpStatus.OK;
    }

    @PostMapping("/connection")
    public HttpStatus addConnection(@RequestBody Map<String, Object> connectedToDrone) {
        Boolean isConnectedToDrone = (Boolean) connectedToDrone.get("connection");
        setConnectedToDrone(isConnectedToDrone);
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
    public Map<String, Float> getCurrentAltitude() {
        Map<String, Float> altitude = new HashMap<String, Float>();
        altitude.put("altitude", getAltitude());
        return altitude;
    }

    @PostMapping("/stream")
    public HttpStatus readSteam(@RequestBody Map<String, byte[]> stream) throws IOException {
        offset = 0;
        byte[] streamValue = stream.get("stream");
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(byteBufferSize);
        while(stream != null)
        {
            byteArrayOutputStream.write(streamValue, offset, byteBufferSize);
            videoStream.add(byteArrayOutputStream.toByteArray());
            byteArrayOutputStream.flush();
            offset += byteBufferSize;
        }
        byteArrayOutputStream.close();
        return HttpStatus.OK;
    }
}
