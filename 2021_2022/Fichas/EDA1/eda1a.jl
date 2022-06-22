"1- a)
Crie uma função designada por bubble_sort() e programe o algoritmo Bubble-Sort(). 
 Em seguida programe o algoritmo de ordenação Insertion-Sort(). 
 Utilize para teste dos algoritmos tabelas aleatórias com distribuição normal de média nula e desvio padrão = 1.0.

b) Utilize o package Plots.jl para criar um gráfico que permite observar as taxas assimptóticas de crescimento dos tempos 
  de execução dos algoritmos de ordenação Bubble-Sort e Insertion-Sort.

c) Obtenha os gráficos com erros relativos para cada ponto representado inferior a 10%."

using Plots

#* Funcao main para guiar os nossos exercicios
function main()
    #* 1-a)
    #Tabela aleatória com distr. normal de,  média 0.0 e desvio padrão 1.0
        #randn por default tem média 0.0. e desvio_padrao 1.0
        #quant = 1000
        #A = randn(quant)


    #* 1-b) Codigo no medir_tempo_ordenacao
       #Medição de tempo para cada um dos algoritmos, 1a vez x tempo, 2a y tempo ...
        n1, bubble_times = medir_tempo_ordenacao!( bubble_sort!) 
        n2, insertion_times = medir_tempo_ordenacao!( insertion_sort!) 

        #Criacao dos graficos x,y
        gr()
        plot(n1, bubble_times, xlabel="n", ylabel="time", label="Bubble-Sort")
        plot!(n2, insertion_times, xlabel="n", ylabel="time", label="Insertion-Sort") 

    #* 1-c) Correr varias vezes e obter uma média que será um ponto, repetir, 
     #* desta forma através da media, teremos o erro relativo em cada ponto
     #!TODO A parte de só ter pontos com 10% abaixo
#=         n1, bubble_times = medir_tempo_ordenacao2!( bubble_sort!) 
        n2, insertion_times = medir_tempo_ordenacao2!( insertion_sort!) 

        #Criacao dos graficos x,y
        gr()
        plot(n1, bubble_times, xlabel="n", ylabel="time (bubble_sort)", label="Bubble-Sort")
        plot!(n2, insertion_times, xlabel="n", ylabel="time (insertion_sort)", label="Insertion-Sort")  =#

end

#* Funções utilizadas pela function main

#1-c)
#!Só devemos guardar os pontos com erro relativo abaixo de 10%?
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
            println("Correndo $k media: ")
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

#1-b)
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

    #Um so valor de media, desvio e erro relativo, este valor de erro relativo será guradddo no gráfico
     #Aumentamos o tamanho do array, até X e guardamos os erros
    return numbers_iter, execution_times
end

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

function main2()
    A =  randn(100)
    #A = [5,5,5,5,5,5,5,5,5,5,5,5,5,5,5] #Para desvio e erro "0"

    med = media(A)
    d = desvio_padrao(A)
    e_r = erro_relativo_percentagem(med, d)
    println("Media: $med\nDesvio P.: $d\nErro Relativo: $e_r")
end
main()

#main2()