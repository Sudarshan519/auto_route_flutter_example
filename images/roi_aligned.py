import cv2
import pytesseract
import numpy as np

def align_text_and_extract(image_path):
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

    # Extract positions from the lines
    positions = []
    for line in lines:
        x1, y1, x2, y2 = line[0]
        position = (x1, y1, x2, y2)
        positions.append(position)
        
    # Perform text alignment
    aligned_image = align_text(image, positions)

    # Extract text on aligned image
    gray_aligned = cv2.cvtColor(aligned_image, cv2.COLOR_BGR2GRAY)
    text = pytesseract.image_to_string(gray_aligned)

    # Print the extracted text
    print("Extracted Text:", text)

def align_text(image, positions):
    # Define a sample target ROI (change the coordinates as needed)
    target_roi = np.float32([[0, 0], [400, 0], [400, 100], [0, 100]])

    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Iterate over the positions and perform alignment for each position
    for position in positions:
        x1, y1, x2, y2 = position

        # Extract the region of interest (ROI)
        roi = gray[y1:y2, x1:x2]

        # Detect keypoints and descriptors using SIFT
        sift = cv2.SIFT_create()
        kp1, des1 = sift.detectAndCompute(roi, None)
        kp2, des2 = sift.detectAndCompute(target_roi, None)

        # Perform matching using FLANN
        FLANN_INDEX_KDTREE = 1
        index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
        search_params = dict(checks=50)
        flann = cv2.FlannBasedMatcher(index_params, search_params)
        matches = flann.knnMatch(des1, des2, k=2)

        # Perform filtering of good matches
        good_matches = []
        for m, n in matches:
            if m.distance < 0.75 * n.distance:
                good_matches.append(m)

        # Extract keypoints for good matches
        src_pts = np.float32([kp1[m.queryIdx].pt for m in good_matches]).reshape(-1, 1, 2)
        dst_pts = np.float32([kp2[m.trainIdx].pt for m in good_matches]).reshape(-1, 1, 2)

        # Calculate the homography matrix
        M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)

        # Apply the homography transformation to align the text
        aligned_text = cv2.warpPerspective(roi, M, (400, 100))

        # Replace the aligned region in the original image
        image[y1:y2, x1:x2] = aligned_text

    return image

# Call the function with the path to your image
align_text_and_extract("path_to_your_image.png")
