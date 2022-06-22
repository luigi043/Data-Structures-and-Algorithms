using CSV, Tables

#2D Array
A = [1 2; 3 4]
#A = zeros(2, 2)
#print(A)

B = [[1 2 3] ;[4 5 6] ; [7 8 9]]
display(B)
#print(B[3, 3])
tmp      = B[ 1 ]
B[ 1 ]   = B[ 2 ]
B[ 2 ] = tmp

display(B)

CSV.write("C:/Users/Leonil Sulude/JuliaScripts/2021_2022/Fichas/EDA1/FileName.csv",  Tables.table(B), writeheader=false)
