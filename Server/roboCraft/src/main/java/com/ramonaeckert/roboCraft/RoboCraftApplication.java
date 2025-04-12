package com.ramonaeckert.roboCraft;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class RoboCraftApplication {

	public static void main(String[] args) {
		SpringApplication.run(RoboCraftApplication.class, args);
	}

}
