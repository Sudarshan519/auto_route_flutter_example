import pytesseract
import re
import json

# Path to the driving license image
image_path = "images/R14a.jpg"

# Perform OCR on the image
text = pytesseract.image_to_string(image_path, lang='jpn')

# Regular expressions for extracting specific fields
name_pattern = r"[A-Za-z]+[\s-]?[A-Za-z]+"
license_number_pattern =r"[A-Za-z0-9]+"
# name_pattern = r"氏名\s*([\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}ー]+)"
# license_number_pattern = r"運転免許番号\s*([0-9A-Z]+)"
# date_of_birth_pattern = r"生年月日\s*([0-9]{4}/[0-9]{1,2}/[0-9]{1,2})"
# expiry_date_pattern = r"満了年月日\s*([0-9]{4}/[0-9]{1,2}/[0-9]{1,2})"
# address_pattern = r"住所\s*([\p{Script=Hiragana}\p{Script=Katakana}\p{Script=Han}ー]+)"

# Extract name
name_match = re.search(name_pattern, text)
name = name_match.group(1) if name_match else ""
print(name)

# Extract license number
license_number_match = re.search(license_number_pattern, text)
license_number = license_number_match.group(1) if license_number_match else ""
print(license_number)

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
