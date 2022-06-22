using Plots

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

#3.a) Programe o algoritmo Heap-Sort().
function heapsort!(a)
    n = length(a)
    heapify!(a, n)
    l = n
    while l > 1 
        swap(a, 1, l)
        l -= 1
        pd!(a, 1, l)
    end
    return a
end

function swap(a, i, j)
    a[i], a[j] = a[j], a[i] 
end
 
function pd!(a, first, last)
    while (c = 2 * first - 1) < last
        if c < last && a[c] < a[c + 1]
            c += 1
        end
        if a[first] < a[c]
            swap(a, c, first)
            first = c
        else
            break
        end
    end
end
 
function heapify!(a, n)
    f = div(n, 2)
    while f >= 1 
        pd!(a, f, n)
        f -= 1 
    end
end

#-------
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

function medir_tempo_ordenacao!(A, sorting_type)
    nr_of_calls = 1000 #Nr de chamdas para ordenação
    execution_times = zeros(nr_of_calls) #Array com os tempos de execução
    numbers_iter = zeros(nr_of_calls) #Array que tera o numero da chamada associada ao tempo de execução

    #Vamos correr nr_of_calls vezes o algoritmo de ordenação, de modo a ver o comportamento da ordenação
    #! Lembrar que arrays em Julia começam em 1
    for n = 1: nr_of_calls #Lembrando que queremos guardar os valores em um array 
        #Criar a tabela aleatória
        #Pedir array de acordo com o tipo de cenário
        execution_times[ n ] = @elapsed sorting_type(A) #Passamos o array e vamos ver quanto tempo levou a ordenar, e guardamos e um array o tempo
        numbers_iter[n] = n
    end

    return numbers_iter, execution_times
end

#Array by scenario
function get_array_by_scenario(tipo_cenario, array_elements)
    if(tipo_cenario == "melhor")

        #Melhor cenario, array ordenado, forma crescente
        A = zeros(array_elements)
        index = 1 #Indice a começar em 1 para ir ocupanda a partir da 1ª pos do array
        for n = 1:array_elements
            A[index] = n
            index = index + 1
        end
        return A

    elseif (tipo_cenario == "pior")
    #Pior cenario, array ordenado de forma contraria, descrescente
        #Inicializar o array com 0 de forma a ir preenchendo os numeros que pretendemos
        A = zeros(array_elements)
        index = 1 #Indice a começar em 1 para ir ocupanda a partir da 1ª pos do array
        for n = reverse(1:array_elements)
            A[index] = n
            index = index + 1
        end
        return A
    else
        #Caso aleatório, array ordenado de qualquer maneira, sem parâmetros
        inicio = 1 
        fim = 1000
        A = rand(inicio : fim, array_elements)
        return A
    end
end

#DEFINE MY MAIN function
function main()
    #= using Random: shuffle
    a = shuffle(collect(1:12))
    println("Unsorted: $a")
    println("Heap sorted: ", heapsort!(a)) =#

    #b) 3.2 Meça experimentalmente as taxas de crescimento do tempo de execução para o melhor cenário, 
        #pior cenário e caso aleatório. Produza um gráfico correspondente.
        #!PERGUTAR PROF Porque quando reutilizamos A como array aumenta tempo
        #!e SE pioe, melhor e aleatorio é mesmo assim, cenário aleatorio sempre tem melhor tempo
        #alineaB()

    #c) 3.3 Compare os tempos de execução do algoritmo Heap-Sort com os tempos de execução do algoritmo Merge-Sort. 
        alineaC()
end

#alinea a
function alineaB()
    #*Melhor cenário
    array_elements = 10000 #Nr de elementos no array a ser ordenado

    A = get_array_by_scenario("melhor", array_elements)
    display(A)
    melhor, melhor_heap_times = medir_tempo_ordenacao!( A, heapsort!) 
    
    #*Pior cenário
    B = get_array_by_scenario("pior", array_elements)
    display(B)
    pior, pior_heap_times = medir_tempo_ordenacao!(B, heapsort!) 
    
    #*Cenário aleatório
    C = get_array_by_scenario("normal", array_elements)
    display(C)
    aleatorio, aleatorio_heap_times = medir_tempo_ordenacao!(C, heapsort!) 

    #Criacao dos graficos x,y
    gr()
    plot(melhor, melhor_heap_times, xlabel="n", ylabel="time ", label="Melhor_Heap-Sort")
    plot!(pior, pior_heap_times, xlabel="n", ylabel="time ", label="Pior_Heap-Sort")
    plot!(aleatorio, aleatorio_heap_times, xlabel="n", ylabel="time", label="Aleatorio_Heap-Sort")
end

function alineaC()
    n1, merge_times = medir_tempo_ordenacao!( merge_sort!) 
    n2, heap_times = medir_tempo_ordenacao!( heapsort!) 
    gr()
    plot(n1, merge_times, xlabel="n", ylabel="time ", label="Merge_sort")
    plot!(n2, heap_times, xlabel="n", ylabel="time ", label="Heap Sort")    
end
#Call main 
main()