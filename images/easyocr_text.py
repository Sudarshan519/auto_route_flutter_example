import easyocr
reader = easyocr.Reader(['ja','en'])

result=reader.readtext('images/r29a.png',detail=0)
print(result)