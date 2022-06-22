using Plots

#Alinea A
function quicksort!(A,i=1,j=length(A))
    if j > i
        pivot = A[rand(i:j)] # random element of A
        left, right = i, j
        while left <= right
            while A[left] < pivot
                left += 1
            end
            while A[right] > pivot
                right -= 1
            end
            if left <= right
                A[left], A[right] = A[right], A[left]
                left += 1
                right -= 1
            end
        end
        quicksort!(A,i,right)
        quicksort!(A,left,j)
    end
    return A
end


#Funcao auxiliar
function merge_sort!(arr)
    if length(arr) <= 1
        return arr
    end

    #The trunc() is an inbuilt function in julia which is used to return the nearest integral value of the same type as the specified value x
    middle = trunc(Int, length(arr) / 2) 
    L = arr[1:middle]
    R = arr[middle+1:end]

    merge_sort!(L)
    merge_sort!(R)

    i = j = k = 1
    while i <= length(L) && j <= length(R)
        if L[i] < R[j]
            arr[k] = L[i]
            i+=1
        else
            arr[k] = R[j]
            j+=1
         end
         k+=1
     end

     while i <= length(L)
          arr[k] = L[i]
          i+=1
          k+=1
      end
      
      while j <= length(R)
          arr[k] = R[j]
          j+=1
          k+=1
      end
      arr
end

function medir_tempo_ordenacao!(sorting_type)
    array_elements = 10000 #Nr de elementos no array a ser ordenado
    nr_of_calls = 1000 #Nr de chamdas para ordenação
    execution_times = zeros(nr_of_calls) #Array com os tempos de execução
    numbers_iter = zeros(nr_of_calls) #Array que tera o numero da chamada associada ao tempo de execução

    #Vamos correr nr_of_calls vezes o algoritmo de ordenação, de modo a ver o comportamento da ordenação
    #! Lembrar que arrays em Julia começam em 1
    for n = 1: nr_of_calls #Lembrando que queremos guardar os valores em um array 
        #Criar a tabela aleatória
        A = randn(array_elements)
        execution_times[ n ] = @elapsed sorting_type(A) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
        numbers_iter[n] = n
    end

    return numbers_iter, execution_times
end

#MAIN
function main()
    #4.2 Compare experimentalmente o desempenho computacional do algoritmo Quick-Sort com o algoritmo Merge-Sort. 
        #Meça os tempos de execução e meça as necessidades de memória. Produza os gráficos correspondentes.
        n1, merge_times = medir_tempo_ordenacao!( merge_sort!) 
        n2, quick_times = medir_tempo_ordenacao!( quicksort!) 

        gr()
        plot(n1, merge_times, xlabel="n", ylabel="time ", label="Merge_sort")
        plot!(n2, quick_times, xlabel="n", ylabel="time ", label="Quick Sort")  

    #4.3 Programe a versão aleatorizada do algoritmo Quick-Sort.
        
end

#Chamar main
main()