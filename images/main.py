# import pytesseract
# # from PIL import Image
# # import numpy as np
# # import pandas as pd
# # import cv2


# # img_file="R14a.jpg"
# # # no_noise='temp/no_noise.jpg'
# # # img=Image.open(img_file)
# # # ocr_result=pytesseract.image_to_data(img)
# # # print(ocr_result)
# # image = cv2.imread(img_file)
# # grey=cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)

# # # convert to grayscale
# # gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# # # blur
# # blur = cv2.GaussianBlur(gray, (0,0), sigmaX=33, sigmaY=33)

# # # divide
# # divide = cv2.divide(gray, blur, scale=255)

# # # otsu threshold
# # thresh = cv2.threshold(divide, 0, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU)[1]

# # # apply morphology
# # kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
# # morph = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)

# # # # write result to disk
# # # cv2.imwrite("hebrew_text_division.jpg", divide)
# # # cv2.imwrite("hebrew_text_division_threshold.jpg", thresh)
# # # cv2.imwrite("hebrew_text_division_morph.jpg", morph)

# # # display it
# # # cv2.imshow("gray", gray)
# # # cv2.imshow("divide", divide)
# # # cv2.imshow("thresh", thresh)
# # # cv2.imshow("morph", morph)
# # # cv2.waitKey(0)
# # # cv2.destroyAllWindows()
# # data=(pytesseract.image_to_string(th,'jpn'))


# # # dataList = list(map(lambda x: x.split('\t'),data.split('\n')))

# # # df = pd.DataFrame(dataList[1:],columns=dataList[0])
# # print(data)


# import cv2
# import numpy as np

# img = cv2.imread('image.jpg')

# # get grayscale image
# def get_grayscale(image):
#     return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# # noise removal
# def remove_noise(image):
#     return cv2.medianBlur(image,5)
 
# #thresholding
# def thresholding(image):
#     return cv2.threshold(image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

# #dilation
# def dilate(image):
#     kernel = np.ones((5,5),np.uint8)
#     return cv2.dilate(image, kernel, iterations = 1)
    
# #erosion
# def erode(image):
#     kernel = np.ones((5,5),np.uint8)
#     return cv2.erode(image, kernel, iterations = 1)

# #opening - erosion followed by dilation
# def opening(image):
#     kernel = np.ones((5,5),np.uint8)
#     return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

# #canny edge detection
# def canny(image):
#     return cv2.Canny(image, 100, 200)

# #skew correction
# def deskew(image):
#     coords = np.column_stack(np.where(image > 0))
#     angle = cv2.minAreaRect(coords)[-1]
#     if angle < -45:
#         angle = -(90 + angle)
#     else:
#         angle = -angle
#     (h, w) = image.shape[:2]
#     center = (w // 2, h // 2)
#     M = cv2.getRotationMatrix2D(center, angle, 1.0)
#     rotated = cv2.warpAffine(image, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
#     return rotated

# #template matching
# def match_template(image, template):
#     return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED) 

# image = cv2.imread('R14a.jpg')

# gray = get_grayscale(image)
# thresh = thresholding(gray)
# opening = opening(gray)
# canny = canny(gray)


# h, w, c = image.shape
# boxes = pytesseract.image_to_boxes(image,'jpn') 
# for b in boxes.splitlines():
#     b = b.split(' ')
#     image = cv2.rectangle(image, (int(b[1]), h - int(b[2])), (int(b[3]), h - int(b[4])), (0, 255, 0), 2)

# cv2.imshow('img', image)
# cv2.waitKey(0)

import pytesseract
import re
import json

# Path to the driving license image
image_path = "images/R14a.jpg"

# Perform OCR on the image
text = pytesseract.image_to_string(image_path, lang='jpn')
print(text)
pattern = r"([A-Za-z0-9]+)"
# matches = re.findall(pattern, text)

# for match in matches:
#     print(match)
# Regular expressions for extracting specific fields 
name_pattern = r"[A-Za-z]+[\s-]?[A-Za-z]+"
license_number_pattern =r"[A-Za-z0-9]+"
date_of_birth_pattern = r"(\d{4})年(\d{2})月(\d{2})日"
expiry_date_pattern =r"(\d{4})年(\d{2})月(\d{2})日"
address_pattern = r"住所\s*([\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFFー]+)"

# Extract name
name_match = re.search(name_pattern, text)
name = name_match.group(1) if name_match else ""

# Extract license number
license_number_match = re.search(license_number_pattern, text)
license_number = license_number_match.group(1) if license_number_match else ""

# Extract date of birth
date_of_birth_match = re.search(date_of_birth_pattern, text)
date_of_birth = date_of_birth_match.group(1) if date_of_birth_match else ""

# Extract expiry date
expiry_date_match = re.search(expiry_date_pattern, text)
expiry_date = expiry_date_match.group(1) if expiry_date_match else ""

# Extract address
address_match = re.search(address_pattern, text)
address = address_match.group(1) if address_match else ""

# Create a dictionary to store the extracted data
driving_license_data = {
    "name": name,
    "license_number": license_number,
    "date_of_birth": date_of_birth,
    "expiry_date": expiry_date,
    "address": address
}

# Convert the dictionary to JSON
json_output = json.dumps(driving_license_data, ensure_ascii=False)

# Print the JSON output
print(json_output)