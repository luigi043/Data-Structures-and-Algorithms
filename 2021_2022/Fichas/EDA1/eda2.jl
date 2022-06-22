#= 2- 
a) Na pasta EDA1 crie um ficheiro designado por eda2.jl. Leia um ficheiro de dados, 
em formato csv, em que em cada linha tem o número mecanográfico dum aluno, o seu nome completo, 
e a sua data de nascimento.

b) Demonstre o funcionamento dos algoritmos de ordenação que realizou com este ficheiro de dados. =#

using CSV
using DataFrames
using Tables

#Testar bubbble sort 
function bubble_sort!(A)
    for i = 1:size( A )[1]
        for j = size( A )[1]:-1: i+1
            #Swap code, verify in specific column, but change entire row
            if A[ j ][1] < A[ j-1 ][1] #Ir buscar o que está na coluna 1 que são os numeros dos alunos
                #Apply swap
                tmp         = A[ j , :]
                A[ j , :]   = A[ j-1 , :]
                A[ j-1 , :] = tmp
            end
        end
    end
end

function insertion_sort!( A )
    for j = 2:size(A)[1] #Buscar tamanho das linhas, se fosse coluna, seria "size(A)[2]"
        key = A[ j , 1 ] #Ir buscar o que está na coluna 1 que são os numeros dos alunos
        i = j - 1
        while i > 0 && A[ i , 1 ] > key #Comparar só com valores da 1a coluna, o de cima dá erro porque compara int64 com vector any
        #while isless(0, i) && A[ i , 1 ] > key #Comparar só com valores da 1a coluna, usar isless pode ser melhor, pois não podemos converter o array para Int64
            #Trocar as linhas
            tmp = A[ i + 1, :]
            A[ i + 1, :] = A[ i , :]
            A[ i , :] = tmp
            i = i - 1
        end
        A[ i+1, 1] = key #Não esquecer que key é o numero de aluno, logo, está na 1a coluna
    end
end

function main()
#Caminho completo do ficheiro    
file = "C:/Users/Leonil Sulude/JuliaScripts/2021_2022/Fichas/EDA1/data.csv"

# reading the csv file without header (é só colocar header=0)
df = CSV.read(file, DataFrame, header=0)

#Converter dataframe para array (as duas linhas de Codigo abaixo funcionam, convertem para matriz)
matr1 = Tables.matrix(df)
matr2 = Tables.matrix(df)

   
    #* TESTING SWAP code for BUBBLE SORT
    println("Before Swap (Bubbble): ")
    display(matr1)

    println("After Swap (Bubbble): ")
    println()
    bubble_sort!(matr1)
    println()
    display(matr1)

    println("------------------------------------")

    #* TESTING SWAP code for INSERTION SORT
    println("Before Swap (Insertion): ")
    display(matr2)

    println("After Swap (Inserion): ")
    insertion_sort!(matr2)
    println()
    display(matr2)

    #* Código para escrever no ficheiro
    #CSV.write("C:/Users/Leonil Sulude/JuliaScripts/2021_2022/Fichas/EDA1/FileName.csv",  Tables.table(B), writeheader=false)

end

#Chamar main
main()




