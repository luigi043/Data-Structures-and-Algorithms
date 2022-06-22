using Plots
using Distributions

#Utilizado para comparar com o merge
function bubble_sort!(A)
    for i = 1:length( A )
        for j = length( A ):-1:i+1
            if A[ j ] < A[ j-1 ]
                tmp      = A[ j ]
                A[ j ]   = A[ j-1 ]
                A[ j-1 ] = tmp
            end
        end
    end
end

function insertion_sort!( A )
    for j = 2:length( A )
        key = A[ j ]
        i = j - 1
        while i > 0 && A[ i ] > key
            tmp = A[ i + 1 ]
            A[ i + 1 ] = A[ i ]
            A[ i ] = tmp
            i = i - 1
        end
        A[ i+1 ] = key
    end
end


#a) Programe o algoritmo de ordenação Merge-Sort(). 
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

function media( X )
    soma = sum( X )
    μ = soma / length( X )
    return μ
end

function desvio_padrao( X )
    μ = media(X)
    #* .- siginifica soma de cada elemento de X - media ao quadrado (x1 - m)^2 + (x2 - m)^2...
    desvios = (X .- μ).^2
    σ = sqrt(sum(desvios) / length( X ))
end

#* Valor final é em %
function erro_relativo_percentagem(μ, σ)
    #* Formula de erro relativo SEGUNDO abaixo é (desvio_padrao / media) * 100
    ϵ = σ / μ * 100.0
end

function medir_tempo_ordenacao2!(sorting_type)
    array_elements = 10000 #Nr de elementos no array a ser ordenado
    nr_of_calls = 1000 #Nr de chamdas para ordenação
    execution_times = zeros(nr_of_calls) #Array com os tempos de execução
    #numbers_iter = zeros(nr_of_calls) #Array que tera o numero da chamada associada ao tempo de execução

    #Valores para graficos da media
    nr_medias = 5 #Numero de medias 
    nT = zeros(nr_medias)
    medias_dos_tempos = zeros(nr_medias) 

    #Ciclo para obter media por cada conjunto de execuções
    for k = 1:nr_medias
            #Vamos correr nr_of_calls vezes o algoritmo de ordenação, de modo a ver o comportamento da ordenação
            #! Lembrar que arrays em Julia começam em 1
            for n = 1: nr_of_calls #Lembrando que queremos guardar os valores em um array 
                #Criar a tabela aleatória
                A = randn(array_elements)
                execution_times[ n ] = @elapsed sorting_type(A) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
                #numbers_iter[n] = n
            end
        nT[k] = k
        μ = media(execution_times)
        medias_dos_tempos[k] = μ
    end
    return nT, medias_dos_tempos
end

#DEFINE MY MAIN function
function main()
    #= using Random: shuffle
    a = shuffle(collect(1:12))
    println("Unsorted: $a")
    println("Merge sorted: ", merge_sort!(a)) =#

    #b)Produza o gráfico que representa a taxa de crescimento teórica dos tempos de execução.
        #!n1, merge_times = medir_tempo_ordenacao!( merge_sort!) 
        #Criacao dos graficos x,y
        #gr()
        #plot(n1, merge_times, xlabel="n", ylabel="time (merge_sort)", label="Merge-Sort")

    #TODO
    #c) Produza um conjunto de estimativas da taxa de crescimento dos tempos de execução com a sua realização deste algoritmo em programa. 
     # Faça com que cada estimativa apresente um erro relativo inferior a 10%. 
        #!n1, merge_times = medir_tempo_ordenacao2!( merge_sort!) 
        
        #Criacao dos graficos x,y
        #!gr()
        #!plot(n1, merge_times, xlabel="n", ylabel="time (merge_sort)", label="Merge-Sort. ER<10%")
    
     #d) Determine, para uma tabela de valores de vírgula flutuante aleatória, 
       #com distribuição uniforme no intervalo entre -100.0 e 100.0, 
       #qual a dimensão n , em que o algoritmo Merge-Sort() executa 1000 x mais rápido que o algoritmo Bubble-Sort().
        #!n = merge_vs_bubble!()
        #!print("A partir da dimensão $n, Merge-Sort é 1000x mais rápido do que Bubble-Sort!")

    #e) Determine experimentalmente a taxa de crescimento da ocupação de memória para o 
        #algoritmo Merge-Sort() e para o algoritmo Insertion-Sort().
        mem1, merge_memory = medir_memoria!(merge_sort!)
        mem2, insertion_memory = medir_memoria!(insertion_sort!)
        gr()
        plot(mem1, merge_memory, xlabel="n", ylabel="memory ", label="Mem. Merge_sort")
        plot!(mem2, insertion_memory, xlabel="n", ylabel="memory ", label="Mem. Insertion-Sort")

    #Construir os gráficos
end

#Metodo para medir a medir_memoria
function medir_memoria!(sorting_type)
    array_elements = 10000 #Nr de elementos no array a ser ordenado
    nr_of_calls = 2000 #Nr de chamdas para ordenação
    execution_times = zeros(nr_of_calls) #Array com os memorias de execução
    numbers_iter = zeros(nr_of_calls) #Array que tera o numero da chamada associada ao tempo de execução

    #Vamos correr nr_of_calls vezes o algoritmo de ordenação, de modo a ver o comportamento da ordenação
    #! Lembrar que arrays em Julia começam em 1
    for n = 1: nr_of_calls #Lembrando que queremos guardar os valores em um array 
        #Criar a tabela aleatória
        A = randn(array_elements)
        execution_times[ n ] = @allocated sorting_type(A) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
        numbers_iter[n] = n
    end

    return numbers_iter, execution_times
end

function merge_vs_bubble!()
    #nr_of_calls = 1000 #Nr de chamdas para ordenação
    #execution_times = zeros(nr_of_calls) #Array com os tempos de execução
    #numbers_iter = zeros(nr_of_calls) #Array que tera o numero da chamada associada ao tempo de execução
    array_elements = 180000 #Nr de elementos no array a ser ordenado
    min = -100.0 #Valor minimo no array
    max = 100.0 #Valor máximo no array
    valor_de_rapidez = 1000 #O valor que queremos saber que é mais rápido

    #Variaveis com o somatório dos tempos
    time_merge = 0
    time_bubble = 0
    total_time = 0 
    count = 0

    while total_time < valor_de_rapidez
        #Incrementar
        count = count + 1

        #Criar os arrays
        A = rand(Uniform(min, max) ,array_elements)
        B = deepcopy(A); #Deepcoy para testar com array com mesmos elementos

        #Somar cada um dos tempos
        time_merge =  time_merge + @elapsed merge_sort!(A) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
        time_bubble =  time_bubble + @elapsed bubble_sort!(B) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
        total_time =  time_bubble / time_merge #Dividir o Bubble pelo Merge já que o merge é mais rápido, se for ao contrario, teremos valores abaixo de 0
        println("$count: $total_time, Merge: $time_merge & Bubble: $time_bubble")
    end

    return count

end

#Criar metodo que usa bubble e merge 

#Call main 
main()