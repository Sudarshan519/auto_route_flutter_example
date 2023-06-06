import cv2
import numpy as np
import pytesseract
def get_position_from_blurred_edges(image_path):
    # Read the image
    image = cv2.imread(image_path)

    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Perform Canny edge detection
    edges = cv2.Canny(blurred, 50, 150)

    # Apply Hough transform to detect lines
    lines = cv2.HoughLinesP(edges, 1, np.pi/180, threshold=100, minLineLength=100, maxLineGap=10)
    
    # Extract position from the lines
    positions = []
    for line in lines:
        x1, y1, x2, y2 = line[0]
        position = (x1, y1, x2, y2)
        positions.append(position)

    # Extract text on positions using Tesseract OCR
    for position in positions:
        x1, y1, x2, y2 = position

        # Perform boundary checks
        x1 = max(0, x1)
        y1 = max(0, y1)
        x2 = min(x2, image.shape[1])
        y2 = min(y2, image.shape[0])

        if x2 > x1 and y2 > y1:
            roi = gray[y1:y2, x1:x2]
            text = pytesseract.image_to_string(roi,lang='jpn')
            print("Text on position", position, ":", text)


    # Print the extracted positions
    print("Extracted Positions:", positions)
    cv2.imshow('edges',image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
# Call the function with the path to your image
get_position_from_blurred_edges("images/r30a.png")
