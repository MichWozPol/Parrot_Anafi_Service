package com.server.parrot_anafi_server.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TemplatesController {

    @GetMapping("/")
    public String getMainView() {
        return "index";
    }
}
