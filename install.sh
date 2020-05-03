#!/bin/sh
apt-get update -y
apt-get upgrade -y
apt-get install python3 python3-pip python3-smbus  -y
pip3 install adafruit_adxl34x
