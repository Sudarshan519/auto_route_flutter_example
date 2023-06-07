import os
import cv2
from rembg import remove
from rembg import remove
from PIL import Image
from datetime import datetime
path="images/R14a.png"
converted="images/jap/"
input = Image.open(path)
# output=remove(input)

box = (60, 110,1020, 760)
img2 = input.crop(box)
img2.show()
# cv2.imshow('dta',img2)
(dt, micro) = datetime.utcnow().strftime('%Y%m%d%H%M%S.%f').split('.')
date="%s%03d" % (dt, int(micro) / 1000)
newname=date
new_image = input.resize((720, 512))
img2.save(f"images/jap/{date}"+".png")
# new_image = input.resize((689, 468))