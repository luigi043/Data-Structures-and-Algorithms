using Random
using Plots

function media( X )
    soma = sum( X )
    μ = soma / length( X )
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

function bubble_sort( A )
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

function insertion_sort( A )
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

function medir_tempos( sort )

    M = 300 # número de amostras
    X = zeros( M )

    n1 = 200 #valor inicial
    n2 = 4000 #valor final 
    ΔN = 100 #valor a incrementar entre n1 e n2
    
    #* Funcao convert deve fazer alguma coisa que deixa preparada para o array receber o tipo ideial
    T = zeros(convert(Int64, (n2-n1)/ΔN)+1)
    N = zeros(convert(Int64, (n2-n1)/ΔN)+1)
    
    k = 1
    for n = n1:ΔN:n2
        for k = 1:M
            A = rand( n )
            # @elapsed usado para calcular tempo de execução da função de forma correta
            Δt = @elapsed sort( A )
            X[ k ] = Δt
        end
        
        μ = media( X )
        σ = desvio_padrao( X )
        ϵ = erro_relativo_percentagem( μ, σ )
        println("n = $n, μ = $μ, σ = $σ, ϵ = $ϵ")
        N[ k ] = n
        T[ k ] = μ # média dos tempos de execução para uma amostra M elementos
        k += 1
    end
    N, T
end

Ni, Ti = medir_tempos( insertion_sort )
Nb, Tb = medir_tempos( bubble_sort )

gr()
plot(Ni, Ti, xlabel="n", ylabel="time (s)", label="Insertion-Sort")
plot!(Nb, Tb, label="Bubble-Sort")

