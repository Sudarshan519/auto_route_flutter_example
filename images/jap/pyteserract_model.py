import pytesseract
from PIL import Image

import easyocr
reader = easyocr.Reader(['ja','en'])
# images/r19a.jpg
# images/R14a.png
# result=reader.readtext('images/r19a.jpg',detail=1, paragraph=True)
text=reader.readtext("images/jap/app_flutter1679484244555.png",detail=1)
print(text)
for t in text:
    print(t[0])
    print(t[1])
# data=pytesseract.image_to_string(Image.open('images/jap/app_flutter1679484244555.png.png'))
# print(data)
# print(pytesseract.image_to_string(Image.open('images/jap/20230607084043040.png')),lang='jpn') 