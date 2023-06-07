# # Imports
# import cv2
# import numpy as np
# import easyocr
# reader = easyocr.Reader(['ja','en'])
# # Read image
# # imagePath = "images/jap/"imagePath +
# inputImage = cv2.imread( "images/jap/app_flutter1679484244555.png.png")

# # Conversion to CMYK (just the K channel):

# # Convert to float and divide by 255:
# imgFloat = inputImage.astype(np.float) / 255.

# # Calculate channel K:
# kChannel = 1 - np.max(imgFloat, axis=2)

# # Convert back to uint 8:
# kChannel = (255 * kChannel).astype(np.uint8)

# # Threshold image:
# binaryThresh = 100
# _, binaryImage = cv2.threshold(kChannel, binaryThresh, 255, cv2.THRESH_BINARY)


# # Filter small blobs:
# # Use a little bit of morphology to clean the mask:
# # Set kernel (structuring element) size:
# kernelSize = 3
# # Set morph operation iterations:
# opIterations = 1
# # Get the structuring element:
# morphKernel = cv2.getStructuringElement(cv2.MORPH_RECT, (kernelSize, kernelSize))
# # Perform closing:
# binaryImage = cv2.morphologyEx(binaryImage, cv2.MORPH_CLOSE, morphKernel, None, None, opIterations, cv2.BORDER_REFLECT101)

# reader.readtext(binaryImage,detail=1)
# cv2.imshow("binaryImage [closed]", binaryImage)
# cv2.waitKey(0)
import pytesseract
from PIL import Image
text = pytesseract.image_to_string(Image.open("images/R14a.jpg"), lang='jpn')
# print(text)]
data=text.split('\n')
print(data)
print(len(data))
# for data in text:
#     print(data)