import imutils
from skimage.filters import threshold_local
import cv2
import base64
import os
import argparse
import numpy as np
import random as rng
from stackchain.widgets import rect2Box,shoWait,validDateString
import pytesseract
from skimage import measure
import re
import datetime
import json