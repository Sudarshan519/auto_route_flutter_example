import cv2 
import easyocr
reader = easyocr.Reader(['ja','en'])

import numpy as np
import matplotlib.pyplot as plt
image = cv2.imread("images/R14a.jpg")
import pytesseract
# convert it to grayscale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
# perform the canny edge detector to detect image edges
edges = cv2.Canny(gray, threshold1=30, threshold2=100)
# plt.imshow(edges, cmap="gray")
# plt.show()


# text=reader.readtext(edges)
# print(text)

def draw_boxes_on_character(img):
    img_width = img.shape[1]
    img_height = img.shape[0]
    boxes = pytesseract.image_to_string(img)
    for box in boxes.splitlines():
        box = box.split(" ")
        character = box[0]
        x = int(box[1])
        y = int(box[2])
        x2 = int(box[3])
        y2 = int(box[4])
        print(character)
        cv2.rectangle(img, (x, img_height - y), (x2, img_height - y2), (0, 255, 0), 1)
 
        cv2.putText(img, character, (x, img_height -y2), cv2.FONT_HERSHEY_COMPLEX, 1, (0, 0, 255), 1)
    return img
 
img = draw_boxes_on_character(gray)
plt.imshow(img)
plt.show()