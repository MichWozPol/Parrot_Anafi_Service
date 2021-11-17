package com.server.parrot_anafi_server.controller;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
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
    public int addBatteryCharge(@RequestBody int batteryCharge) {
        setBatteryCharge(batteryCharge);
        return batteryCharge;
    }

    @PostMapping("/altitude")
    public float addAltitude(@RequestBody float altitude) {
        setAltitude(altitude);
        return altitude;
    }

    @PostMapping("/connection")
    public boolean addConnection(@RequestBody boolean connectedToDrone) {
        setConnectedToDrone(connectedToDrone);
        return connectedToDrone;
    }

    @GetMapping("/connection")
    public int getConnection() {
        return getConnection();
    }

    @GetMapping("/battery")
    public int getBattery() {
        return getBatteryCharge();
    }

    @GetMapping("/altitude")
    public float getCurrentAltitude() {
        return getAltitude();
    }

    @PostMapping("/stream")
    public String readSteam(@RequestBody byte[] stream) throws IOException {
        offset = 0;
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(byteBufferSize);
        while(stream != null)
        {
            byteArrayOutputStream.write(stream, offset, byteBufferSize);
            videoStream.add(byteArrayOutputStream.toByteArray());
            byteArrayOutputStream.flush();
            offset += byteBufferSize;
        }
        byteArrayOutputStream.close();
        return "Receiving";
    }
}
