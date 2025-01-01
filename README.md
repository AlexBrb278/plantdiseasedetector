# plantdiseasedetector
A plant disease detector in matlab

Used transferlearning on googlenet, using a plant disease database. This database contains the following classes:
1. Pepper__bell___Bacterial_spot
2. Pepper__bell___healthy
3. Potato___Early_blight
4. Potato___healthy
5. Potato___Late_blight
6. Tomato__Target_Spot
7. Tomato__Tomato_mosaic_virus
8. Tomato__Tomato_YellowLeaf__Curl_Virus
9. Tomato_Bacterial_spot
10. Tomato_Early_blight
11. Tomato_healthy
12. Tomato_Late_blight
13. Tomato_Leaf_Mold
14. Tomato_Septoria_leaf_spot
15. Tomato_Spider_mites_Two_spotted_spider_mite

Created an interface in matlab that responds whether the plant has a disease, is healthy or if it cannot detect anything. If the confidence level is bellow 70% there will be a message that says: Nothing detected, take another picture. If it recognises a disease, it skips to a new page which shows details about the disease, treatments to avoid it and a way to contact local institutions that deal with plant diseases. 
