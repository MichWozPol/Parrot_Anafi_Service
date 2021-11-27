package com.server.parrot_anafi_server.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name="image")
public class Data {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Getter
    @Column(name="id")
    private int id;

    @Getter
    @Setter
    @Column(name = "capture_data")
    private Date captureData;

    @Getter
    @Setter
    @Column(name = "blob")
    private byte blob;

    public Data(){

    }

    public Data(int id, Date captureData, byte blob) {
        this.id = id;
        this.captureData = captureData;
        this.blob = blob;
    }

}
