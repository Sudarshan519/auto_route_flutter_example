import cv2
import pytesseract

import easyocr
reader = easyocr.Reader(['ja','en'])
result=reader.readtext("images/r27a.png",detail=0)
print(result)

# def find_roi(image_path):
#     # Read the image
#     image = cv2.imread(image_path)

#     # Convert the image to grayscale
#     gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

#     # Apply Gaussian blur to reduce noise
#     blurred = cv2.GaussianBlur(gray, (5, 5), 0)

#     # Perform Canny edge detection
#     edges = cv2.Canny(blurred, 50, 150)

#     # Find contours in the edge image
#     contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

#     # Find the largest contour
#     largest_contour = max(contours, key=cv2.contourArea)

#     # Get the bounding rectangle of the largest contour
#     x, y, width, height = cv2.boundingRect(largest_contour)

#     # Draw the bounding rectangle on the original image
#     roi_image = cv2.rectangle(image.copy(), (x, y), (x + width, y + height), (0, 255, 0), 2)
#     # Apply Gaussian blur to reduce noise
#     blurred = cv2.GaussianBlur(roi_image, (5, 5), 0)

<<<<<<< HEAD
#     # Perform Canny edge detection
#     edges = cv2.Canny(blurred, 50, 150)
#     # Display the original image with the ROI
#     # text = pytesseract.image_to_string(edges, lang='jpn')
#     # print(text)

#     cv2.imshow("Original Image with ROI", edges)
#     cv2.waitKey(0)
#     cv2.destroyAllWindows()

# # Call the function with the path to your image
# find_roi("images/r27a.png")
=======
    # Draw the bounding rectangle on the original image
    print(x)
    print(y)
    print(x+width)
    print(y+height)
    roi_image = cv2.rectangle(image.copy(), (x, y), (x + width, y + height), (0, 255, 0), 2)
    # Apply Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(roi_image, (5, 5), 0)
 
    # Perform Canny edge detection
    edges = cv2.Canny(blurred, 10, 150)
    # Display the original image with the ROI
    # text = pytesseract.image_to_string(edges, lang='jpn')
    # print(text)
    # result=reader.readtext(edges,detail=0)
    # print(result)
    cv2.imshow("Original Image with ROI", edges)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# Call the function with the path to your image


find_roi("images/jap/20230607084043040.png")
>>>>>>> 198359aadb11b2fed02262008f5f87fcbf3469f8
