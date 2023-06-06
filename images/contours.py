import cv2

# Step 1: Load the image
image_path = "images/R14a.jpg"
 
image = cv2.imread(image_path)

# Step 2: Convert the image to grayscale
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Step 3: Apply any necessary pre-processing techniques
# (e.g., noise reduction, thresholding, etc.) to enhance the image quality

# Step 4: Perform edge detection
edges = cv2.Canny(gray_image, threshold1=30, threshold2=100)

# Step 5: Find contours in the edge-detected image
# contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# Step 6: Filter contours based on area and draw them on the original image
image_with_boundaries = image.copy()  # Create a copy of the original image
min_contour_area = 100  # Adjust this threshold as needed
edges = cv2.Canny(gray_image, threshold1=20, threshold2=100)


# Find contours of the edges
contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# # Find the largest contour
largest_contour = min(contours, key=cv2.contourArea)

# Get the bounding box coordinates of the largest contour
x, y, w, h = cv2.boundingRect(largest_contour)
# Step 8: Adjust the cropping coordinates based on the edge contour
x = max(0, x - 10)  # Add padding of 10 pixels on each side
y = max(0, y - 10)
w = min(w + 80, image.shape[1] - x)  # Ensure width remains within image bounds
h = min(h + 80, image.shape[0] - y)  # Ensure height remains within image bounds

cropped_image = image[y:y+h, x:x+w]

# Print the bounding box coordinates
print("Bounding Box (x, y, w, h):", y, x, w, h)
# print(edges)
# Find coordinates of edge points
# import numpy as np
# edge_points = np.argwhere(edges != 0)

# # Print the coordinates of edge points
# for point in edge_points:
#     x, y = point[1], point[0]
#     print("Edge Point (x, y):", x, y)
# # contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# for contour in contours:
#     # Calculate the contour area
#     contour_area = cv2.contourArea(contours)
    
#     # Filter out smaller contours
#     if contour_area > min_contour_area:
#         # Get the bounding rectangle coordinates
#         x, y, w, h = cv2.boundingRect(contour)
        
#         # Draw the bounding rectangle on the image with boundaries
#         cv2.rectangle(image_with_boundaries, (x, y), (x+w, y+h), (0, 255, 0), 2)

# # Step 7: Display the image with the detected boundaries
cv2.imshow("Image with Boundaries", edges)
import pytesseract
roi=[
    (160, 250, 530, 280),  # Example coordinates for name field (x1, y1, x2, y2)
    (160, 270, 530, 280), # Example coordinates for ID number field (x1, y1, x2, y2)
    # Add more coordinates for other fields as needed
]

for roi_coords in roi:
    x1, y1, x2, y2 = roi_coords
    roi = gray_image[y1:y2, x1:x2]
    extracted_text = pytesseract.image_to_string(roi).strip()
    print(extracted_text)
# cv2.imshow("",cropped_image)
cv2.waitKey(0)
cv2.destroyAllWindows()
