# seek-toy-robot-simulator

This app purpose is to provide simulation for the Toy Robot Simulator

Reference: https://www.slideshare.net/slideshow/toy-robot-simulator/46521787

# Overview

## Problem Statement

The application is a simulation of a toy robot moving on a square tabletop, of dimension 5x5 units. 
- There are no other obstructors on the table surface.
- The robot is free to roam around the space of the table.
- The robot must be prevented from falling to destruction.
- Any movement that would result in the robot falling from the table must be prevented
- However further valid movement commands must still be allowed.

## Additional Requirements

- The application core function must be highly customizable.
- The application should be well tested
- The application should be performant
- If new type of integration is needed, implementation should not be too difficult.

# Implementation Consideration

- Choosing multiple patterns such as Polymorphism and Repository pattern. This is to make the application highly extensible.
- Implement unit tests for all components. Also implement integration tests to ensure the application reliability.
- Execute a performance benchmark to establish a baseline and compare it to the norms
- Implements a generator pattern for easy and quick maintenance process.
- Use session based processing to maintain cross-entrypoint compatibility.
- Use session locking to prevent race condition.

# Deployment Guide

## Local

### Requirements

- Docker Engine
- Docker Compose

1. Clone this repository
$ git clone <repository link> <target>

2. Go into the target directory
$ cd <target>

3. Build the base image
$ docker-compose build base

4. [optional] Start the services
$ docker-compose up -d

5. [optional] Start unit test
$ docker-compose run --rm cli test

6. Use the CLI REPL
$ docker-compose run --rm cli
> You can append DEBUG=true to the command, for enabling debug messages


