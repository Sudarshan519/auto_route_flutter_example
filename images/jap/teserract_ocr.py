import easyocr
reader = easyocr.Reader(['ja','en'])
# images/r19a.jpg
# images/R14a.png
# result=reader.readtext('images/r19a.jpg',detail=1, paragraph=True)
text=reader.readtext("images/R14a.jpg",detail=1)
import re
# exp=re(r"\d{4}年\d{2}月\d{2}日")
# x = re.search(exp,text)
# print(text)
# ([[47, 61], [145, 61], [145, 81], [47, 81]], '日本国政府', 0.9942479167118902),
    # Group text detections by lines
lines = []
lines1 = []
line2=[]
line3=[]
line4=[]
line5=[]
current_line = []
dataDict={}
# prev_y = None
for result in text:
    ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = result[0]  # Get the bounding box coordinates
    
    if y4<230:
        lines.append(result)
    elif y4<300:
        lines1.append(result)
    elif y4<400:
        line2.append(result)
    elif y4<500:
        line3.append(result)
    elif y4<500:
        line4.append(result)
    else: 
        line4.append(result)

# print(lines)
prevY=None
prevData=None
name=""
first=lines[0][0][3][1]
for data in lines:
    ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = data[0]  #
    text=data[1] 
    print(text)
    print(y4)
    # print(x4)
    # print(y4)
    if(prevY is not None):
        ((px1,py1), (px2,py2), (px3,py3), (px4,py4)) = prevData[0] 
        if(abs(prevY-y4)<10):
              
            
            if abs(px2-x1)<20:
                if abs(y4-first)<50:
                    name=name+ " "+data[1]
                    dataDict['name']=name
                elif abs(y4-first)>80:
                    dataDict['address']=  data[1]
                else:
                    dataDict['dob']=data[1]
                    print(y4-first)
                    print(data[1]+"\t" +f'{x1}, {y4}')
                print(name)
                print(dataDict)
                
            else: 
                print(data[1]+"\t" +f'{x1}, {y4}')
        else:
            if text.find("番号") != -1:
                dataDict['id']=text
                print(dataDict)
            
            print(data[1]+"\t" +f'{x1}, {y4}')
        prevY=y4
        prevData=data
    else:
        print(data[1]+"\t" +f'{x4}, {y4}')
        prevData=data
        prevY=y4
for data in lines1:

    ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = data[0]  # 
    # print(x4)
    print(y4)
    if(prevY==y4):
        name=data[1]+" "+prevData[1]
        print(name)
        print(data[1]+"\t" +f'{x4}, {y4}')
    else:
        print(data[1]+"\n")
    prevY=y4
    prevData=data
    # print("\n")  
print("\n")  
for data in line2:
    ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = data[0]  #
    print(y4)
    if abs(y4-first)>240:
        dataDict['expiry']=data[1]
    print(dataDict)
    print(data[1])  
    print("\n")  
print("\n")  

for data in line3:
    ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = data[0]  # 
    print(data[1])    
print("\n")  
for data in line4:
    print(data[1])    

print("\n")  
# print(lines1)
# print(line2)
# print(line3)
# print(line4)
# print(text[0])

# prev_y = None
# for result in text:
 
#     ((x1,y1), (x2,y2), (x3,y3), (x4,y4)) = result[0]  # Get the bounding box coordinates
 

#     if prev_y is None:
#         current_line.append(result)
#     # elif y4 - prev_y <= 10:  # Adjust the threshold as per your requirements
#     #     current_line.append(result)
#     # else:
#     #     lines.append(result)
#     #     # current_line = [result]

#     prev_y =y4

#     if current_line:
#         lines.append(current_line) 
        
    #     print(current_line)
# index=0
# print(len(lines))
# for line in lines:
#     for data in line:
#         print(data[1])
#     index+=1
#     print("\n\n")
#     print(index)
    


# dict={}
# for detections in text:
#     if(detections[1].__contains__('番号')):
#         print("id")
#     print(detections[1])