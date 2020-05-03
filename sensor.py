#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle.ext.websocket import GeventWebSocketServer
from bottle.ext.websocket import websocket
from bottle import run, route, get, template

import time
import board
import busio
import adafruit_adxl34x

i2c = busio.I2C(board.SCL, board.SDA)
accelerometer = adafruit_adxl34x.ADXL345(i2c)

@get('/data')
def data():
  t = time.time()
  data = accelerometer.acceleration
  return { 't': t, 'x': data[0], 'y': data[1], 'z': data[2] }

@get('/')
def client():
    return template('index')

run(host='0.0.0.0', port=3000, reloader=True, server=GeventWebSocketServer)
