package com.server.parrot_anafi_server.controller;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

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
}
