import easyocr
import cv2
reader = easyocr.Reader(['ja','en'])
import matplotlib.pyplot as plt
result=reader.readtext('images/r19a.jpg',detail=1, paragraph=True)
print(result)
spacer=300
top_left=tuple(result[0][0][0])
bottom_right=tuple(result[0][0][2])
text=result[0][1]
img=cv2.imread('images/r19a.jpg')

for detection in result:
    top_left=tuple(detection[0][0])
    bottom_right=tuple(detection[0][2])
    text=detection[1]
    img=cv2.rectangle(img,top_left,bottom_right,(0,255,0),3)
    spacer+=15

    plt.figure(figsize=(10,10))
    plt.imshow(img)
    plt.show()