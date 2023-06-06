import cv2

def detect_edges(image_path):
    # Read the image
    image = cv2.imread(image_path)

    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Apply Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Perform Canny edge detection
    edges = cv2.Canny(blurred, 50, 150)
    # Apply adaptive thresholding to create a binary image
    _, thresholded = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    # Apply morphological operations to further enhance the image
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    cleaned = cv2.morphologyEx(thresholded, cv2.MORPH_OPEN, kernel)

    # Display the original and cleaned images
    cv2.imshow("Original Image", image)
    cv2.imshow("Cleaned Image", cleaned)
    # Display the original image and the detected edges
    # cv2.imshow("Original Image", image)
    cv2.imshow("Edges", edges)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

# Call the function with the path to your image
detect_edges("images/R14a.jpg")
