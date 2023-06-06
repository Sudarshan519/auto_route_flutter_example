import cv2
import numpy as np
import pytesseract
import easyocr
reader = easyocr.Reader(['ja','en'])
import os

current_dir = os.getcwd()
print("Current Directory:", current_dir)
file_list=os.listdir('/home/a/Documents/auto_route_flutter_example/images/')
for file in file_list:
    # print(file)

    extension = os.path.splitext(file)[1]
    print(extension)
    if extension == '.jpg' or extension=='.png':
        filename = os.path.basename(file) 
        print(reader.readtext(f'{filename}',detail=0))
    # if os.path.isfile(file):
    #     print(file)
    #     if extension.lower()=='.png' or extension.lower()=='.jpg':
    #         print(reader.readtext(file,detail=0))
# result=reader.readtext('images/r19a.png',detail=0)
# print(result)
# result=reader.readtext('images/r29a.png',detail=0)
# print(result)
# load image as grayscale
# img = cv2.imread('images/R14a.jpg')

# gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# # threshold 
# thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU)[1]

# # get bounds of white pixels
# white = np.where(thresh==255)
# xmin, ymin, xmax, ymax = np.min(white[1]), np.min(white[0]), np.max(white[1]), np.max(white[0])
# print(xmin,xmax,ymin,ymax)

# # crop the gray image at the bounds
# crop = gray[ymin:ymax, xmin:xmax]
# hh, ww = crop.shape

# # do adaptive thresholding
# thresh2 = cv2.adaptiveThreshold(crop, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 3, 1.1)

# # apply morphology
# kernel = np.ones((1,7), np.uint8)
# morph = cv2.morphologyEx(thresh2, cv2.MORPH_CLOSE, kernel)
# kernel = np.ones((5,5), np.uint8)
# morph = cv2.morphologyEx(morph, cv2.MORPH_OPEN, kernel)

# # invert
# morph = 255 - morph

# # get contours (presumably just one) and its bounding box
# contours = cv2.findContours(morph, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
# contours = contours[0] if len(contours) == 2 else contours[1]
# for cntr in contours:
#     x,y,w,h = cv2.boundingRect(cntr)

# # draw bounding box on input
# bbox = img.copy()
# cv2.rectangle(bbox, (x+xmin, y+ymin), (x+xmin+w, y+ymin+h), (0,0,255), 1)

# # test if contour touches sides of image
# if x == 0 or y == 0 or x+w == ww or y+h == hh:
#     print('region touches the sides')
# else:
#     print('region does not touch the sides')

# # save resulting masked image
# cv2.imwrite('streak_thresh.png', thresh2)
# # cv2.imwrite('streak_crop.png', crop)
# # cv2.imwrite('streak_bbox.png', bbox)

# # display result
# # cv2.imshow("thresh", thresh)
# # cv2.imshow("crop", crop)
# # cv2.imshow("thresh2", thresh2)
# data=reader.readtext('streak_thresh.png',detail=0)
# print(data)
# # data=pytesseract.image_to_string(thresh2,lang='jpn')
# # print(data)
# # cv2.imshow("morph", morph)
# # cv2.imshow("bbox", bbox)
# cv2.waitKey(0)
# cv2.destroyAllWindows()